// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xui32>, tensor<20x20xui32>)
    %1 = call @expected() : () -> tensor<20x20xui32>
    %2 = stablehlo.shift_right_logical %0#0, %0#1 : tensor<20x20xui32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui32>, tensor<20x20xui32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xui32>, tensor<20x20xui32>) {
    %0 = stablehlo.constant dense<"0x00000000010000000100000001000000040000000000000005000000010000000600000001000000040000000000000006000000000000000000000001000000000000000200000000000000010000000400000001000000000000000200000003000000030000000500000003000000020000000100000002000000020000000000000001000000000000000000000004000000010000000000000005000000000000000400000001000000010000000300000003000000020000000000000002000000010000000200000000000000030000000400000004000000000000000000000000000000000000000300000000000000030000000000000002000000000000000100000002000000040000000300000002000000000000000300000001000000000000000000000002000000000000000100000001000000000000000400000000000000030000000000000007000000030000000100000007000000040000000000000000000000000000000400000000000000030000000100000006000000010000000200000002000000010000000100000004000000040000000100000006000000030000000000000001000000000000000600000000000000010000000000000003000000000000000000000001000000010000000000000001000000000000000300000001000000010000000100000000000000010000000200000000000000030000000000000003000000030000000000000001000000020000000300000000000000040000000500000004000000000000000000000003000000030000000000000002000000070000000300000001000000000000000000000005000000040000000200000002000000000000000100000002000000000000000100000002000000000000000500000000000000020000000100000000000000000000000300000002000000000000000000000003000000000000000300000003000000000000000200000003000000050000000400000004000000030000000200000004000000050000000100000003000000010000000000000003000000020000000000000005000000040000000400000002000000010000000000000002000000040000000100000001000000040000000200000005000000040000000100000004000000020000000200000002000000040000000100000004000000040000000100000000000000030000000300000002000000030000000200000001000000020000000200000003000000010000000100000002000000010000000500000000000000010000000200000003000000000000000200000004000000060000000200000002000000000000000000000004000000020000000300000004000000000000000000000002000000080000000500000000000000010000000000000003000000050000000300000000000000060000000300000009000000010000000100000000000000030000000100000000000000040000000000000003000000020000000100000002000000000000000100000000000000040000000300000000000000020000000200000000000000010000000400000002000000010000000300000000000000000000000400000000000000050000000000000000000000010000000300000000000000010000000300000001000000070000000400000001000000020000000000000001000000000000000200000004000000030000000300000004000000050000000300000000000000010000000000000003000000030000000400000000000000000000000100000005000000020000000100000001000000000000000500000001000000070000000000000003000000030000000100000005000000000000000200000000000000000000000600000003000000000000000100000003000000000000000100000004000000000000000700000004000000010000000300000001000000040000000100000001000000000000000300000003000000050000000500000005000000010000000200000002000000050000000100000001000000050000000100000004000000020000000000000000000000000000000100000001000000020000000300000000000000010000000100000002000000040000000400000001000000010000000000000002000000010000000000000002000000040000000200000000000000"> : tensor<20x20xui32>
    %1 = stablehlo.constant dense<"0x01000000000000000400000003000000030000000000000003000000000000000300000002000000020000000300000002000000060000000400000000000000000000000200000002000000030000000300000004000000000000000100000000000000010000000200000000000000000000000000000000000000020000000100000002000000000000000000000000000000000000000000000000000000030000000000000003000000000000000000000003000000030000000200000003000000000000000000000002000000040000000000000000000000020000000300000000000000010000000200000004000000010000000100000002000000030000000200000000000000010000000000000001000000080000000000000002000000000000000200000006000000010000000200000001000000000000000200000000000000000000000100000001000000010000000100000001000000030000000100000000000000040000000100000004000000030000000300000003000000040000000100000001000000040000000100000001000000050000000500000004000000050000000600000000000000010000000000000005000000000000000400000002000000010000000000000000000000040000000100000001000000020000000300000000000000020000000100000000000000010000000200000000000000010000000000000001000000020000000100000001000000020000000200000000000000000000000100000000000000020000000300000006000000000000000400000001000000040000000100000002000000040000000100000000000000020000000100000001000000020000000500000000000000000000000600000000000000020000000100000000000000010000000100000002000000010000000400000004000000000000000000000002000000050000000000000000000000010000000200000005000000000000000000000004000000010000000100000000000000030000000200000006000000000000000400000002000000010000000000000003000000020000000300000006000000000000000000000001000000010000000100000000000000030000000000000000000000000000000300000001000000040000000400000003000000010000000000000002000000020000000200000002000000020000000100000001000000030000000500000001000000000000000100000005000000040000000300000001000000000000000300000002000000000000000100000003000000010000000100000000000000000000000000000001000000010000000200000001000000050000000700000007000000020000000300000002000000000000000200000004000000000000000100000002000000060000000000000000000000030000000000000002000000000000000200000002000000010000000400000005000000070000000100000002000000010000000500000001000000020000000100000006000000000000000100000000000000000000000000000002000000010000000500000002000000020000000500000005000000000000000100000000000000030000000100000001000000000000000200000002000000020000000300000004000000010000000200000004000000020000000100000000000000010000000000000003000000060000000400000004000000000000000200000004000000010000000000000003000000060000000200000004000000000000000400000004000000000000000300000001000000000000000100000001000000030000000500000000000000010000000100000000000000000000000600000000000000010000000100000000000000030000000100000000000000040000000100000001000000020000000200000001000000000000000500000001000000030000000400000004000000000000000100000002000000020000000600000003000000000000000100000000000000050000000000000001000000010000000000000001000000000000000000000000000000020000000300000002000000000000000100000003000000000000000000000001000000000000000300000001000000000000000000000000000000020000000200000005000000010000000000000002000000"> : tensor<20x20xui32>
    return %0, %1 : tensor<20x20xui32>, tensor<20x20xui32>
  }
  func.func private @expected() -> tensor<20x20xui32> {
    %0 = stablehlo.constant dense<"0x00000000010000000000000000000000000000000000000000000000010000000000000000000000010000000000000001000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000003000000010000000100000003000000020000000100000002000000000000000000000000000000000000000000000004000000010000000000000005000000000000000400000000000000010000000300000000000000000000000000000000000000010000000200000000000000000000000400000004000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000002000000020000000300000001000000000000000300000000000000000000000000000000000000000000000000000000000000000000000100000000000000030000000000000003000000010000000000000003000000000000000000000000000000000000000200000000000000000000000000000000000000000000000100000001000000000000000000000002000000000000000000000000000000000000000000000001000000000000000600000000000000010000000000000000000000000000000000000001000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000010000000000000001000000000000000000000000000000000000000000000000000000040000000200000004000000000000000000000000000000030000000000000001000000000000000100000000000000000000000000000005000000010000000100000001000000000000000000000002000000000000000000000002000000000000000200000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000300000003000000000000000000000000000000050000000400000000000000010000000100000004000000000000000000000000000000010000000000000000000000010000000000000000000000010000000000000000000000010000000000000001000000020000000000000001000000000000000200000005000000040000000000000002000000000000000000000000000000020000000100000001000000010000000000000000000000000000000100000001000000000000000000000000000000020000000100000000000000000000000000000001000000010000000000000000000000010000000100000000000000000000000100000004000000060000000200000001000000000000000000000002000000000000000000000000000000000000000000000000000000080000000100000000000000010000000000000000000000000000000300000000000000000000000300000002000000010000000000000000000000010000000000000000000000000000000000000000000000010000000000000001000000000000000000000000000000040000000100000000000000020000000200000000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000010000000000000000000000000000000000000000000000030000000100000000000000000000000000000001000000000000000200000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000000000000000200000000000000000000000000000003000000010000000000000005000000000000000000000000000000000000000300000003000000000000000000000003000000000000000000000002000000000000000100000002000000010000000000000000000000000000000000000000000000000000000100000000000000010000000000000000000000010000000100000002000000000000000100000000000000020000000100000002000000020000000000000000000000000000000000000000000000020000000100000000000000010000000100000001000000040000000000000000000000010000000000000002000000000000000000000000000000020000000200000000000000"> : tensor<20x20xui32>
    return %0 : tensor<20x20xui32>
  }
}
