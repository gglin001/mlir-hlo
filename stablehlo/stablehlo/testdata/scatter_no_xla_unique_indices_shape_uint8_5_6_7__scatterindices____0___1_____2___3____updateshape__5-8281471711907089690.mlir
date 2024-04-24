// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui8>, tensor<5x2x2x7xui8>)
    %2 = call @expected() : () -> tensor<5x6x7xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      stablehlo.return %arg1 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui8>, tensor<2x2x1xi32>, tensor<5x2x2x7xui8>) -> tensor<5x6x7xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui8>, tensor<5x6x7xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui8>, tensor<5x2x2x7xui8>) {
    %0 = stablehlo.constant dense<"0x04010200020101010004000006050303000202030201040600020001050605030202010301020202010004020002000103000403020202020001020203010301010102000201000402020401080202030100010401050300030203030306030502000100020105000203020000040A010400030004020003020301000000010501000400020300050201010304030400030203050304000201000204020000030101000102030102040204040402020005030201000100020003030600010203020104000300010702030002000000040102"> : tensor<5x6x7xui8>
    %1 = stablehlo.constant dense<"0x0401040403030104030405060203020000080000010104020105000303000009000304020103010301020101030003020102030001010100050002050103020300030000030200000100050000000000080408040204010102030000030200030000050600000201010302020100000703030200030203010301010000030201000102020001050002010004"> : tensor<5x2x2x7xui8>
    return %0, %1 : tensor<5x6x7xui8>, tensor<5x2x2x7xui8>
  }
  func.func private @expected() -> tensor<5x6x7xui8> {
    %0 = stablehlo.constant dense<"0x040104040303010403040506020302000008000001010402010500030506050302020103010202020100030000090003040201030103010201010300030201020300010101000004020204010802020301000104050002050103020300030000030200000100050000000000080408040400030004020003020301000000020401010203000003020003000005060000020101030202010000070204020000030101000102030102030302000302030103010100000302010001020200010500020100040300010702030002000000040102"> : tensor<5x6x7xui8>
    return %0 : tensor<5x6x7xui8>
  }
}

