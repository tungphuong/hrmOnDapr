using MediatR;

namespace Admin.Api.Application.ActivityAudit.Commands;
public record WriteActivityAuditCommand : IRequest<WriteActivityAuditDto>
{

}

public record WriteActivityAuditDto(Guid Id);

public class WriteActivityAuditHandler : IRequestHandler<WriteActivityAuditCommand, WriteActivityAuditDto>
{
    private readonly ILogger<WriteActivityAuditHandler> _logger;
    public WriteActivityAuditHandler(ILogger<WriteActivityAuditHandler> logger)
    {
        this._logger = logger;

    }
    public Task<WriteActivityAuditDto> Handle(WriteActivityAuditCommand request, CancellationToken cancellationToken)
    {
        _logger.LogInformation("Begin to write activity audit log");
        
        return Task.FromResult(new WriteActivityAuditDto(Guid.NewGuid()));
    }
}
