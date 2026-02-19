using Microsoft.EntityFrameworkCore;

public class AppDbContextFactory : IDbContextFactory<AppDbContext>
{
  public AppDbContext CreateDbContext()
  {
    var optionsBuilder = new DbContextOptionsBuilder<AppDbContext>();
    optionsBuilder.UseNpgsql("Host:localhost;Database=MigrationBuildOnly;");

    return new AppDbContext(optionsBuilder.Options);
  }
}