import pytest

from creadit_account import CreditAccount

def test_comparation():
    credit_account_1 = CreditAccount("Lukas Novak")
    credit_account_2 = CreditAccount("Pepa Novak", initial_credits=200)

    assert credit_account_1 < credit_account_2
    assert credit_account_2 > credit_account_1
    assert credit_account_1 <= credit_account_2
    assert credit_account_2 >= credit_account_1
    assert credit_account_1 != credit_account_2
    assert not (credit_account_1 == credit_account_2)
    
    with pytest.raises(TypeError):
        credit_account_1 < 10
    
    with pytest.raises(TypeError):
        credit_account_1 > 10
    
    with pytest.raises(TypeError):
        credit_account_1 <= 10
    
    with pytest.raises(TypeError):
        credit_account_1 >= 10

def test_comparation_eq():
    credit_account_1 = CreditAccount("Lukas Novak", initial_credits=200)
    credit_account_2 = CreditAccount("Pepa Novak", initial_credits=200)

    assert credit_account_1 <= credit_account_2
    assert credit_account_2 >= credit_account_1
    assert not (credit_account_1 != credit_account_2)
    assert credit_account_1 == credit_account_2

def test_balance_operations():
    credit_account_1 = CreditAccount("Lukas Novak", initial_credits=50)
    credit_account_2 = CreditAccount("Pepa Novak", initial_credits=200)

    assert credit_account_1 + credit_account_2 == 250
    assert credit_account_1 - credit_account_2 == -150


