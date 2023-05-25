// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      stablehlo.return %arg1 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2xi32>, tensor<2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<2x7xf16>) {
    %0 = stablehlo.constant dense<"0xEABA10B8CDC150C1F1BA0BC40BC1EABC5B469439EA4001BD7F390237832B022A6AC020BE6DC42B3E9542A2449045CC3C80419A35DF3C5B35FA3F36427DC30C3C26BA44B65042053BD8BD7E41A23F1D40FBC0103E30B6CE3FC8C0404033BC579CAEC4B13EB5C5153C7541463BE4BBBCB99FBA9133703D5235C6C38C4051BF61C3AD42BB315046213704448BB8B93C38B8EFBA6FC319BC76424FC31B45BDC6732C35BC3CC013C16EC5A0C0E43EB840CB3CBFB98141413BEBAD0442CCBC99C42C3CB2390ABC9EBE004396BFD13C2CC415B1E0433742344077BD3AC2024476B2B8B704C341BD8E417FB204B97DC137405741A441F8C2FD42813E2ABA44C1F43948BAA73EFBBE9DB319C483403A36483C2CC4FCC080B48CBE7E3016C427C0F74369BD143753B8F54334468DC43B2698B563C606424D39A1A53740974408ADFAC1CAC0C7BE40319FB5E0C09A33C5BC27C205B4C3C201C5DD427FBEC64224AD9F94F93C3C45964508BCB7AB4643BCC4D6C1A73EC2C5CDB9ED2D07C5CE400142E242C5BE7BBDA7C664BFC03CA541B0B8AE457B3A86BCEABAD4BC1640FD358BBDDD3E85BFCFC4233D"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[-1.992190e+00, -5.738280e+00, 7.222650e+00, -2.955080e+00, 9.360350e-01, -9.301750e-01, -1.077150e+00], [-6.293950e-01, 2.466800e+00, -6.578130e+00, 1.025390e+00, -5.460940e+00, 3.530270e-01, 8.468750e+00]]> : tensor<2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0xEABA10B8CDC150C1F1BA0BC40BC1F8BFBDC53947E9C17D3B71BB4FBC832B022A6AC020BE6DC42B3E9542A2449045CC3C80419A35DF3C5B35FA3F36427DC30C3C26BA44B65042053BD8BD7E41A23F1D40FBC0103E30B6CE3FC8C0404033BC579CAEC4B13EB5C5153C7541463BE4BBBCB99FBA9133703D5235C6C38C4051BF61C3AD42BB315046213704448BB8B93C38B8EFBA6FC319BC76424FC31B45BDC6732C35BC3CC013C16EC5A0C0E43EB840CB3CBFB98141413BEBAD0442CCBC99C42C3CB2390ABC9EBE004396BFD13C2CC415B1E04309B9EF4094C61A3C76C5A6353C4804C341BD8E417FB204B97DC137405741A441F8C2FD42813E2ABA44C1F43948BAA73EFBBE9DB319C483403A36483C2CC4FCC080B48CBE7E3016C427C0F74369BD143753B8F54334468DC43B2698B563C606424D39A1A53740974408ADFAC1CAC0C7BE40319FB5E0C09A33C5BC27C205B4C3C201C5DD427FBEC64224AD9F94F93C3C45964508BCB7AB4643BCC4D6C1A73EC2C5CDB9ED2D07C5CE400142E242C5BE7BBDA7C664BFC03CA541B0B8AE457B3A86BCEABAD4BC1640FD358BBDDD3E85BFCFC4233D"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

