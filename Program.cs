using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

string? PG_CONNECTION_STRING = builder.Configuration.GetConnectionString("PG_CONNECTION_STRING"); 

builder.Services.AddDbContext<AppDbContext>(options =>
{
  options.UseNpgsql(PG_CONNECTION_STRING);
});

builder.Services.AddSwaggerGen();
builder.Services.AddControllers();

var app = builder.Build();

app.MapControllers();

app.UseSwagger();
app.UseSwaggerUI();

app.Run();
