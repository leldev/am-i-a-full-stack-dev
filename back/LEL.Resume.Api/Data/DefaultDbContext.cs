using LEL.Resume.Api.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace LEL.Resume.Api.Data;

public sealed class DefaultDbContext(DbContextOptions<DefaultDbContext> options) : DbContext(options)
{
    public const string ConnectionStringName = "Default";

    public DbSet<Person> Persons => this.Set<Person>();

    protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder)
    {
        // configurationBuilder.Properties<DateOnly>().HaveConversion<DateOnlyConverter>();
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(DefaultDbContext).Assembly);

        base.OnModelCreating(modelBuilder);
    }
}