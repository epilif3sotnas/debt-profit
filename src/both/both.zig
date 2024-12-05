// std
const math = @import("std").math;

// internal
const BothData = @import("../core/both/model.zig").BothData;
const BothResult = @import("../core/both/model.zig").BothResult;


pub const BothCalculator = struct {

    pub fn init() BothCalculator {
        return  BothCalculator {};
    }

    pub fn deinit(_: *const BothCalculator) void {}

    pub fn calculate(_: *const BothCalculator, data: *const BothData) !BothResult {
        const profit = data.data_debt_investment.total_interest
                            - data.data_debt.loan_interest
                            - data.data_investment.total_interest;

        return BothResult {
            .profit = profit,
        };
    }
};
