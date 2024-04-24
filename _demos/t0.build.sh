# cmake --preset iree_llvm
cmake --preset iree_llvm_allen

cmake --build build_cmake --target stablehlo-opt
cmake --build build_cmake --target mlir-hlo-opt
cmake --build build_cmake --target all
