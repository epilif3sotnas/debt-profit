// internal
const Command = @import("../../cli/commands.zig").Command;


pub const ArgsInvestment = struct {
    starting_amount: f64,
    contribution: f64,          // monthly contribution
    apy: f32,
    duration: u16,              // duration in months
};

pub const ArgsDebt = struct {
    amount: f64,
    interest: f32,
    duration: u16,              // duration in months
};

pub const Args = struct {
    command: Command,
    args_investment: ?ArgsInvestment = null,
    args_debt: ?ArgsDebt = null,
};