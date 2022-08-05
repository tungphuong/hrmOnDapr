using EmployeeManagement.Api.Application.Interfaces;
using EmployeeManagement.Api.IntegrationEvents;
using EventBus;
using MediatR;

namespace EmployeeManagement.Api.Application.Commands;
public record CreateNewEmployeeCommand(string FirstName, string LastName) : IRequest<CreateNewEmployeeDto>;

public record CreateNewEmployeeDto(Guid EmployeeId);

public class CreateNewEmployeeHandler : IRequestHandler<CreateNewEmployeeCommand, CreateNewEmployeeDto>
{
    private readonly IAdminApi _adminApi;
    private readonly ICommunicationApi _communicationApi;
    private readonly IEventBus _eventBus;
    private readonly IConfiguration _configuration;

    public CreateNewEmployeeHandler(IAdminApi adminApi,
        ICommunicationApi communicationApi,
        IEventBus eventBus,
        IConfiguration configuration)
    {
        this._adminApi = adminApi;
        this._communicationApi = communicationApi;
        this._eventBus = eventBus;
        this._configuration = configuration;
    }
    public async Task<CreateNewEmployeeDto> Handle(CreateNewEmployeeCommand request, CancellationToken cancellationToken)
    {
        await _adminApi.WriteActivityAuditAsync();

        await _communicationApi.SendEmail();
        var employeeId = Guid.NewGuid();
        
        if (bool.Parse(_configuration["ENABLE_DAPR"]))
        {            
            await _eventBus.PublishAsync(new NewEmployeeCreatedIntegrationEvent(employeeId, request.FirstName));
        }

        return new CreateNewEmployeeDto(employeeId);
    }
}