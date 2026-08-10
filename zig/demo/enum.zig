const std = @import("std");
const expect = std.testing.expect;

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

test "self" {
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}
