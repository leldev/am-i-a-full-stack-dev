using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace LEL.Resume.Api.Data.ValueConverters;

public abstract class StringEnumerableConverter<T>(Func<IEnumerable<string>, T> convertToParameterType, string separator = ";") : ValueConverter<T, string>(
        value => string.Join(separator, value),
        dbValue => convertToParameterType(dbValue.Split(separator, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)))
    where T : IEnumerable<string>
{
}
