// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi8>, tensor<20x20xi8>)
    %1 = call @expected() : () -> tensor<20x20xi8>
    %2 = stablehlo.or %0#0, %0#1 : tensor<20x20xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi8>, tensor<20x20xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi8>, tensor<20x20xi8>) {
    %0 = stablehlo.constant dense<"0x00FF010500FF01030000FDFFFF0004FF01FDFBFFFDFFFB00FDFE00FF0002000001030200020401010203FBFCFD05000100FE00FDFFFC00FE00FF0001FD0000FFFC0200FE000003FF010200FF01FE020000FB01000000FFFD0000FBFEFFFE020300FA01FF0300000004000003010002000105FF04FE010005FBFEFD020100FD000000FF000004FE00FCFF00FF00FF0107FD00FDFF00FD0101FD00FE0501FFFDFFFE02F9FE00FFFE02FF02020304010005FCFD01FFFFFFFD03FD0006FEFDFF00FFFE00010000FF020100FF0100FC0203FCFF00020101FD0002000303FC04000000FE03FB060005FB030100FD01FE0102000500FDFF000500FF00FBFD0001FFFFFE02FF0100FD03FE0100FB04FD04F900FE02FFFD0201FA01030200FDFAFF05FF05FA02000002FEFCFAFD00030403000002FD04010203FD0001000404000000FE0004FD04FE00FB04000203FFFEFE0303FD09FBFFFC00FE030002FFFFFF0201FF05FF05FD020002FDFA00050204FD03FF00FF0103FF01010508FF01FEFC000302FC000003FF0200FF0302FFFDFBF600FF00"> : tensor<20x20xi8>
    %1 = stablehlo.constant dense<"0x00FEFAFE00020002FF0101FE03FC0400000100FE00FF0205FF01FF00000000FDFCFE00FE01FF0004FC00FE010000FFFF01FFFE00010004FEFF02FF0200FC0300FFFF0604FE01010500FE0400F90300FE0206FCFB0502FD01FF00FF00FEFB00000001FE000302FD0202FEFFFF010100000100020002020304FE04FF000002FE00030002FC030100FD00070601FF0001FF040000FD01FE00FA00FDFC04030206FA060200F70003FB07FF0000F90000FDFEFDFEFE01FFFBFF000000FF00030300FEFD01FEFCFC0601000307010005FEFD0702FD00FEFEFFFE00FD00FE01000000FF0500FD0002000101FDFF02FC00FE03FF00FF04FD00FB00FA0000FC000304FE02FEFF00FC010000FB020000FCFCFD04010501FEFF0200010101FFFFFF0100000101FFFBFA04010000FD0007FEFE00030202FE0301F9FFFF00FD0304FD000001FD0002010101FDFFFF03FF02FCFBFA010100040101FE0500040000FF0203FF00FEFF04000204FB01FC050004FDFDFF010402030100FE00FDFF00FDFDFF02FE000402FCFB010104010000FFFF00FEFFFDFF"> : tensor<20x20xi8>
    return %0, %1 : tensor<20x20xi8>, tensor<20x20xi8>
  }
  func.func private @expected() -> tensor<20x20xi8> {
    %0 = stablehlo.constant dense<"0x00FFFBFF00FF0103FF01FDFFFFFC04FF01FDFBFFFDFFFB05FFFFFFFF000200FDFDFF02FE03FF0105FE03FFFDFD05FFFF01FFFEFDFFFC04FEFFFFFF03FDFC03FFFFFF06FEFE0103FF01FE04FFF9FF02FE02FFFDFB0502FFFDFF00FFFEFFFF020300FBFFFF0302FD0206FEFFFF010102000105FF04FE030305FFFEFF020102FF000300FFFC0305FEFDFCFF06FFFFFF01FFFD00FDFF01FF01FBFDFDFE0503FFFFFFFE02F9FF00FFFF07FF0202FB0401FDFFFDFFFFFFFFFFFF03FD00FFFEFFFF00FFFF01FFFCFCFF030103FF0100FDFEFFFFFFFD02FFFFFFFE02FD03FFFD040000FFFF03FF060205FB03FDFFFFFDFEFF03FF05FFFDFF00FF00FF00FBFD0003FFFFFEFEFF01FCFD03FEFB02FB04FDFCFD04FF07FFFFFF03FA010303FFFFFFFF05FF05FBFFFBFA06FFFCFAFD0007FEFF000302FFFE0303FBFFFF01FD0704FD0000FFFD04FF05FF01FFFFFF03FFFFFEFFFB03FD09FFFFFDFEFF030402FFFFFF03FFFFFFFF05FD0204FBFDFE050506FDFDFFFF04FF0303FFFF01FDFFFFFDFFFF02FF02FC02FCFBFF0304FF0302FFFFFBFEFFFFFF"> : tensor<20x20xi8>
    return %0 : tensor<20x20xi8>
  }
}
