// std
const std = @import("std");

// internal
const Cli = @import("cli/cli.zig").Cli;
const Command = @import("cli/commands.zig").Command;
const ArgsInvestment = @import("core/cli/model.zig").ArgsInvestment;
const ArgsDebt = @import("core/cli/model.zig").ArgsDebt;
const ArgsBoth = @import("core/cli/model.zig").ArgsBoth;
const InvestmentCalculator = @import("investment/investment.zig").InvestmentCalculator;
const ArgsErrors = @import("core/errors/args.zig").ArgsErrors;


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const cli = try Cli.init(allocator);
    defer cli.deinit();

    const data = cli.getArgs();

    std.debug.print("Data: {any}\n", .{ data });

    switch (data.command) {
        Command.INVESTMENT => {
            if (data.args_investment == null)
                return ArgsErrors.ArgsDoNotMatchCommandRequirements;

            const investment_calculator = InvestmentCalculator.init();
            defer investment_calculator.deinit();

            const result = try investment_calculator.calculate(data.args_investment.?);

            std.debug.print("\n\n--------- Investment Calculator ---------\n", .{});
            std.debug.print("End Balance: {d:.2}\n", .{ result.end_balance });
            std.debug.print("Starting Amount: {d:.2}\n", .{ result.starting_amount });
            std.debug.print("Total Contributions: {d:.2}\n", .{ result.total_contributions });
            std.debug.print("Total Interest: {d:.2}\n", .{ result.total_interest });
        },
        Command.DEBT => {},
        Command.BOTH => {},
    }
}