#!/usr/bin/env uvx pytest type.py

import pytest

class MyClass:
    pass

def test_type():
    """'type' metaclass."""
    assert isinstance(object, type)
    assert isinstance(type, object) # !!!
    assert issubclass(type, object)
    assert isinstance(object, object) # !!!
    assert issubclass(object, object)
    assert issubclass(type, type) # !!!
    assert not issubclass(object, type)
    assert isinstance(type, type) # !!! hardcoded circular in python

    assert not isinstance(int, int) # int creates a int object not a int class
    assert isinstance(int, type)
    assert not isinstance(42, type)
    assert isinstance(list, type)
    assert not isinstance([], type)
    # a class can only have one metaclass

def test_object_class():
    """'object' class"""
    assert isinstance(MyClass, type)
    assert isinstance(MyClass, object)
    assert not isinstance(MyClass, MyClass) # MyClass is not a metaclass of itself
    assert not issubclass(MyClass, type)
    assert issubclass(MyClass, object)
    assert issubclass(MyClass, MyClass)

    assert isinstance([], object)
    assert isinstance(int, object)
    assert isinstance(42, int)
    assert isinstance(42, object)

def test_subclass():
    """inheritance"""
    assert issubclass(int, object)
    assert issubclass(int, int)
    assert not issubclass(int, type)
    with pytest.raises(TypeError):
        issubclass(42, object)
    with pytest.raises(TypeError):
        issubclass(int, 42)

