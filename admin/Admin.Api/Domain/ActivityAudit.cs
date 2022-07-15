namespace Admin.Api.Domain;

public class ActivityAudit
{
    public int Id { get; set; }
    public string ActBy { get; set; } = String.Empty;
    public string? IP { get; set; }
    public string? Browser { get; set; }
}