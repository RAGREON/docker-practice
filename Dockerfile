# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

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

# Install EF tool and create bundle
RUN dotnet tool install --global dotnet-ef --version 9.0.0
ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet ef migrations bundle --project "DockerPractice.csproj" \
  -o /app/publish/migrate \
  --runtime linux-x64 \
  --self-contained

# Stage 3: Final Runtime
# Using the 'aspnet' runtime image for a smaller footprint
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerPractice.dll"]

# Stage 4: Migration Runner
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS migration-runner
WORKDIR /app
COPY --from=publish /app/publish/migrate .
ENTRYPOINT ["./migrate"]