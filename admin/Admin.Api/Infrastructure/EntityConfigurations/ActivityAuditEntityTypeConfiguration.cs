
using Admin.Api.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Admin.Api.Infrastructure.EntityConfigurations;
public class ActivityAuditEntityTypeConfiguration : IEntityTypeConfiguration<ActivityAudit>
{
    public void Configure(EntityTypeBuilder<ActivityAudit> builder)
    {
        builder.ToTable("activity_audits");

        builder.HasKey(a => a.Id);
    }
}
