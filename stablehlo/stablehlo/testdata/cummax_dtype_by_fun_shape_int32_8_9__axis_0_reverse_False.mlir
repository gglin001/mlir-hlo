// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<8x9xi32>
    %1 = call @expected() : () -> tensor<8x9xi32>
    %2 = call @cummax(%0) : (tensor<8x9xi32>) -> tensor<8x9xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<8x9xi32>, tensor<8x9xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<8x9xi32> {
    %0 = stablehlo.constant dense<[[0, 0, -4, 0, 2, 4, 1, 2, -1], [-1, -2, 1, 2, -2, -6, 0, 0, -2], [7, 5, 0, -2, -1, 0, 0, -3, 0], [2, 2, -1, 0, -2, 2, 1, -1, -3], [1, -3, 2, -3, -2, 2, -1, -4, -2], [-1, 4, 2, 2, 3, -2, -4, -2, 0], [0, -2, -2, -5, 0, 0, 0, 0, -1], [2, 6, -1, -2, -3, 1, -5, 0, -1]]> : tensor<8x9xi32>
    return %0 : tensor<8x9xi32>
  }
  func.func private @expected() -> tensor<8x9xi32> {
    %0 = stablehlo.constant dense<[[0, 0, -4, 0, 2, 4, 1, 2, -1], [0, 0, 1, 2, 2, 4, 1, 2, -1], [7, 5, 1, 2, 2, 4, 1, 2, 0], [7, 5, 1, 2, 2, 4, 1, 2, 0], [7, 5, 2, 2, 2, 4, 1, 2, 0], [7, 5, 2, 2, 3, 4, 1, 2, 0], [7, 5, 2, 2, 3, 4, 1, 2, 0], [7, 6, 2, 2, 3, 4, 1, 2, 0]]> : tensor<8x9xi32>
    return %0 : tensor<8x9xi32>
  }
  func.func private @cummax(%arg0: tensor<8x9xi32>) -> tensor<8x9xi32> {
    %0 = "stablehlo.slice"(%arg0) {limit_indices = array<i64: 7, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 2, 1>} : (tensor<8x9xi32>) -> tensor<4x9xi32>
    %1 = "stablehlo.slice"(%arg0) {limit_indices = array<i64: 8, 9>, start_indices = array<i64: 1, 0>, strides = array<i64: 2, 1>} : (tensor<8x9xi32>) -> tensor<4x9xi32>
    %2 = stablehlo.maximum %0, %1 : tensor<4x9xi32>
    %3 = "stablehlo.slice"(%2) {limit_indices = array<i64: 3, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 2, 1>} : (tensor<4x9xi32>) -> tensor<2x9xi32>
    %4 = "stablehlo.slice"(%2) {limit_indices = array<i64: 4, 9>, start_indices = array<i64: 1, 0>, strides = array<i64: 2, 1>} : (tensor<4x9xi32>) -> tensor<2x9xi32>
    %5 = stablehlo.maximum %3, %4 : tensor<2x9xi32>
    %6 = "stablehlo.slice"(%5) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 2, 1>} : (tensor<2x9xi32>) -> tensor<1x9xi32>
    %7 = "stablehlo.slice"(%5) {limit_indices = array<i64: 2, 9>, start_indices = array<i64: 1, 0>, strides = array<i64: 2, 1>} : (tensor<2x9xi32>) -> tensor<1x9xi32>
    %8 = stablehlo.maximum %6, %7 : tensor<1x9xi32>
    %9 = "stablehlo.slice"(%8) {limit_indices = array<i64: 0, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<1x9xi32>) -> tensor<0x9xi32>
    %10 = "stablehlo.slice"(%5) {limit_indices = array<i64: 2, 9>, start_indices = array<i64: 2, 0>, strides = array<i64: 2, 1>} : (tensor<2x9xi32>) -> tensor<0x9xi32>
    %11 = stablehlo.maximum %9, %10 : tensor<0x9xi32>
    %12 = "stablehlo.slice"(%5) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<2x9xi32>) -> tensor<1x9xi32>
    %13 = stablehlo.concatenate %12, %11, dim = 0 : (tensor<1x9xi32>, tensor<0x9xi32>) -> tensor<1x9xi32>
    %14 = stablehlo.constant dense<0> : tensor<i32>
    %15 = stablehlo.pad %13, %14, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<1x9xi32>, tensor<i32>) -> tensor<2x9xi32>
    %16 = stablehlo.constant dense<0> : tensor<i32>
    %17 = stablehlo.pad %8, %16, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<1x9xi32>, tensor<i32>) -> tensor<2x9xi32>
    %18 = stablehlo.add %15, %17 : tensor<2x9xi32>
    %19 = "stablehlo.slice"(%18) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<2x9xi32>) -> tensor<1x9xi32>
    %20 = "stablehlo.slice"(%2) {limit_indices = array<i64: 4, 9>, start_indices = array<i64: 2, 0>, strides = array<i64: 2, 1>} : (tensor<4x9xi32>) -> tensor<1x9xi32>
    %21 = stablehlo.maximum %19, %20 : tensor<1x9xi32>
    %22 = "stablehlo.slice"(%2) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<4x9xi32>) -> tensor<1x9xi32>
    %23 = stablehlo.concatenate %22, %21, dim = 0 : (tensor<1x9xi32>, tensor<1x9xi32>) -> tensor<2x9xi32>
    %24 = stablehlo.constant dense<0> : tensor<i32>
    %25 = stablehlo.pad %23, %24, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<2x9xi32>, tensor<i32>) -> tensor<4x9xi32>
    %26 = stablehlo.constant dense<0> : tensor<i32>
    %27 = stablehlo.pad %18, %26, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<2x9xi32>, tensor<i32>) -> tensor<4x9xi32>
    %28 = stablehlo.add %25, %27 : tensor<4x9xi32>
    %29 = "stablehlo.slice"(%28) {limit_indices = array<i64: 3, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<4x9xi32>) -> tensor<3x9xi32>
    %30 = "stablehlo.slice"(%arg0) {limit_indices = array<i64: 8, 9>, start_indices = array<i64: 2, 0>, strides = array<i64: 2, 1>} : (tensor<8x9xi32>) -> tensor<3x9xi32>
    %31 = stablehlo.maximum %29, %30 : tensor<3x9xi32>
    %32 = "stablehlo.slice"(%arg0) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<8x9xi32>) -> tensor<1x9xi32>
    %33 = stablehlo.concatenate %32, %31, dim = 0 : (tensor<1x9xi32>, tensor<3x9xi32>) -> tensor<4x9xi32>
    %34 = stablehlo.constant dense<0> : tensor<i32>
    %35 = stablehlo.pad %33, %34, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<4x9xi32>, tensor<i32>) -> tensor<8x9xi32>
    %36 = stablehlo.constant dense<0> : tensor<i32>
    %37 = stablehlo.pad %28, %36, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<4x9xi32>, tensor<i32>) -> tensor<8x9xi32>
    %38 = stablehlo.add %35, %37 : tensor<8x9xi32>
    return %38 : tensor<8x9xi32>
  }
}
