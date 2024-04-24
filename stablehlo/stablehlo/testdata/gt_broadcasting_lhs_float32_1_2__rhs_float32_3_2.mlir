// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x2xf32>, tensor<3x2xf32>)
    %1 = call @expected() : () -> tensor<3x2xi1>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x2xf32>) -> tensor<3x2xf32>
    %3 = stablehlo.compare  GT, %2, %0#1,  FLOAT : (tensor<3x2xf32>, tensor<3x2xf32>) -> tensor<3x2xi1>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3x2xi1>, tensor<3x2xi1>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2xf32>, tensor<3x2xf32>) {
    %0 = stablehlo.constant dense<[[-3.03660369, 1.25467861]]> : tensor<1x2xf32>
    %1 = stablehlo.constant dense<[[2.25743055, -6.95651674], [0.140850127, 4.397861], [-3.43993378, -0.119425319]]> : tensor<3x2xf32>
    return %0, %1 : tensor<1x2xf32>, tensor<3x2xf32>
  }
  func.func private @expected() -> tensor<3x2xi1> {
    %0 = stablehlo.constant dense<[[false, true], [false, false], [true, true]]> : tensor<3x2xi1>
    return %0 : tensor<3x2xi1>
  }
}
