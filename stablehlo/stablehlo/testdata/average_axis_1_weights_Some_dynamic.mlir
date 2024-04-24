// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x8x4xf32> {mhlo.sharding = ""}, %arg2: tensor<?x8x4xf32> {mhlo.sharding = ""}) -> tensor<?x4xf32> {
    %0 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %1 = stablehlo.reduce(%arg2 init: %0) across dimensions = [1] : (tensor<?x8x4xf32>, tensor<f32>) -> tensor<?x4xf32>
     reducer(%arg3: tensor<f32>, %arg4: tensor<f32>)  {
      %6 = stablehlo.add %arg3, %arg4 : tensor<f32>
      stablehlo.return %6 : tensor<f32>
    }
    %2 = stablehlo.multiply %arg1, %arg2 : tensor<?x8x4xf32>
    %3 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %4 = stablehlo.reduce(%2 init: %3) across dimensions = [1] : (tensor<?x8x4xf32>, tensor<f32>) -> tensor<?x4xf32>
     reducer(%arg3: tensor<f32>, %arg4: tensor<f32>)  {
      %6 = stablehlo.add %arg3, %arg4 : tensor<f32>
      stablehlo.return %6 : tensor<f32>
    }
    %5 = stablehlo.divide %4, %1 : tensor<?x4xf32>
    return %5 : tensor<?x4xf32>
  }
}

