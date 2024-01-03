using AutoMapper;
using LEL.Resume.Api.Data;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LEL.Resume.Api.Features.Persons.GetPerson;

public sealed record GetPersonQuery : IRequest<GetPersonResponse>
{
    public int Id { get; set; }
}

public sealed class GetPersonsQueryHandler : IRequestHandler<GetPersonQuery, GetPersonResponse>
{
    private readonly DefaultDbContext dbContext;
    private readonly IMapper mapper;

    public GetPersonsQueryHandler(DefaultDbContext dbContext, IMapper mapper)
    {
        this.dbContext = dbContext;
        this.mapper = mapper;
    }

    public async Task<GetPersonResponse> Handle(GetPersonQuery request, CancellationToken cancellationToken)
    {
        var person = await dbContext.Persons.AsNoTracking()
            .Where(x => x.Id == request.Id)
            .FirstOrDefaultAsync(cancellationToken);

        var dto = mapper.Map<GetPersonResponse>(person);

        return dto;
    }
}