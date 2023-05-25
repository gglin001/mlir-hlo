// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xui16>, tensor<3x5x2xui16>)
    %2 = call @expected() : () -> tensor<3x5x40xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xui16>, tensor<2x1xi32>, tensor<3x5x2xui16>) -> tensor<3x5x40xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xui16>, tensor<3x5x40xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xui16>, tensor<3x5x2xui16>) {
    %0 = stablehlo.constant dense<"0x010000000000040003000100010000000100010001000000000000000100040000000100040000000200020001000000010006000000000002000100010004000600040002000200020002000300010003000200020006000000070000000100010000000100000000000000030000000600000000000000010001000100030004000200010002000200000002000300000003000400020002000400000001000100040000000000010002000100040000000100040002000100010000000100010001000100030004000000020000000000020003000100020003000300000002000100070006000200060004000400010002000300030001000000020002000200010002000500030000000000010005000000080001000300000001000000030002000300020003000000010001000100020006000100010000000300030003000100040001000400020000000300070006000300030002000000010004000100000000000100000001000100020000000200000005000100010000000000020000000100070004000400000000000000070001000200010001000200020004000200010003000100040002000300030003000200020002000500060003000300050001000000000002000100050002000000000001000000000008000100010000000000020000000000000007000200020001000300000004000000000003000500020000000100020002000200010002000100010003000400030006000100030000000400010000000200000003000200040002000100050001000100010004000100010003000100040001000100020002000500040000000200010000000000010003000100000004000600050004000300000001000100020002000200050000000000000003000100000001000100020003000100020001000300050002000400000001000300010000000300080002000000010002000500020002000100010000000400020000000100020001000000020000000000020002000200030003000200020005000400010002000300020001000000030001000000010002000200080000000100010001000300000002000100030003000400000000000400030001000400020001000100020004000500010002000200010005000100000003000500010007000200060000000300010000000400040004000100030007000000000004000200010004000000060002000100000000000100010000000100000000000100030000000100030002000200030002000000030000000100000003000500010006000400000001000100010003000500000004000400050002000000070002000000010000000700030001000600010002000700030001000400010004000700010003000200020004000200010001000000030000000000000004000100000005000300040003000200000000000200040003000200000001000000040001000400080004000000000001000100040003000400040007000300030005000100030002000000030001000100010000000100060004000200000002000200020001000000040002000100000006000200010003000600000001000000010001000200000001000000040002000600000001000100030001000000010003000200030000000100"> : tensor<3x5x40xui16>
    %1 = stablehlo.constant dense<[[[0, 4], [5, 0], [2, 0], [0, 4], [3, 1]], [[2, 1], [0, 0], [5, 1], [0, 1], [0, 0]], [[3, 0], [1, 3], [5, 4], [0, 1], [2, 0]]]> : tensor<3x5x2xui16>
    return %0, %1 : tensor<3x5x40xui16>, tensor<3x5x2xui16>
  }
  func.func private @expected() -> tensor<3x5x40xui16> {
    %0 = stablehlo.constant dense<"0x010004000000040003000100010000000100010001000000000000000100040000000100040000000200020001000000010006000000000002000100010004000600040002000200020002000300010003000500020006000000070000000100010000000100000000000000030000000600000000000000010001000100030004000200010002000200000002000300000003000400020002000400000001000100040000000000010002000100040000000100040002000100010000000100010001000100030004000000020000000000020003000100020003000300000002000100070006000200060004000400010004000300030001000000020002000200010002000500030000000000010005000000080001000300000001000000030002000300020003000000010001000100020006000100010000000300030003000300040001000400020000000300070006000300030002000000010004000100000000000100000001000100020000000200000005000100010000000000020000000100070004000400000000000000070001000200010001000200020004000200010003000100040002000300030003000200020002000500060003000300050001000000000002000100050002000000000001000000000008000100010000000000020000000000000007000200020001000300000004000000000003000500020000000100020002000200010002000100010003000400030006000100030000000400010000000200000003000500040002000100050001000100010004000100010003000100040001000100020002000500040000000200010000000000010003000100000004000600050004000300000001000100020002000200050000000000000003000100000001000100020003000100020001000300050002000400000001000300010000000300080002000000010002000500020002000100010000000400020000000100020001000000020000000000020002000200030003000200020005000400010002000300020001000000030001000000010002000200080000000100010001000300000002000100030003000400000000000400030001000400020001000100020004000500010002000200010005000100000003000500010007000200060000000300010000000400040004000100030007000000000004000200010004000000060002000100000000000100010000000100000000000100030000000100030002000200030002000000030000000100000003000500010006000400000001000100010003000500000004000400050005000000070002000000010000000700030001000600010002000700030001000400010004000700010003000200020004000200010001000000030000000000000004000100000005000300040003000200000000000200040003000200000001000000040001000400080004000000000001000100040003000400040007000300030005000100030002000000030001000100010000000100060004000200020002000200020001000000040002000100000006000200010003000600000001000000010001000200000001000000040002000600000001000100030001000000010003000200030000000100"> : tensor<3x5x40xui16>
    return %0 : tensor<3x5x40xui16>
  }
}

