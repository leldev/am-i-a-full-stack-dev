namespace LEL.Resume.Api.Data.ValueComparers;

public sealed class ListComparer<T> : EnumerableComparer<List<T>, T>
{
    public ListComparer()
        : base(c => c.ToList())
    {
    }
}
