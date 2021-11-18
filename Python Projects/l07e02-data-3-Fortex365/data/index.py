class Index:
    """Class reprezentation of index object."""

    def __init__(self, labels, name=""):
        """Index class instance initialization method.

        Args:
            index: List of indexes.
        """

        if not labels:
            raise ValueError(
                f"Labels must contain at least one item, {labels} was given.")

        if len(set(labels)) != len(labels):
            raise ValueError(
                f"Labels contains duplicates, {labels} was given.")

        self.labels = labels
        self.name = name

    def __len__(self):
        return len(self.labels)
    
    def __iter__(self):
        for label in self.labels:
            yield label

    def get_loc(self, key):
        """Returns index where key is in index. 
        May raise ValueError if key is not in index. 

        Args:
            key: Key we search for.

        Returns:
            index: Number where the key was in index. 
        """

        try:
            return self.labels.index(key)
        except ValueError as err:
            raise KeyError(
                f"Index doesnt exist, since {key} is not in labels.")
            
    