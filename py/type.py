#!/usr/bin/env uvx pytest type.py

import pytest

class MyClass:
    pass

def test_type():
    """
    'object' class.
    'type' metaclass.
    'inheritance' subclass.

    A class can only have one metaclass.
    """

    assert isinstance(object, type)
    assert isinstance(type, object)
    assert issubclass(type, object)
    assert isinstance(object, object)
    assert issubclass(object, object)
    assert not issubclass(object, type)
    assert issubclass(type, type) # !!!
    assert isinstance(type, type) # !!!

    assert isinstance(int, object)
    assert issubclass(int, object)
    assert isinstance(int, type)
    assert issubclass(int, int)
    assert not issubclass(int, type)
    assert not isinstance(int, int) # int creates a int object not a int class

    assert isinstance(MyClass, object)
    assert issubclass(MyClass, object)
    assert isinstance(MyClass, type)
    assert issubclass(MyClass, MyClass)
    assert not issubclass(MyClass, type)
    assert not isinstance(MyClass, MyClass) # MyClass is not a metaclass of itself

    assert isinstance(42, object)
    with pytest.raises(TypeError):
        assert not issubclass(42, object)
    assert not isinstance(42, type)
    assert isinstance(42, int)
    with pytest.raises(TypeError):
        assert issubclass(int, 42)
    assert isinstance(42, int)

    assert isinstance([], object)
    assert not isinstance([], type)
    assert isinstance(list, type)

