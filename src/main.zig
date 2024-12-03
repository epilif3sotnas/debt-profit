// std
const std = @import("std");

// internal
const Cli = @import("cli/cli.zig").Cli;
const Command = @import("cli/commands.zig").Command;
const ArgsInvestment = @import("core/cli/model.zig").ArgsInvestment;
const ArgsDebt = @import("core/cli/model.zig").ArgsDebt;
const ArgsBoth = @import("core/cli/model.zig").ArgsBoth;
const InvestmentCalculator = @import("investment/investment.zig").InvestmentCalculator;
const DebtCalculator = @import("debt/debt.zig").DebtCalculator;
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

        Command.DEBT => {
            if (data.args_debt == null)
                return ArgsErrors.ArgsDoNotMatchCommandRequirements;

            const debt_calculator = DebtCalculator.init();
            defer debt_calculator.deinit();

            const result = try debt_calculator.calculate(data.args_debt.?);

            std.debug.print("\n\n--------- Debt Calculator ---------\n", .{});
            std.debug.print("Total Loan Repayment: {d:.2}\n", .{ result.total_loan_repayment });
            std.debug.print("Loan Interest: {d:.2}\n", .{ result.loan_interest });
            std.debug.print("Monthly Payment: {d:.2}\n", .{ result.monthly_payment });
        },

        Command.BOTH => {},
    }
}