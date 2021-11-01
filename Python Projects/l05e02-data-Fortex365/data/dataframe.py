from .index import Index


class DataFrame:
    """Class reprezentation of data-frame object."""

    def __init__(self, values, columns=None):
        """Dataframe class initialization method

        Args:
            values: List of values.
            columns (optional): Index object. 
            Defaults to Index object with keys from 0 to n,
            where n is length of given values.

        Raises:
            ValueError: When values doesnt have at least one item.
            Or when given values and Index object are not compatible size.
        """

        if not values:
            raise ValueError(
                f"Values must contain at least one item, {values} was given.")
        if (columns and
              len(values) != len(columns.labels)):
            raise ValueError(
                f"Values and columns must be the same size, {len(values)} and {len(columns.labels)} was given.")
        if not columns:
            columns = Index(range(len(values)))

        self.values = values
        self.columns = columns

    def get(self, key):
        """By given key tries to access the corresponding serie.

        Args:
            key: Key to search in Index object (self.columns).

        Returns:
            res: Serie that corresponds to the key. Or None if key isnt in Index.
        """

        try:
           return self.values[self.columns.get_loc(key)]
        except KeyError as err:
            return None
        