// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<2x2xi8>
    %1 = call @expected() : () -> tensor<2x2xi8>
    %2 = stablehlo.sign %0 : tensor<2x2xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x2xi8>, tensor<2x2xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @expected() -> tensor<2x2xi8> {
    %0 = stablehlo.constant dense<0> : tensor<2x2xi8>
    return %0 : tensor<2x2xi8>
  }
}
