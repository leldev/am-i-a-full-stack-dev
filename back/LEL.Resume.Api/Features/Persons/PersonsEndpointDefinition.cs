using LEL.Resume.Api.Features.Persons.GetPerson;
using LEL.Resume.Api.Features.Persons.GetPersons;
using MediatR;

namespace LEL.Resume.Api.Features.Persons;

public sealed class PersonsEndpointDefinition : IEndpointDefinition
{
    public void RegisterEndpoints(WebApplication app)
    {
        var rest = app.MapGroup("/api/persons");

        rest.MapGet("/", GetAll).Produces<IReadOnlyList<GetPersonsResponse>>();

        rest.MapGet("/{id}", GetById).Produces<GetPersonResponse>();
    }

    private async Task<IResult> GetAll(IMediator mediator, [AsParameters] GetPersonsQuery request)
    {
        var persons = await mediator.Send(request);

        return Results.Ok(persons);
    }

    private async Task<IResult> GetById(IMediator mediator, [AsParameters] GetPersonQuery request)
    {
        var person = await mediator.Send(request);

        return person is null ? Results.NotFound() : Results.Ok(person);
    }
}
