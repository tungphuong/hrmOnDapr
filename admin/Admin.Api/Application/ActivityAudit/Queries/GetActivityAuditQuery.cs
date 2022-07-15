using Admin.Api.Domain;
using MediatR;

namespace Admin.Api.Application.ActivityAudit.Queries;

public record GetActivityAuditQuery : IRequest<ActivityAuditDto>
{
    public int Id { get; set; }
}

public record ActivityAuditDto(int Id, string ActBy, string? IP, string? Browser);

public class GetActivityAuditQueryHandler : IRequestHandler<GetActivityAuditQuery, ActivityAuditDto?>
{
    private readonly IActivityAuditRepository _activityAuditRepository;

    public GetActivityAuditQueryHandler(IActivityAuditRepository activityAuditRepository)
    {
        this._activityAuditRepository = activityAuditRepository;
    }
    public async Task<ActivityAuditDto?> Handle(GetActivityAuditQuery request, CancellationToken cancellationToken)
    {
        var activity = await _activityAuditRepository.GetActivityAuditByIdAsync(request.Id);
        return activity != null
            ? new ActivityAuditDto(activity.Id, activity.ActBy, activity.IP, activity.Browser)
            : null;
    }
}
