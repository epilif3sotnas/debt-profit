// std
const std = @import("std");

// internal
const Cli = @import("cli/cli.zig").Cli;
const Command = @import("cli/commands.zig").Command;
const ArgsInvestment = @import("core/cli/model.zig").ArgsInvestment;
const ArgsDebt = @import("core/cli/model.zig").ArgsDebt;
const ArgsBoth = @import("core/cli/model.zig").ArgsBoth;


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const cli = try Cli.init(allocator);
    defer cli.deinit();

    const data = cli.getArgs();

    std.debug.print("Data: {any}\n", .{ data });
}