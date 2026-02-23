#!/usr/bin/env uvx pytest type.py

import pytest

class MyClass:
    pass

def test_type():
    """'type' metaclass."""
    assert isinstance(MyClass, type)
    assert isinstance(object, type)
    assert isinstance(type, type)
    assert isinstance(int, type)
    assert not isinstance(42, type)
    assert not isinstance([], type)
    assert isinstance(list, type)
    # a class can only have one metaclass

def test_object_class():
    """'object' class"""
    assert isinstance(MyClass, object)
    assert isinstance(object, object)
    assert isinstance(type, object) # hardcoded circular in python
    assert isinstance(int, object)
    assert isinstance(42, object)
    assert isinstance(42, int)
    assert isinstance([], object)
    assert not isinstance(int, int) # int creates a int object not a int class

def test_subclass():
    """inheritance"""
    assert not issubclass(MyClass, type)
    assert issubclass(MyClass, object)
    assert issubclass(type, object)
    assert not issubclass(object, type)
    assert issubclass(int, object)
    assert issubclass(int, int)
    assert not issubclass(int, type)
    with pytest.raises(TypeError):
        issubclass(42, object)
    with pytest.raises(TypeError):
        issubclass(int, 42)

