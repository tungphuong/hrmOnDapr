using Microsoft.EntityFrameworkCore;
using Admin.Api.Infrastructure;
using Admin.Api.Application.ActivityAudit.Queries;
using Admin.Api.Infrastructure.Repositories;
using Admin.Api.Domain;

namespace Admin.UnitTests;

public class ActivityAuditTest
{
    private readonly DbContextOptions<AdminDbContext> _dbOptions;

    public ActivityAuditTest()
    {
        _dbOptions = new DbContextOptionsBuilder<AdminDbContext>()
            .UseInMemoryDatabase(databaseName: "in-memory")
            .Options;
        using var dbContext = new AdminDbContext(_dbOptions);
        dbContext.AddRange(GetFakeActivityAudits());
        dbContext.SaveChanges();
    }

    [Fact]
    public async Task Get_Activity_Audit_By_Id_Success()
    {
        var activityAuditRepository = new ActivityAuditRepository(new AdminDbContext(_dbOptions));

        var sut = new GetActivityAuditQueryHandler(activityAuditRepository);

        var result = await sut.Handle(new GetActivityAuditQuery
        {
            Id = 1
        }, default(CancellationToken));

        Assert.NotNull(result);
        Assert.Equal("user1", result?.ActBy);
    }

    private List<ActivityAudit> GetFakeActivityAudits()
    {
        return new List<ActivityAudit>()
        {
            new ActivityAudit{
                Id = 1,
                ActBy = "user1",
                IP = "10.0.0.1",
                Browser = "Chrome"
            },
            new ActivityAudit{
                Id = 2,
                ActBy = "user2",
                IP = "10.0.0.2",
                Browser = "Edge"
            },
        };
    }
}