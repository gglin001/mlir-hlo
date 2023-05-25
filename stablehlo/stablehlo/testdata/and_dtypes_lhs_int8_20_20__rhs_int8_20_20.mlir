// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi8>, tensor<20x20xi8>)
    %1 = call @expected() : () -> tensor<20x20xi8>
    %2 = stablehlo.and %0#0, %0#1 : tensor<20x20xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi8>, tensor<20x20xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi8>, tensor<20x20xi8>) {
    %0 = stablehlo.constant dense<"0xFFFE0304FE0502FF00FEFF06FB01FB0100FAFD0104FBFA06040300FE0100F80000FDFE0101FEFE030501FC0401FFFF02030302FC07F904FD02000000FF050000FFFC00FD0000FD0302040400010301FF010001FF0002020003FAFFFEFA0300FF00FC0400FE04FE00000000000000FFFD00FE020404000202FC04010000000005FEFF0401FE02FA03000003010603FB00FD000401FE010000FF0200FFFCFE0000FF020301FE02FE0700FE00FD02FFFFFE00020300FE01020700FC0100030001000100040000FCFFFEFEFF000202FFFC02FEFE00030301FFFE0001FA000202FF01FF0000FB0000FF0002FF000500FD010000FD00000000FE0600FFFC0103FD040000000100FEFF03FDFA0301FE00FF0100FE00000000020308FF04030000FD00000000000001FD02000200FF00060105FB00FE05FD00010000FF0002FF0200060202FE0303FE00FBFB050102000400FF000101FFFFF90401FDFFFD0000040100020200FD00FD01FE000000FD00FE00FFFE00FB01FDFE00FEFF0105FE010404FC0100FD03FB00FF0000FF010500FFFDFCFE"> : tensor<20x20xi8>
    %1 = stablehlo.constant dense<"0x00FC05010003FE00010000040103020000FF00020000FFFE020100FF000006FB020700FDFB0200FE01FEFEFEFF02FA0300040000FE00FF03FF0100FF0206FB0100020004FF02000404FFFFFA010206F7FFFE0107FF000303FFFB0300FE010100FC01FBFFF9FA070100030102FD020305FF02FF000400FE000300080405FF0000010005000200000100FB0702FF01000101FC00000301040000FE00FF00FB0002FF04FE04FCFDFD0301FCFEFEFC02FBF9FDFF010002FDFD010200000002FFFD010003000000020000FC0002FF000008FF01FCFC0505FF03000200040402010002FF010302FFFE040004FEFC00010001FE0000FE0002000006FFFB0001FE00FFFE0300FF0200FEFD00020000FE0002FF0002FEFAFD00FE00FB0001FC00FDFD0107010100FFFDFDFAFDFB0100FD000101FCFF0202FD00000002FD00000101000103FFFE000001FC010100FCFF00FF0001FCFD0302000300000201FD00FF0102FE0002FFFD020000FF050100F8FD00FBFFFE02FFFE020000FEFC010000010203FEFE0003FD00FC07000300010102FDFD00FE"> : tensor<20x20xi8>
    return %0, %1 : tensor<20x20xi8>, tensor<20x20xi8>
  }
  func.func private @expected() -> tensor<20x20xi8> {
    %0 = stablehlo.constant dense<"0x00FC010000010200000000040101020000FA00000000FA06000100FE0000000000050001010200020100FC040102FA0200000000060004010200000002040000000000040000000000040400010200F7010001070000020003FA0300FA01000000000000F8000600000000000000030500020200040002000000000000000000000004000200000100000300060100000100000002010000000200FF00FA0000FF000200FC00FC0300FC00FC0002FBF8000201000201000100000000020001000000000000000000FC0000020000080200FC0001010103000000000002000000FF0000020000040000FE000000000100000000000000000600FB0001020004000000010000FE0100020000FE0002010002000000000200080000000000FD00000000000001FD020002000000000101F8000200FD00000000FD0000010000000202FE0000000001010000020004000100010102000100000001FD0000000000000200FD000000FE000000F8000000FFFE00FB00000000FEFC010000010000FC00000101000007000000010100FDFD00FE"> : tensor<20x20xi8>
    return %0 : tensor<20x20xi8>
  }
}
