using LEL.Resume.Api.Data;
using LEL.Resume.Api.Extensions;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);
var configuration = builder.Configuration;
var environment = builder.Environment;

var services = builder.Services;

services.AddCors();
services.AddEndpointsApiExplorer();
services.AddSwaggerGen();
services.AddAutoMapper(typeof(Program));
services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Program).Assembly));

services.AddDbContext<DefaultDbContext>(options =>
{
    options.UseSqlServer(configuration.GetConnectionString(DefaultDbContext.ConnectionStringName), sqlServerOptions => sqlServerOptions.EnableRetryOnFailure(3));
});

var app = builder.Build();

if (environment.IsDevelopment())
{
    app.UseCors(options =>
    {
        options.AllowAnyOrigin(); options.AllowAnyMethod(); options.AllowAnyHeader();
    });
}

app.UseSwagger();
app.UseSwaggerUI();
app.UseHttpsRedirection();

app.RegisterEndpointDefinitions();

app.Run();
