from .index import Index
from statistics import mean


class Series:
    """Class reprezentation of series object.
    """

    def __init__(self, values, index=None):
        """Series class initialization method

        Args:
            values: List of values.
            index (optional): Index object. 
            Defaults to Index object with keys from 0 to n,
            where n is length of given values.

        Raises:
            ValueError: When values doesnt have at least one item.
            Or when given values and Index object are not compatible size.
        """

        if not values:
            raise ValueError(
                f"Values must contain at least one item, {values} was given.")
        elif (index and
              len(values) != len(index.labels)):
            raise ValueError(
                f"Values and index must be the same size, {len(values)} and {len(index.labels)} was given.")
        elif not index:
            index = Index(range(len(values)))

        self.values = values
        self.index = index

    def get(self, key):
        """By given key tries to access the corresponding value.

        Args:
            key: Key to search in Index object (self.index).

        Returns:
            res: Value that corresponds to the key. Or None if key isnt in Index.
        """

        res = None
        try:
            res = self.values[self.index.get_loc(key)]
        except KeyError as err:
            pass
        return res

    def max(self):
        """Finds the maximal value of serie values.

        Returns:
            Number: Maximum number found in serie values.
        """

        return max(self.values)

    def min(self):
        """Finds the minimal value of serie values.

        Returns:
            Number: Minimal number found in serie values.
        """

        return min(self.values)

    def sum(self):
        """Calculates the sum of serie values.

        Returns:
            Number: Summarized values of all serie values.
        """

        return sum(self.values)

    def mean(self):
        """Calculates the mean of serie value.

        Returns:
            Number: Arithmetic mean of serie values.
        """

        return mean(self.values)

    def apply(self, func):
        """Applies given function to a serie values.

        Args:
            func: Function to be applied.

        Raises:
            ValueError: If given func argument isn't callable.

        Returns:
            Series: New Series object with the applied function to serie values.
        """

        if not callable(func):
            raise ValueError(
                f"Cannot apply function to series values since {func} isnt callable.")

        return Series(values=list(map(func, self.values)),
                      index=self.index)

    def abs(self):
        """Applies abs function to serie values.

        Returns:
            Series: New Series object with the applied abs function to serie values.
        """

        return self.apply(abs)
