// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      stablehlo.return %arg1 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x1xi32>, tensor<5x2x2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2x7xui16>) {
    %0 = stablehlo.constant dense<"0x020002000400030002000800050003000200030005000200010005000200010000000100010004000200010006000000000005000000010004000200010002000600010000000000050002000000030006000500000001000100000003000300010001000000030000000000010003000200030006000100010001000500010003000100010000000000010002000200020004000000070000000200050000000400000002000200000000000200010000000000050000000000040001000100010001000200040004000400010000000700000001000200000002000300040000000000020005000000040002000300010003000100020001000300010004000100040000000300000001000100000000000300010000000000030002000100030000000200000002000500000002000000040004000000060003000000050003000300030007000300010004000400040002000200060002000000030000000300040006000400010002000300060000000300000000000300000001000100000006000000010003000100000000000200000001000100010001000300020000000100"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<"0x07000200010004000200010001000300000002000100010006000500050000000100010001000000020007000300040005000200010001000100000002000400020000000100020000000300010000000300040000000000000002000300000005000300000001000200050002000200020001000200020001000300000001000500040001000200030000000000020002000600010000000700010001000000040001000200060000000600010001000000030000000300000000000300010002000000030002000100010007000000020002000000010003000700040000000100010002000200020003000200040002000600010004000000010001000000000000000200070000000200010002000100020002000600"> : tensor<5x2x2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x070002000100040002000100010003000000020001000100060005000500000001000100010000000200070003000400050002000100010004000200010002000600010000000000050002000000030006000500010000000200040002000000010002000000030001000000030004000000000000000200030000000500030000000100020005000200020002000200020004000000070000000200050000000400000002000200020001000200020001000300000001000500040001000200030000000000020002000600010000000700010001000000040001000200060000000000020005000000040002000300010003000100020001000300000006000100010000000300000003000000000003000100020000000300020001000100070000000200020000000100030007000400000004000000060003000000050003000300030007000300010004000400010001000200020002000300020004000200060001000400000001000100000000000000020007000000020001000200010002000200060003000100000000000200000001000100010001000300020000000100"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

