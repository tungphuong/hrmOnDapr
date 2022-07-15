using System.Reflection;
using EmployeeManagement.Api.Application.Interfaces;
using EventBus;
using MediatR;
using Refit;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddScoped<IEventBus, DaprEventBus>();
builder.Services.AddMediatR(Assembly.GetExecutingAssembly());
builder.Services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
builder.Services
    .AddControllers()
    .AddDapr();
builder.Services.AddHealthChecks();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register http client factory
builder.Services
    .AddRefitClient<IAdminApi>()
    .ConfigureHttpClient(httpClient =>
    {            
        httpClient.BaseAddress = new Uri(builder.Configuration["Services:Admin:Url"]);
    });
builder.Services
    .AddRefitClient<ICommunicationApi>()
    .ConfigureHttpClient(httpClient =>
    {
        httpClient.BaseAddress = new Uri(builder.Configuration["Services:Communication:Url"]);
    });

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

app.MapHealthChecks("/healthz");
app.MapControllers();

app.Run();
