using EventBus;

namespace EmployeeManagement.Api.IntegrationEvents;

public record NewEmployeeCreatedIntegrationEvent(Guid EmployeeId, string Firstname) : IntegrationEvent;