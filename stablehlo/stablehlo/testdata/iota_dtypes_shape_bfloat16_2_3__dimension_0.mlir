// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @expected() : () -> tensor<2x3xbf16>
    %1 = stablehlo.iota dim = 0 : tensor<2x3xbf16>
    %2 = stablehlo.custom_call @check.eq(%1, %0) : (tensor<2x3xbf16>, tensor<2x3xbf16>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @expected() -> tensor<2x3xbf16> {
    %0 = stablehlo.constant dense<[[0.000000e+00, 0.000000e+00, 0.000000e+00], [1.000000e+00, 1.000000e+00, 1.000000e+00]]> : tensor<2x3xbf16>
    return %0 : tensor<2x3xbf16>
  }
}
