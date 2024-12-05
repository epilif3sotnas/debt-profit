// internal
const InvestmentResult = @import("../investment/model.zig").InvestmentResult;
const DebtResult = @import("../debt/model.zig").DebtResult;


pub const BothData = struct {
    data_debt: DebtResult,
    data_debt_investment: InvestmentResult,
    data_investment: InvestmentResult,
};

pub const BothResult = struct {
    profit: f64,
};