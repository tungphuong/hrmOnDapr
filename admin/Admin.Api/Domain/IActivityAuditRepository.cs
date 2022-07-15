namespace Admin.Api.Domain;

public interface IActivityAuditRepository
{
    Task<ActivityAudit?> GetActivityAuditByIdAsync(int id);
}
