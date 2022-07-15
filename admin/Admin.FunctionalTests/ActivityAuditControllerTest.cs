using Admin.Api.Infrastructure;

namespace Admin.FunctionalTests;

public class ActivityAuditControllerTest : IClassFixture<FunctionalTestFactory<Program, AdminDbContext>>
{
    private readonly FunctionalTestFactory<Program, AdminDbContext> _factory;

    public ActivityAuditControllerTest(FunctionalTestFactory<Program, AdminDbContext> factory) => _factory = factory;

    [Fact]
    public async Task Get_Activity_Audit_By_Id_Success()
    {
        var client = _factory.CreateClient();
        var response = await client.GetAsync("ActivityAudit/1");

        response.EnsureSuccessStatusCode();
    }
}