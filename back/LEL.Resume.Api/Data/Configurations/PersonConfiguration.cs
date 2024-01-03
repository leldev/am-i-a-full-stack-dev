using LEL.Resume.Api.Data.ValueComparers;
using LEL.Resume.Api.Data.ValueConverters;
using LEL.Resume.Api.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LEL.Resume.Api.Data.Configurations;

public sealed class PersonConfiguration : IEntityTypeConfiguration<Person>
{
    public void Configure(EntityTypeBuilder<Person> builder)
    {
        builder.Property(x => x.Languages)
           .HasConversion<StringListConverter, ListComparer<string>>();

        builder.Property(x => x.Experiences)
           .HasConversion<StringListConverter, ListComparer<string>>();

        builder.Property(x => x.Technologies)
           .HasConversion<StringListConverter, ListComparer<string>>();
    }
}
