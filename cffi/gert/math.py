#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.14"
# dependencies = ["cffi", "numpy"]
# ///

import importlib.resources

import cffi
import numpy as np

ffi = cffi.FFI()
ffi.cdef("""
    typedef struct {
        int32_t x;
        int32_t y;
    } Point;
    void move_point(Point *point, int32_t dx, int32_t dy);
    int32_t sum_array(const int32_t *numbers, size_t length);
    int32_t add(int32_t a, int32_t b);
    void multiply_array(double *data_ptr, size_t length, double factor);
    int32_t count_vowels(const char *c_str);
    void uppercase_string(const char *input_ptr, char *output_ptr);
""")
# lib_path = os.path.abspath("zig-out/lib/libmath.dylib")
# print(f"Loading Zig library from: {lib_path}")
with importlib.resources.as_file(
    importlib.resources.files("gert").joinpath("_libmath.dylib")
) as so_path:
    zig = ffi.dlopen(str(so_path))


def do_somthing():
    point_ptr = ffi.new("Point *", {"x": 10, "y": 20})
    print(f"Original Point: ({point_ptr.x}, {point_ptr.y})")

    zig.move_point(point_ptr, 5, -10)
    print(f"Moved Point: ({point_ptr.x}, {point_ptr.y})")

    python_list = [1, 2, 3, 4, 5]
    c_array = ffi.new("int32_t[]", python_list)

    total = zig.sum_array(c_array, len(python_list))
    print(f"Sum of array from Zig: {total}")

    arr = np.array([1.0, 2.0, 3.0, 4.0, 5.0], dtype=np.float64)
    print(f"Original NumPy array: {arr}")

    arr = np.ascontiguousarray(arr)
    c_buffer = ffi.from_buffer("double[]", arr)
    zig.multiply_array(c_buffer, len(arr), 2.5)
    print(f"Modified NumPy array: {arr}")

    result = zig.add(35, 7)
    print(f"Result from Zig: {result}")

    py_string = "Hello from Python and Zig!"
    bytes_data = py_string.encode("utf-8")
    vowel_count = zig.count_vowels(bytes_data)
    print(f"Vowel count: {vowel_count}")

    message = "cffi is fast"
    message_bytes = message.encode("utf-8")
    buffer_size = len(message_bytes) + 1
    output_buffer = ffi.new("char[]", buffer_size)
    zig.uppercase_string(message_bytes, output_buffer)
    result_bytes = ffi.string(output_buffer)
    result_string = result_bytes.decode("utf-8")
    print(f"Result from Zig: '{result_string}'")


# DYLD_LIBRARY_PATH=. uv run python math.py
# if sys.platform.startswith("win32"):
#     lib_name = "math.dll"
# elif sys.platform.startswith("darwin"):
#     lib_name = "libmath.dylib"
# else:
#     lib_name = "libmath.so"

# zig = ctypes.CDLL(lib_path)
# zig.add.argtypes = [ctypes.c_int32, ctypes.c_int32]
# zig.add.restype = ctypes.c_int32
# result = zig.add(35, 7)
# print(f"Result from Zig: {result}")
