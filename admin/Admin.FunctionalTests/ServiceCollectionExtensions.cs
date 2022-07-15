using Admin.Api.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace Admin.FunctionalTests;

public static class ServiceCollectionExtensions
{
    public static void RemoveDbContext<T>(this IServiceCollection services) where T : DbContext
    {
        var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<T>));
        if (descriptor != null) services.Remove(descriptor);
    }

    public static void EnsureDbCreated<T>(this IServiceCollection services) where T : DbContext
    {
        var serviceProvider = services.BuildServiceProvider();

        using var scope = serviceProvider.CreateScope();
        var scopedServices = scope.ServiceProvider;
        var context = scopedServices.GetRequiredService<T>();
        context.Database.EnsureCreated();

        SeedTestData(context as AdminDbContext);
    }

    private static void SeedTestData(AdminDbContext? dbContext)
    {
        if(dbContext is null) throw new Exception("AdminDbContext cannot be null!");

        dbContext.ActivityAudits.Add(new Api.Domain.ActivityAudit()
        {
            ActBy = "UserTest",
            IP = "10.0.0.1",
            Browser = "Edge"
        });

        dbContext.SaveChanges();
    }
}
