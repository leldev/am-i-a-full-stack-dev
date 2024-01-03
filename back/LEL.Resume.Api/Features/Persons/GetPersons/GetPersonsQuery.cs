using AutoMapper;
using LEL.Resume.Api.Data;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace LEL.Resume.Api.Features.Persons.GetPersons;

public sealed record GetPersonsQuery : IRequest<IReadOnlyList<GetPersonsResponse>>;

public sealed class GetPersonsQueryHandler : IRequestHandler<GetPersonsQuery, IReadOnlyList<GetPersonsResponse>>
{
    private readonly DefaultDbContext dbContext;
    private readonly IMapper mapper;

    public GetPersonsQueryHandler(DefaultDbContext dbContext, IMapper mapper)
    {
        this.dbContext = dbContext;
        this.mapper = mapper;
    }

    public async Task<IReadOnlyList<GetPersonsResponse>> Handle(GetPersonsQuery request, CancellationToken cancellationToken)
    {
        var persons = await dbContext.Persons.AsNoTracking().ToListAsync(cancellationToken);

        var dto = mapper.Map<IReadOnlyList<GetPersonsResponse>>(persons);

        return dto;
    }
}