using System.Net;
using Admin.Api.Application.ActivityAudit.Commands;
using Admin.Api.Application.ActivityAudit.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Admin.Api.Controllers;

[ApiController]
[Route("[controller]")]
public class ActivityAuditController : ControllerBase
{
    private readonly ILogger<ActivityAuditController> _logger;
    private readonly ISender _mediator;

    public ActivityAuditController(ILogger<ActivityAuditController> logger, ISender mediator)
    {
        _logger = logger;
        _mediator = mediator;
    }

    [Route("{id:int}")]
    [HttpGet]
    [ProducesResponseType(typeof(ActivityAuditDto), (int)HttpStatusCode.OK)]
    [ProducesResponseType((int)HttpStatusCode.NotFound)]
    public async Task<ActionResult<ActivityAuditDto>> GetActivityAudit(int id)
    {
        var activityAudit = await _mediator.Send(new GetActivityAuditQuery
        {
            Id = id
        });
        return activityAudit != null
            ? Ok(activityAudit)
            : NotFound();
    }

    [HttpPost]
    [ProducesResponseType(typeof(WriteActivityAuditDto), (int)HttpStatusCode.OK)]
    [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
    public async Task<ActionResult<WriteActivityAuditDto>> WriteActivityAudit()
    {
        var result = await _mediator.Send(new WriteActivityAuditCommand());
        return Ok(result);
    }
}
