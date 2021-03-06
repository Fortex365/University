from typing import ValuesView
from .series import Series
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

    def __len__(self):
        """Returns length of the dataframe."""
        return len(self.columns)
    
    def __repr__(self):
        return f"DataFrame{repr(self.shape)}"

    def __str__(self):
        return self.__repr__()
    
    def __iter__(self):
        # for column in self.columns:
        #     yield column
        yield from self.columns
        
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
    
    @property
    def shape(self):
        """Calculates the shape of the dataframe.

        Returns:
            tuple: (rows, columns)
        """
        return (len(self.values[0]), len(self.columns))
    
    @classmethod
    def from_csv(self, text, separator=","):
        """Creates a class by given text and separator.

        Args:
            text: Text to convert from.
            separator (str, optional): Seperator character, which is 
            separating values. Defaults to ",".

        Returns:
            New instance of class.
        """
        lines = text.splitlines()
        
        columns_names = lines[0].split(separator)
        columns_names = columns_names[1:]
        columns = Index(columns_names)
        lines = lines[1:]
        
        index_labels = []
        new_lines = []
        for line in lines:
            line = line.split(separator)
            index_labels.append(line[0])
            line = line[1:]
            new_lines.append(line)
        index = Index(index_labels)
        lines = new_lines
        
        values = []
        for column in zip(*lines):
            list_ = []
            for item in column:
                list_.append(item)
            values.append(Series(list_, index))
        
        return DataFrame(values, columns)
    
    def items(self):
        """Returns zip generator of columns and values."""
        return zip(self.columns, self.values)
                     
    def index(self):
        return self.values[0].index
    