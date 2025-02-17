// RUN: mlir-hlo-opt %s \
// RUN: --hlo-canonicalize-gather --legalize-mhlo-to-thlo \
// RUN: --hlo-legalize-to-linalg \
// RUN: --gml-tiling="tile-sizes=1 distribute=false op-name=thlo.gather" \
// RUN: --scalarize -cse --canonicalize |\
// RUN: mlir-hlo-opt \
// RUN: --empty-tensor-to-alloc-tensor --hlo-one-shot-bufferize --canonicalize \
// RUN: -cse --convert-bufferization-to-memref \
// RUN: --gml-st-to-scf --buffer-results-to-out-params --convert-scf-to-cf \
// RUN: --generic-host-to-llvm -cse --canonicalize |\
// RUN: mlir-cpu-runner \
// RUN: -e main -entry-point-result=void \
// RUN: --shared-libs=%mlir_lib_dir/libmlir_c_runner_utils%shlibext,%mlir_lib_dir/libmlir_runner_utils%shlibext \
// RUN: | FileCheck %s

func.func @gather(
    %operand : tensor<5x2x1xf32>, %indices: tensor<3x2xi64>) -> tensor<3x2xf32> {
  %0 = "mhlo.gather"(%operand, %indices) {
    dimension_numbers = #mhlo.gather<
      collapsed_slice_dims = [1, 2],
      index_vector_dim = 1,
      offset_dims = [1],
      start_index_map = [0, 1]
    >,
    indices_are_sorted = false,
    slice_sizes = dense<[2, 1, 1]> : tensor<3xi64>
  } : (tensor<5x2x1xf32>, tensor<3x2xi64>) -> tensor<3x2xf32>
  func.return %0 : tensor<3x2xf32>
}


func.func @main() {
  %operand = arith.constant dense<[
    [[1.0], [2.0]],
    [[3.0], [4.0]],
    [[5.0], [6.0]],
    [[7.0], [8.0]],
    [[9.0], [10.0]]
  ]> : tensor<5x2x1xf32>

  %indices = arith.constant dense<[
    [0, 0],
    [1, 0],
    [4, 1]
  ]> : tensor<3x2xi64>

  %result = func.call @gather(%operand, %indices)
      : (tensor<5x2x1xf32>, tensor<3x2xi64>) -> tensor<3x2xf32>

  // CHECK: rank = 2 offset = 0 sizes = [3, 2] strides = [2, 1]
  // CHECK-NEXT: [1, 2]
  // CHECK-NEXT: [3, 4]
  // CHECK-NEXT: [10, 10]
  %result_unranked = tensor.cast %result : tensor<3x2xf32> to tensor<*xf32>
  func.call @printMemrefF32(%result_unranked) : (tensor<*xf32>) -> ()

  func.return
}

func.func private @printMemrefF32(%ptr : tensor<*xf32>)
