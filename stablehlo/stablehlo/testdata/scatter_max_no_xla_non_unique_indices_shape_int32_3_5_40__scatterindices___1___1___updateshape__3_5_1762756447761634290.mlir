// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xi32>, tensor<3x5x2xi32>)
    %2 = call @expected() : () -> tensor<3x5x40xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xi32>, tensor<2x1xi32>, tensor<3x5x2xi32>) -> tensor<3x5x40xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xi32>, tensor<3x5x40xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xi32>, tensor<3x5x2xi32>) {
    %0 = stablehlo.constant dense<"0xFEFFFFFF0000000000000000000000000000000001000000FCFFFFFF00000000020000000000000007000000FFFFFFFF000000000300000004000000030000000100000000000000FDFFFFFFFFFFFFFFFCFFFFFF02000000FEFFFFFF000000000100000000000000FFFFFFFF0200000000000000FDFFFFFF0200000000000000FFFFFFFF00000000000000000400000000000000FEFFFFFF050000000300000006000000010000000100000000000000FDFFFFFF00000000FCFFFFFF02000000FFFFFFFF03000000040000000000000000000000FCFFFFFF00000000020000000100000000000000FEFFFFFFFFFFFFFF010000000100000000000000FFFFFFFFFFFFFFFFFEFFFFFF02000000040000000100000000000000FBFFFFFF0000000003000000FEFFFFFFFDFFFFFFFEFFFFFFFBFFFFFF03000000030000000000000001000000FFFFFFFF0000000003000000FAFFFFFF030000000000000002000000010000000400000000000000FDFFFFFF0000000004000000FEFFFFFFF8FFFFFFFFFFFFFF03000000000000000300000001000000FFFFFFFFFFFFFFFF000000000300000002000000FFFFFFFF0100000001000000FCFFFFFF0100000000000000040000000500000000000000FFFFFFFF01000000FEFFFFFFFFFFFFFF010000000000000004000000FDFFFFFF000000000300000005000000FFFFFFFF00000000FEFFFFFFFCFFFFFFFCFFFFFFFCFFFFFF0600000001000000FFFFFFFF010000000200000000000000FEFFFFFF00000000040000000100000003000000FEFFFFFFFEFFFFFFFDFFFFFFFEFFFFFFFDFFFFFF030000000000000002000000FFFFFFFF00000000FBFFFFFF0100000000000000FFFFFFFF00000000000000000000000002000000FEFFFFFF03000000FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFEFFFFFF000000000300000001000000FCFFFFFFFBFFFFFF00000000FDFFFFFF0000000000000000FFFFFFFF0200000004000000FAFFFFFF060000000300000000000000FEFFFFFF03000000FEFFFFFFFFFFFFFFFDFFFFFF0000000001000000FEFFFFFF0200000005000000FFFFFFFF01000000FFFFFFFF0200000004000000FEFFFFFFFDFFFFFF0100000003000000FDFFFFFFFDFFFFFF0400000000000000FFFFFFFF02000000FCFFFFFF010000000000000001000000FCFFFFFF0000000000000000FCFFFFFF0100000000000000FFFFFFFF01000000FDFFFFFF010000000400000001000000000000000000000005000000FCFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFF0100000000000000000000000200000001000000020000000100000004000000020000000200000000000000FEFFFFFFFCFFFFFF0000000001000000FEFFFFFF0300000005000000FDFFFFFFFBFFFFFFFEFFFFFF080000000300000001000000FEFFFFFF000000000300000000000000000000000300000008000000FEFFFFFFFCFFFFFF0000000001000000FBFFFFFF01000000FEFFFFFF0400000001000000FFFFFFFF020000000000000001000000FFFFFFFF04000000FDFFFFFF00000000040000000000000003000000FDFFFFFF00000000060000000200000002000000020000000000000000000000FFFFFFFF00000000020000000300000000000000000000000500000001000000FBFFFFFFFDFFFFFF0000000001000000FEFFFFFF06000000000000000300000006000000FEFFFFFFFCFFFFFF04000000FEFFFFFF0000000000000000FFFFFFFF0100000004000000FEFFFFFFFAFFFFFF00000000FEFFFFFFFFFFFFFF000000000000000000000000FFFFFFFF000000000100000001000000FFFFFFFFFCFFFFFF0100000004000000FFFFFFFF010000000100000002000000FFFFFFFFFDFFFFFF020000000300000002000000FDFFFFFF020000000400000000000000000000000600000000000000FCFFFFFF00000000FEFFFFFF00000000FCFFFFFF000000000500000002000000FFFFFFFF0500000001000000FFFFFFFF0300000000000000000000000100000003000000FFFFFFFFFFFFFFFF01000000FCFFFFFF07000000FFFFFFFF01000000FFFFFFFF04000000000000000100000000000000050000000000000002000000000000000000000003000000000000000100000005000000000000000000000001000000FEFFFFFFFEFFFFFF000000000000000000000000FEFFFFFFFCFFFFFFFCFFFFFF04000000FEFFFFFF000000000300000000000000040000000100000004000000FFFFFFFFFFFFFFFFFAFFFFFFFEFFFFFF00000000020000000700000000000000FCFFFFFF0300000004000000FBFFFFFFFAFFFFFF0800000000000000FEFFFFFF02000000FBFFFFFF0400000000000000FFFFFFFF0300000003000000000000000000000000000000010000000100000001000000FCFFFFFF00000000000000000000000000000000000000000500000000000000FEFFFFFF0200000003000000FEFFFFFF0000000004000000FBFFFFFFFBFFFFFFFCFFFFFF00000000000000000000000000000000010000000400000000000000FDFFFFFFFCFFFFFF0000000001000000FFFFFFFFFCFFFFFF04000000000000000000000001000000FAFFFFFFFEFFFFFFFFFFFFFF02000000FEFFFFFF0000000007000000030000000200000002000000FFFFFFFFFBFFFFFFFFFFFFFF00000000FDFFFFFF01000000FEFFFFFFFFFFFFFF0300000001000000FEFFFFFFFCFFFFFFFEFFFFFF0300000003000000FDFFFFFF00000000FEFFFFFF00000000FFFFFFFFF9FFFFFF00000000FBFFFFFF0000000002000000FAFFFFFF010000000000000000000000000000000000000000000000020000000000000001000000FEFFFFFF0500000001000000000000000000000001000000FFFFFFFFFDFFFFFF0000000009000000F9FFFFFF00000000FAFFFFFFFEFFFFFF00000000FDFFFFFF0000000001000000FEFFFFFF05000000FFFFFFFF04000000050000000000000004000000FEFFFFFF06000000FDFFFFFF000000000200000003000000FDFFFFFFFFFFFFFFFEFFFFFF0100000003000000FFFFFFFF010000000100000001000000FFFFFFFF0600000000000000FEFFFFFFFEFFFFFF00000000000000000400000000000000FFFFFFFF00000000FEFFFFFFFDFFFFFFFFFFFFFF000000000000000003000000FFFFFFFF00000000FFFFFFFFFBFFFFFFFDFFFFFFFFFFFFFF00000000FFFFFFFFF8FFFFFF03000000F8FFFFFFFDFFFFFF020000000000000002000000FFFFFFFF02000000FEFFFFFF0300000000000000000000000100000001000000FDFFFFFF03000000000000000400000000000000"> : tensor<3x5x40xi32>
    %1 = stablehlo.constant dense<[[[-3, 1], [-1, 0], [0, 3], [-3, 0], [-2, -4]], [[1, 1], [-1, 1], [-4, 4], [1, 1], [-3, 0]], [[-1, 2], [2, -4], [-3, 2], [-4, -3], [0, -3]]]> : tensor<3x5x2xi32>
    return %0, %1 : tensor<3x5x40xi32>, tensor<3x5x2xi32>
  }
  func.func private @expected() -> tensor<3x5x40xi32> {
    %0 = stablehlo.constant dense<"0xFEFFFFFF0100000000000000000000000000000001000000FCFFFFFF00000000020000000000000007000000FFFFFFFF000000000300000004000000030000000100000000000000FDFFFFFFFFFFFFFFFCFFFFFF02000000FEFFFFFF000000000100000000000000FFFFFFFF0200000000000000FDFFFFFF0200000000000000FFFFFFFF00000000000000000400000000000000FEFFFFFF050000000300000006000000010000000100000000000000FDFFFFFF00000000FCFFFFFF02000000FFFFFFFF03000000040000000000000000000000FCFFFFFF00000000020000000100000000000000FEFFFFFFFFFFFFFF010000000100000000000000FFFFFFFFFFFFFFFFFEFFFFFF02000000040000000100000000000000FBFFFFFF0000000003000000FEFFFFFFFDFFFFFFFEFFFFFFFBFFFFFF03000000030000000000000001000000030000000000000003000000FAFFFFFF030000000000000002000000010000000400000000000000FDFFFFFF0000000004000000FEFFFFFFF8FFFFFFFFFFFFFF03000000000000000300000001000000FFFFFFFFFFFFFFFF000000000300000002000000FFFFFFFF0100000001000000FCFFFFFF0100000000000000040000000500000000000000FFFFFFFF01000000FEFFFFFFFFFFFFFF010000000000000004000000FDFFFFFF000000000300000005000000FFFFFFFF00000000FEFFFFFFFCFFFFFFFCFFFFFFFCFFFFFF0600000001000000FFFFFFFF010000000200000000000000FEFFFFFF00000000040000000100000003000000FEFFFFFFFEFFFFFFFDFFFFFFFEFFFFFFFDFFFFFF030000000000000002000000FFFFFFFF00000000FBFFFFFF0100000000000000FFFFFFFF00000000000000000000000002000000FEFFFFFF03000000FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFEFFFFFF000000000300000001000000FCFFFFFFFBFFFFFF00000000FDFFFFFF0000000000000000FFFFFFFF0200000004000000FAFFFFFF060000000300000000000000FEFFFFFF03000000FEFFFFFFFFFFFFFFFDFFFFFF0000000001000000FEFFFFFF0200000005000000FFFFFFFF01000000FFFFFFFF0200000004000000FEFFFFFFFDFFFFFF0100000003000000FDFFFFFFFDFFFFFF0400000000000000FFFFFFFF02000000FCFFFFFF010000000000000001000000FCFFFFFF0000000000000000FCFFFFFF0100000000000000FFFFFFFF01000000FDFFFFFF010000000400000001000000000000000000000005000000FCFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFF0100000000000000000000000200000001000000020000000100000004000000020000000200000000000000FEFFFFFFFCFFFFFF0000000001000000FEFFFFFF0300000005000000FDFFFFFFFBFFFFFFFEFFFFFF080000000300000001000000FEFFFFFF000000000300000000000000000000000300000008000000FEFFFFFFFCFFFFFF0000000001000000FBFFFFFF01000000FEFFFFFF0400000001000000FFFFFFFF020000000000000001000000FFFFFFFF04000000FDFFFFFF00000000040000000000000003000000FDFFFFFF00000000060000000200000002000000020000000000000000000000FFFFFFFF00000000020000000300000000000000000000000500000001000000FBFFFFFFFDFFFFFF0000000001000000FEFFFFFF06000000000000000300000006000000FEFFFFFFFCFFFFFF04000000FEFFFFFF0000000000000000FFFFFFFF0100000004000000FEFFFFFFFAFFFFFF0000000001000000FFFFFFFF000000000000000000000000FFFFFFFF000000000100000001000000FFFFFFFFFCFFFFFF0100000004000000FFFFFFFF010000000100000002000000FFFFFFFFFDFFFFFF020000000300000002000000FDFFFFFF020000000400000000000000000000000600000000000000FCFFFFFF00000000FEFFFFFF00000000FCFFFFFF000000000500000002000000FFFFFFFF0500000001000000000000000300000000000000000000000100000003000000FFFFFFFFFFFFFFFF01000000FCFFFFFF07000000FFFFFFFF01000000FFFFFFFF04000000000000000100000000000000050000000000000002000000000000000000000003000000000000000100000005000000000000000000000001000000FEFFFFFFFEFFFFFF000000000000000000000000FEFFFFFFFCFFFFFFFCFFFFFF04000000FEFFFFFF020000000300000000000000040000000100000004000000FFFFFFFFFFFFFFFFFAFFFFFFFEFFFFFF00000000020000000700000000000000FCFFFFFF0300000004000000FBFFFFFFFAFFFFFF0800000000000000FEFFFFFF02000000FBFFFFFF0400000000000000FFFFFFFF0300000003000000000000000000000000000000010000000100000001000000FCFFFFFF00000000000000000000000000000000020000000500000000000000FEFFFFFF0200000003000000FEFFFFFF0000000004000000FBFFFFFFFBFFFFFFFCFFFFFF00000000000000000000000000000000010000000400000000000000FDFFFFFFFCFFFFFF0000000001000000FFFFFFFFFCFFFFFF04000000000000000000000001000000FAFFFFFFFEFFFFFFFFFFFFFF02000000FEFFFFFF0000000007000000030000000200000002000000FFFFFFFF02000000FFFFFFFF00000000FDFFFFFF01000000FEFFFFFFFFFFFFFF0300000001000000FEFFFFFFFCFFFFFFFEFFFFFF0300000003000000FDFFFFFF00000000FEFFFFFF00000000FFFFFFFFF9FFFFFF00000000FBFFFFFF0000000002000000FAFFFFFF010000000000000000000000000000000000000000000000020000000000000001000000FEFFFFFF0500000001000000000000000000000001000000FFFFFFFFFDFFFFFF0000000009000000F9FFFFFF00000000FAFFFFFFFEFFFFFF00000000FDFFFFFF0000000001000000FEFFFFFF05000000FFFFFFFF04000000050000000000000004000000FEFFFFFF06000000FDFFFFFF000000000200000003000000FDFFFFFFFFFFFFFFFEFFFFFF0100000003000000FFFFFFFF010000000100000001000000FFFFFFFF0600000000000000FEFFFFFFFEFFFFFF00000000000000000400000000000000FFFFFFFF00000000FEFFFFFFFDFFFFFFFFFFFFFF000000000000000003000000FFFFFFFF00000000FFFFFFFFFBFFFFFFFDFFFFFFFFFFFFFF00000000FFFFFFFFF8FFFFFF03000000F8FFFFFFFDFFFFFF020000000000000002000000FFFFFFFF02000000FEFFFFFF0300000000000000000000000100000001000000FDFFFFFF03000000000000000400000000000000"> : tensor<3x5x40xi32>
    return %0 : tensor<3x5x40xi32>
  }
}

