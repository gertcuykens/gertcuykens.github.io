#!/usr/bin/env python3.14
# ty: ignore[unresolved-import]
import sys

from elftools.elf.elffile import ELFFile


def find_symbol(elf_path, symbol_name):
    with open(elf_path, "rb") as f:
        elf = ELFFile(f)

        symtab = elf.get_section_by_name(".symtab")
        dynsym = elf.get_section_by_name(".dynsym")

        found = False

        for table in [symtab, dynsym]:
            if not table:
                continue
            for sym in table.iter_symbols():
                if symbol_name in sym.name:
                    print(f"✓ Found symbol: {sym.name} at {hex(sym.entry['st_value'])}")
                    found = True

        if not found:
            print(f"✗ Symbol '{symbol_name}' not found in {elf_path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python find_symbol_so.py <path-to-so> <symbol>")
        sys.exit(1)

    find_symbol(sys.argv[1], sys.argv[2])
