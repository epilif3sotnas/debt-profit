// std
const math = @import("std").math;

// internal
const ArgsDebt = @import("../core/cli/model.zig").ArgsDebt;
const DebtResult = @import("../core/debt/model.zig").DebtResult;


pub const DebtCalculator = struct {

    pub fn init() DebtCalculator {
        return  DebtCalculator {};
    }

    pub fn deinit(_: *const DebtCalculator) void {}

    pub fn calculate(_: *const DebtCalculator, data: ArgsDebt) !DebtResult {
        const monthly_payment = ((data.interest/12) * data.amount)
                    / (1 - math.pow(f64, 1+(data.interest/12), @floatFromInt(-1*@as(i32, data.duration))));

        const total_loan_repayment = monthly_payment * @as(f64, @floatFromInt(data.duration));
        const loan_interest = total_loan_repayment - data.amount;

        return DebtResult {
            .monthly_payment = monthly_payment,
            .loan_interest = loan_interest,
            .total_loan_repayment = total_loan_repayment,
        };
    }
};
