// std
const math = @import("std").math;

// internal
const ArgsInvestment = @import("../core/cli/model.zig").ArgsInvestment;
const InvestmentResult = @import("../core/investment/model.zig").InvestmentResult;


pub const InvestmentCalculator = struct {

    pub fn init() InvestmentCalculator {
        return  InvestmentCalculator {};
    }

    pub fn deinit(_: *const InvestmentCalculator) void {}

    pub fn calculate(_: *const InvestmentCalculator, data: ArgsInvestment) !InvestmentResult {
        const end_balance = (data.starting_amount*math.pow(f64, 1 + (data.apy/12), @floatFromInt(data.duration)))
                    + (data.contribution
                        * ((math.pow(f64, 1+(data.apy/12), @floatFromInt(data.duration)) - 1) / (data.apy / 12)));

        return InvestmentResult {
            .end_balance = end_balance,
            .starting_amount = data.starting_amount,
            .total_contributions = data.contribution * @as(f32, @floatFromInt(data.duration)),
            .total_interest = end_balance - (data.contribution*@as(f32, @floatFromInt(data.duration))) - data.starting_amount,
        };
    }
};