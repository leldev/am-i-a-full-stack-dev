using LEL.Resume.Api.Features;

namespace LEL.Resume.Api.Extensions;

public static class WebApplicationExtension
{
    public static void RegisterEndpointDefinitions(this WebApplication app)
    {
        var endpointDefinitions = typeof(Program).Assembly.GetTypes()
            .Where(t => t.IsAssignableTo(typeof(IEndpointDefinition)) && !t.IsAbstract && !t.IsInterface)
            .Select(Activator.CreateInstance)
            .Cast<IEndpointDefinition>()
            .ToList();

        endpointDefinitions.ForEach(x => x.RegisterEndpoints(app));
    }
}
