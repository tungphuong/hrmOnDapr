using Admin.Api.Domain;
using Microsoft.EntityFrameworkCore;

namespace Admin.Api.Infrastructure.Repositories;

public class ActivityAuditRepository : IActivityAuditRepository
{
        private readonly AdminDbContext _dbContext;
    public ActivityAuditRepository(AdminDbContext dbContext)
    {
            this._dbContext = dbContext;
        
    }
    public Task<ActivityAudit?> GetActivityAuditByIdAsync(int id)
    {
        return _dbContext.ActivityAudits
            .Where(x => x.Id == id)
            .SingleOrDefaultAsync();
    }
}
