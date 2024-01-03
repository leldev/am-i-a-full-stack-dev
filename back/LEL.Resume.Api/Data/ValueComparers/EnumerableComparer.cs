using Microsoft.EntityFrameworkCore.ChangeTracking;
using System.Linq.Expressions;

namespace LEL.Resume.Api.Data.ValueComparers;

public abstract class EnumerableComparer<TEnumerable, T> : ValueComparer<TEnumerable>
    where TEnumerable : IEnumerable<T>
{
    public EnumerableComparer(Expression<Func<TEnumerable, TEnumerable>> snapshotExpression)
        : base(
            (c1, c2) => c1!.SequenceEqual(c2!),
            e => e.Aggregate(0, (a, v) => HashCode.Combine(a, v!.GetHashCode())),
            snapshotExpression)
    {
    }
}
