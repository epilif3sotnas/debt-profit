// std
const std = @import("std");
const Allocator = @import("std").mem.Allocator;

// internal
const Command = @import("commands.zig").Command;
const CommandErrors = @import("../core/errors/command.zig").CommnadErrors;
const Args = @import("../core/cli/model.zig").Args;
const ArgsInvestment = @import("../core/cli/model.zig").ArgsInvestment;
const ArgsDebt = @import("../core/cli/model.zig").ArgsDebt;
const ArgsErrors = @import("../core/errors/args.zig").ArgsErrors;

// external
const App = @import("yazap").App;
const Arg = @import("yazap").Arg;
const ArgMatches = @import("yazap").ArgMatches;


pub const Cli = struct {
    allocator: Allocator,
    args: Args,


    pub fn init(allocator: Allocator) !Cli {
        const args = try getCommandArgs(allocator);

        return Cli {
            .allocator = allocator,
            .args = args,
        };
    }

    pub fn deinit(_: *const Cli) void {}

    pub fn getCommand(self: *const Cli) Command {
        return self.args.command;
    }

    pub fn getArgs(self: *const Cli) Args {
        return self.args;
    }
};

fn cliStruct(allocator: Allocator) !App {
    var app = App.init(allocator, "debt-profit", "Debt Profit Calculator.");

    var cli = app.rootCommand();
    cli.setProperty(.help_on_empty_args);

    // Command Investment only
    var investment = app.createCommand("investment", "Calculator Investment only.");
    try investment.addArgs(
        &[_] Arg {
            Arg.singleValueOption("starting-amount", null, "Amount when start investment."),
            Arg.singleValueOption("duration", null, "Duration of the investment."),
            Arg.singleValueOption("apy", null, "APY of the investment."),
            Arg.singleValueOption("contribution", null, "Monthly contributions of the investment."),
        }
    );
    try cli.addSubcommand(investment);

    // Command Debt only
    var debt = app.createCommand("debt", "Calculator Debt only.");
    try debt.addArgs(
        &[_] Arg {
            Arg.singleValueOption("amount", null, "Debt amount."),
            Arg.singleValueOption("duration", null, "Duration of the debt."),
            Arg.singleValueOption("interest", null, "Debt interest yearly."),
        }
    );
    try cli.addSubcommand(debt);

    // Command Debt and Investment
    var investment_debt = app.createCommand("both", "Calculator Investment Debt.");
    try investment_debt.addArgs(
        &[_] Arg {
            Arg.singleValueOption("debt-amount", null, "Debt amount."),
            Arg.singleValueOption("duration", null, "Duration."),
            Arg.singleValueOption("apy", null, "APY of the investment."),
            Arg.singleValueOption("interest", null, "Debt interest yearly."),
        }
    );
    try cli.addSubcommand(investment_debt);

    return app;
}


fn getCommandArgs(allocator: Allocator) !Args {
    var app = try cliStruct(allocator);
    defer app.deinit();

    var cli = try app.parseProcess();

    const command = if (cli.containsArg("investment"))
        Command.INVESTMENT
    else if (cli.containsArg("debt"))
        Command.DEBT
    else if (cli.containsArg("both"))
        Command.BOTH
    else
        return ArgsErrors.MissingParemeters;


    cli = switch(command) {
        Command.INVESTMENT => cli.subcommandMatches("investment").?,
        Command.DEBT => cli.subcommandMatches("debt").?,
        Command.BOTH => cli.subcommandMatches("both").?,
    };

    return switch (command) {
        .INVESTMENT => {
            const argsValues = &[_] []const u8 {
                cli.getSingleValue("starting-amount")
                    orelse
                        return ArgsErrors.MissingParemeters,

                cli.getSingleValue("duration")
                    orelse
                        return ArgsErrors.MissingParemeters,

                cli.getSingleValue("apy")
                    orelse
                        return ArgsErrors.MissingParemeters,

                cli.getSingleValue("contribution")
                    orelse
                        return ArgsErrors.MissingParemeters,
            };

            return Args {
                .command = command,
                .args_investment = ArgsInvestment {
                    .starting_amount = try std.fmt.parseFloat(f64, argsValues[0]),
                    .contribution = try std.fmt.parseFloat(f64, argsValues[3]),
                    .apy = try std.fmt.parseFloat(f32, argsValues[2])/100,
                    .duration = try std.fmt.parseUnsigned(u16, argsValues[1], 10),
                }
            };
        },

        .DEBT => {
            const argsValues = &[_] []const u8 {
                cli.getSingleValue("amount")
                    orelse
                        return ArgsErrors.MissingParemeters,

                cli.getSingleValue("duration")
                    orelse
                        return ArgsErrors.MissingParemeters,

                cli.getSingleValue("interest")
                    orelse
                        return ArgsErrors.MissingParemeters,
            };

            return Args {
                .command = command,
                .args_debt = ArgsDebt {
                    .amount = try std.fmt.parseFloat(f64, argsValues[0]),
                    .interest = try std.fmt.parseFloat(f32, argsValues[2])/100,
                    .duration = try std.fmt.parseUnsigned(u16, argsValues[1], 10),
                }
            };
        },

        .BOTH => {
            const argsValues = &[_] []const u8 {
                    cli.getSingleValue("debt-amount")
                        orelse
                            return ArgsErrors.MissingParemeters,

                    cli.getSingleValue("duration")
                        orelse
                            return ArgsErrors.MissingParemeters,

                    cli.getSingleValue("apy")
                        orelse
                            return ArgsErrors.MissingParemeters,

                    cli.getSingleValue("interest")
                        orelse
                            return ArgsErrors.MissingParemeters,
            };

            return Args {
                .command = command,

                .args_debt = ArgsDebt {
                    .amount = try std.fmt.parseFloat(f64, argsValues[0]),
                    .interest = try std.fmt.parseFloat(f32, argsValues[3])/100,
                    .duration = try std.fmt.parseUnsigned(u16, argsValues[1], 10),
                },

                .args_investment = ArgsInvestment {
                    .starting_amount = 0,
                    .contribution = 0,
                    .apy = try std.fmt.parseFloat(f32, argsValues[2])/100,
                    .duration = try std.fmt.parseUnsigned(u16, argsValues[1], 10),
                },
            };
        },
    };
}