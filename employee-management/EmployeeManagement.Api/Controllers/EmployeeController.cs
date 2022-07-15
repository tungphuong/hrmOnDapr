using System.Net;
using EmployeeManagement.Api.Application.Commands;
using EmployeeManagement.Api.Application.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace EmployeeManagement.Api.Controllers;

[ApiController]
[Route("[controller]")]
public class EmployeeController : ControllerBase
{
    private readonly ILogger<EmployeeController> _logger;
    private readonly ISender _mediator;

    public EmployeeController(ILogger<EmployeeController> logger, ISender mediator)
    {
        this._mediator = mediator;
        _logger = logger;
    }

    [HttpPost]
    [ProducesResponseType(typeof(CreateNewEmployeeDto), (int)HttpStatusCode.OK)]
    public async Task<CreateNewEmployeeDto> CreateNewEmployee()
    {
        return await _mediator.Send(new CreateNewEmployeeCommand("User", "Smith"));
    }

    [Route("{employeeId:guid}")]
    [HttpGet]
    [ProducesResponseType(typeof(GetEmployeeByIdDto), (int)HttpStatusCode.OK)]
    public async Task<GetEmployeeByIdDto> GetEmployeeByIdAsync(Guid employeeId)
    {
        return await _mediator.Send(new GetEmployeeByIdQuery(employeeId));
    }
}