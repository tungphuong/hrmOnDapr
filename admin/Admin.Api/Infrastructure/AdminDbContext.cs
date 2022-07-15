using Admin.Api.Infrastructure.EntityConfigurations;
using Admin.Api.Domain;
using Microsoft.EntityFrameworkCore;

namespace Admin.Api.Infrastructure;

public class AdminDbContext: DbContext
{
    public DbSet<ActivityAudit> ActivityAudits => Set<ActivityAudit>();
    
    public AdminDbContext(DbContextOptions<AdminDbContext> options) : base(options)
    {        
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfiguration(new ActivityAuditEntityTypeConfiguration());
    }
}
