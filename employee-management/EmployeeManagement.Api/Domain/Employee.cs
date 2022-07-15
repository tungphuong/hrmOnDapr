namespace EmployeeManagement.Api.Domain;

public class Employee
{
    public Guid EmployeeId { get; set; }
    public string Firstname { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
}
