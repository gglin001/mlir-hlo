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
  --filter "MLIR_HLO_OPT :: bufferize_one_shot.mlir"
)
lit "${args[@]}" | tee _demos/lit.run.dirty.mlir
