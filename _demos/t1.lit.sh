lit --help >_demos/lit.help.log

###############################################################################

args=(
  build_cmake/tests
  --show-tests
  --debug
)
lit "${args[@]}"

###############################################################################

args=(
  build_cmake/tests
  # --no-execute
  # --debug
  -v -a
  # --filter "MLIR_HLO_OPT :: bufferize.mlir"
  # --filter "MLIR_HLO_OPT :: bufferize_one_shot.mlir"
  --filter "Dialect/deallocation/buffer_reuse.mlir"
)
lit "${args[@]}"
# lit "${args[@]}" | tee _demos/lit.run.dirty.mlir

###############################################################################

export FILECHECK_OPTS="--vv --dump-input=always --color=1"

mlir-hlo-opt tests/Dialect/deallocation/buffer_reuse.mlir -split-input-file -allow-unregistered-dialect -hlo-buffer-reuse |
  FileCheck tests/Dialect/deallocation/buffer_reuse.mlir

###############################################################################
