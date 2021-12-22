from data.index import Index
from statistics import mean
import operator
import pathlib


class Series:
    """Class reprezentation of series object."""

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
        if (index and
              len(values) != len(index.labels)):
            raise ValueError(
                f"Values and index must be the same size, {len(values)} and {len(index.labels)} was given.")
        if not index:
            index = Index(range(len(values)))

        self.values = values
        self.index = index

    def __len__(self):
        return len(self.values)
    
    def __repr__(self):
        labels = self.index.labels
        vals = self.values
        string = []
        
        for l, v in zip(labels, vals):
           string.append(str(l) + "\t" + str(v))
        return "\n".join(string)
    
    def __str__(self):
        return self.__repr__()
    
    def __add__(self, other):
        return self._apply_operator(other, operator.add)
    
    def __sub__(self, other):
        return self._apply_operator(other, operator.sub)
     
    def __mul__(self, other):
        return self._apply_operator(other, operator.mul)
    
    def __truediv__(self, other):
        return self._apply_operator(other, operator.truediv)
    
    def __floordiv__(self, other):
        return self._apply_operator(other, operator.floordiv)
    
    def __mod__(self, other):
        return self._apply_operator(other, operator.mod)
    
    def __pow__(self, other):
        return self._apply_operator(other, operator.pow)
    
    def __round__(self, precision):
        def f(num):
            return round(num, precision)
        return self.apply(f)
        
    def __iter__(self):
        yield from self.values
            
    def __getitem__(self, key):
        return self.values[self.index.get_loc(key)]
    
                
    @classmethod
    def from_csv(self, text, separator=","):
        """Converts from text and creates new instance of Series.

        Args:
            text: Input text to convert from.
            separator (str, optional): Value separator.
            Defaults to ",".

        Returns:
            New Series instance object created by given input.
        """
        if not isinstance(text, pathlib.Path):
            raise ValueError(f"Not compatible class instance. Instance must be member of pathlib.Path")
        
        values = []
        index = []
        
        with text.open(mode="r") as f:
            lines = f.readlines()
            lines = [l.strip("\n") for l in lines]
            index, values = lines[0].split(separator), lines[1].split(separator)

        return Series(values, Index(index))
    
    @property
    def shape(self):
        """Calculates the length of the Serie.

        Returns:
            Length of given Serie.
        """
        return (len(self.values), )
    
    def _apply_operator(self, other, operator):
        """Applies operator to each value in zip and returns new Series.

        Args:
            other: The right Serie obj of the operator.
            operator: Operator to by applied.

        Returns:
            New Series with applied operation.
        """
        if not isinstance(other, Series):
            return NotImplemented
        if len(self.values) != len(other.values):
            raise ValueError(f"Length must be compatible, {len(self.values)} and {len(other.values)} was given.")
        
        new_values = []
        
        for s, o in zip(self.values, other.values):
            new_values.append(operator(s, o))
            
        return Series(new_values, self.index)
    
    def get(self, key):
        """By given key tries to access the corresponding value.

        Args:
            key: Key to search in Index object (self.index).

        Returns:
            res: Value that corresponds to the key. Or None if key isnt in Index.
        """

        try:
            return self[key]
        except KeyError as err:
            return None

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

        new_values = [func(val) for val in self.values]
        return Series(values=new_values,
                      index=self.index)

    def abs(self):
        """Applies abs function to serie values.

        Returns:
            Series: New Series object with the applied abs function to serie values.
        """

        return self.apply(abs)

    def items(self):
        """Returns generator of (key, value)."""
        return zip(self.index.labels, self.values)
