from debug import debug

def test_debug(capfd):
    @debug
    def my_sum(a, b):
        return a + b
    
    result = my_sum(2, 3)
    out, _ = capfd.readouterr()

    assert "Calling: my_sum(2, 3)" in out
    assert "Result: 5" in out
    assert result == 5

def test_debug_parameter_name(capfd):
    @debug
    def my_sum(a, b):
        return a + b
    
    result = my_sum(2, b=3)
    out, _ = capfd.readouterr()

    assert "Calling: my_sum(2, b=3)" in out
    assert "Result: 5" in out
    assert result == 5

def test_debug_no_parameter(capfd):
    @debug
    def test():
        return 42
    
    result = test()
    out, _ = capfd.readouterr()

    assert "Calling: test()" in out
    assert "Result: 42" in out
    assert result == 42

def test_debug_no_return(capfd):
    @debug
    def test():
        pass
    
    result = test()
    out, _ = capfd.readouterr()

    assert "Calling: test()" in out
    assert "Result: None" in out
    assert result == None

