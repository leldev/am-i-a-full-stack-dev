using AutoMapper;
using LEL.Resume.Api.Domain.Entities;
using LEL.Resume.Api.Features.Persons.GetPerson;
using LEL.Resume.Api.Features.Persons.GetPersons;

namespace LEL.Resume.Api.Features.Persons
{
    public sealed class MapperProfile : Profile
    {
        public MapperProfile()
        {
            this.CreateMap<Person, GetPersonsResponse>().ReverseMap();

            this.CreateMap<Person, GetPersonResponse>().ReverseMap();
        }
    }
}
