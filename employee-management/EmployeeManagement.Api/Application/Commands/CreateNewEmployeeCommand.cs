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

    public CreateNewEmployeeHandler(IAdminApi adminApi, 
        ICommunicationApi communicationApi,
        IEventBus eventBus)
    {
        this._adminApi = adminApi;
        this._communicationApi = communicationApi;
        this._eventBus = eventBus;
    }
    public async Task<CreateNewEmployeeDto> Handle(CreateNewEmployeeCommand request, CancellationToken cancellationToken)
    {
        await _adminApi.WriteActivityAuditAsync();
        
        await _communicationApi.SendEmail();
        var employeeId = Guid.NewGuid();
        await _eventBus.PublishAsync(new NewEmployeeCreatedIntegrationEvent(employeeId, request.FirstName));

        return new CreateNewEmployeeDto(employeeId);
    }
}