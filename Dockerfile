# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

# Copy csproj and restore dependencies
# Doing this separately allows Docker to cache layers
COPY ["DockerPractice.csproj", "./"]
RUN dotnet restore "DockerPractice.csproj"

# Copy the rest of the code and build
COPY . .
RUN dotnet build "DockerPractice.csproj" -c Release -o /app/build

# Stage 2: Publish
FROM build AS publish
RUN dotnet publish "DockerPractice.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Final Runtime
# Using the 'aspnet' runtime image for a smaller footprint
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerPractice.dll"]