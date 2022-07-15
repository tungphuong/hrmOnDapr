using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Configurations;
using DotNet.Testcontainers.Containers;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace Admin.FunctionalTests;

public class FunctionalTestFactory<TProgram, TDbContext> : WebApplicationFactory<TProgram>, IAsyncLifetime
    where TProgram : class where TDbContext : DbContext
{
    private readonly TestcontainerDatabase _container;

    public FunctionalTestFactory()
    {
        _container = new TestcontainersBuilder<PostgreSqlTestcontainer>()
           .WithDatabase(new PostgreSqlTestcontainerConfiguration
           {
               Database = "admin-db",
               Username = "postgres",
               Password = "postgres",
           })            
           .WithImage("postgres:14-alpine")
           .WithCleanUp(true)            
           .Build();
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
      builder.ConfigureTestServices(services =>
      {
          services.RemoveDbContext<TDbContext>();
          services.AddDbContext<TDbContext>(options => { options.UseNpgsql(_container.ConnectionString); });
          services.EnsureDbCreated<TDbContext>();
      });
    }

    public async Task InitializeAsync() => await _container.StartAsync();

    public new async Task DisposeAsync() => await _container.DisposeAsync();
}
