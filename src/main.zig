const std = @import("std");

const InvalidCommand = struct {
    context: []const u8,

    pub fn run(self: InvalidCommand) void {
        std.debug.print("{s}: command not found\n", .{self.context});
    }
};

const Command = union(enum) {
    invalid: InvalidCommand,

    pub fn run(self: Command) void {
        switch (self) {
            inline else => |case| case.run(),
        }
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const stdin = std.io.getStdIn().reader();
    var buffer: [1024]u8 = undefined;

    // TODO: Handle user input
    while (true) {
        try stdout.print("$ ", .{});
        const user_input = try stdin.readUntilDelimiter(&buffer, '\n');
        var cmd: Command = Command{ .invalid = InvalidCommand{ .context = user_input } };
        cmd.run();
    }
}
