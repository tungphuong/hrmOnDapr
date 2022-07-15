using MediatR;

namespace EmployeeManagement.Api.Application.Queries;
public record GetEmployeeByIdQuery(Guid EmployeeId ) : IRequest<GetEmployeeByIdDto>;

public record GetEmployeeByIdDto(Guid employeeId, string firstname, string lastName);

public class CreateNewEmployeeHandler : IRequestHandler<GetEmployeeByIdQuery, GetEmployeeByIdDto>
{
    public Task<GetEmployeeByIdDto> Handle(GetEmployeeByIdQuery request, CancellationToken cancellationToken)
    {
        return Task.FromResult(new GetEmployeeByIdDto(Guid.NewGuid(), "User", "Smith"));
    }
}