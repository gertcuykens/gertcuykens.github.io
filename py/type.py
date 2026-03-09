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

    assert isinstance(object, object)
    assert issubclass(object, object)
    assert isinstance(object, type)
    assert issubclass(object, object)
    assert isinstance(object, object) # !!!
    assert not issubclass(object, type)

    assert isinstance(type, object)
    assert issubclass(type, object)
    assert isinstance(type, type)
    assert issubclass(type, type)
    assert isinstance(type, type) # !!!
    assert issubclass(type, type) # !!!

    assert isinstance(int, object)
    assert issubclass(int, object)
    assert isinstance(int, type)
    assert issubclass(int, int)
    assert not isinstance(int, int) # int creates a int object not a int class
    assert not issubclass(int, type)

    assert isinstance(MyClass, object)
    assert issubclass(MyClass, object)
    assert isinstance(MyClass, type)
    assert issubclass(MyClass, MyClass)
    assert not isinstance(MyClass, MyClass) # MyClass is not a metaclass of itself
    assert not issubclass(MyClass, type)

    assert isinstance(42, object)
    assert not isinstance(42, type)
    assert isinstance([], object)
    assert not isinstance([], type)
    assert isinstance(list, object)
    assert isinstance(list, type)

    # with pytest.raises(TypeError):

