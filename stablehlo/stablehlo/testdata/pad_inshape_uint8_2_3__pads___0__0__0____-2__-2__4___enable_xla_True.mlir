// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3xui8>, tensor<ui8>)
    %1 = call @expected() : () -> tensor<2x7xui8>
    %2 = stablehlo.pad %0#0, %0#1, low = [0, -2], high = [0, -2], interior = [0, 4] : (tensor<2x3xui8>, tensor<ui8>) -> tensor<2x7xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x7xui8>, tensor<2x7xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3xui8>, tensor<ui8>) {
    %0 = stablehlo.constant dense<0> : tensor<2x3xui8>
    %1 = stablehlo.constant dense<0> : tensor<ui8>
    return %0, %1 : tensor<2x3xui8>, tensor<ui8>
  }
  func.func private @expected() -> tensor<2x7xui8> {
    %0 = stablehlo.constant dense<0> : tensor<2x7xui8>
    return %0 : tensor<2x7xui8>
  }
}
