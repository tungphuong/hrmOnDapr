using Refit;

namespace EmployeeManagement.Api.Application.Interfaces;

public interface IAdminApi
{
    [Post("/ActivityAudit")]
    Task WriteActivityAuditAsync();
}
