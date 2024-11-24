const Command = @import("../../cli/commands.zig").Command;


pub const ArgsInvestment = struct {
    starting_amount: f64,
    duration: u32,              // duration in months
    apy: f32,
    contribution: f32,          // monthly contribution
};

pub const ArgsDebt = struct {
    amount: f64,
    duration: u32,              // duration in months
    interest: f32,
};

pub const Args = struct {
    command: Command,
    args_investment: ?ArgsInvestment = null,
    args_debt: ?ArgsDebt = null,
};