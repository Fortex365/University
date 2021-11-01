class CreditAccount:
    """Account with stored credits."""

    def __init__(self, owner, initial_credits=0):
        """Creates credit account with given owner and initial credits.

        Args:
            owner: owner of the account
            initial_credits (optional): credit balance. Defaults to 0.
        """

        self.owner = owner
        self._balance = 0
        self.balance = initial_credits
    
    @classmethod
    def from_csv(cls, input_string, separator=","):
        """Creates CreditAccount class from csv string"""
        owner, initial_credits = input_string.split(separator)

        return cls(owner, int(initial_credits))

    @staticmethod
    def credit_to_money(credit, exchange_rate):
        """Calculates money value of credits.

        Args:
            credit: amount of credits
            exchange_rate: how many money per one credit

        Returns: money value
        """
        return credit * exchange_rate
    
    @property
    def balance(self):
        return self._balance
    
    @balance.setter
    def balance(self, new_balance):
        """Sets new value of balance, new value cannot be negative."""

        if new_balance < 0:
            raise ValueError("Balance cannot be negative number!")

        self._balance = new_balance

    @balance.deleter
    def balance(self):
        self._balance = 0
    
    def __repr__(self):
        return f"CreditAccount({self.owner}, {self.balance})"
    
    def __str__(self):
        return self.__repr__()
    
    def __bool__(self):
        return bool(self.balance)
    
    def __int__(self):
        return int(self.balance)
    
    def __lt__(self, other):
        if type(other) == CreditAccount:
            return self.balance < other.balance

        return NotImplemented
    
    def __add__(self, other):
        if type(other) == CreditAccount:
            return self.balance + other.balance

        return NotImplemented
    
    def __iadd__(self, value):
        if type(value) == int:
            self.balance += value
            return self
        
        return NotImplemented
    
    def __isub__(self, value):
        if type(value) == int:
            self.balance -= value
            return self
        
        return NotImplemented
    
    def transfer_to(self, other, value):
        """Transfer credit into another credit account. Negative balance is allowed.

        Args:
            other: Target of credit transfer.
            value: Amount of credit to be transfered.
        """
        self -= value
        other += value
        
        
    def __le__(self, other):
        if type(other) == CreditAccount:
            return self.balance <= other.balance

        return NotImplemented
    
    
    def __eq__(self, other):
        if type(other) == CreditAccount:
            return self.balance == other.balance
        
        return NotImplemented
    
    
    def __ne__(self, other):
        if type(other) == CreditAccount:
            return self.balance != other.balance
        
        return NotImplemented
    
    
    def __gt__(self, other):
        if type(other) == CreditAccount:
            return self.balance > other.balance
        
        return NotImplemented
    
    
    def __ge__(self, other):
        if type(other) == CreditAccount:
            return self.balance >= other.balance
        
        return NotImplemented
    
    
    def __sub__(self, other):
        if type(other) == CreditAccount:
         return self.balance - other.balance

        return NotImplemented
