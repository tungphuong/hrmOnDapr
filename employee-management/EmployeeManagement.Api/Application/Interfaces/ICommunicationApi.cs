using Refit;

namespace EmployeeManagement.Api.Application.Interfaces;
public interface ICommunicationApi
{
    [Post("/email")]
    Task SendEmail();
}
