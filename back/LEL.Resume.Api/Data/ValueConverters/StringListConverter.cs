
namespace LEL.Resume.Api.Data.ValueConverters;

public sealed class StringListConverter : StringEnumerableConverter<List<string>>
{
    public StringListConverter()
        : this(";")
    {
    }

    public StringListConverter(string separator = ";")
        : base(e => e.ToList(), separator)
    {
    }
}