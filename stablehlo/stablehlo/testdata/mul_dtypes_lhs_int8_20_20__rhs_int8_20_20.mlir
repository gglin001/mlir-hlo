// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi8>, tensor<20x20xi8>)
    %1 = call @expected() : () -> tensor<20x20xi8>
    %2 = stablehlo.multiply %0#0, %0#1 : tensor<20x20xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi8>, tensor<20x20xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi8>, tensor<20x20xi8>) {
    %0 = stablehlo.constant dense<"0x01FF0005FFFF0100FEFDFF0600020000FF0404FF0201F9FE0000FF000600000004FC01010103FF01FD00010000FAFE04FDFF0004FD02FD01FC000500FE00FFFA04FE00FD01FF020404FBF900FFFF01060001FF00FF02FD00030000FF00FCFFFD04FF0204030103FD01FF0500FE00FE0200FD00FB0000FFFEFE03FFF800000203FE0000FEFF020202FFFDFF0002FCFEFD00010002030001FEFEFF010004FDFD000204F9020003FCFF01000000020104FD0000FDFDFDFE01FF0002000000FCFC01FFFFFF00000206FDFF03FCFEFCFE0100FBFAFB01FD0000FAFCFB02FF05010100FE0501FFFE03FE0103FA05FF02FD02FF0000FB01FCFDFE0100FE00FCFE000300FF0100F801FAFB0300FD02FF03030305FC00FB010703FC01000302000200FCFF02FCFF05FD00FF08000004FC04FF02FFFCFFFF04040002FE00030000FF03FE000004FF0001FD02FA0100FEFA04FF0600000BFCFF05FE000500FD03FE0400FEFCFF0103FD02FE04FE030101FFFF01FBFF040502020004FEFE0002FEFEFFFCFF050000010204FFFF02000000FB0201FE02"> : tensor<20x20xi8>
    %1 = stablehlo.constant dense<"0xFF04FFFF0304FF01020002FC000201FFFB03FD00FFFCFF020000FEFE020000FEFEFF030000F90702FC00FD02FF0004FCFDFD03FE00FF030004FF040100FB04FFFD04FC0300FFFEFEFE0101FEFF000400FF00FCFFFDFC0400FF02030400FE02FFFEFFFEFD02FDFF000102FEFE0600FB0102040000FB01FF0002FF0100FEFC04FBFE00FD040102FFFC0002FEFF01020000FD03050200FA00FD03030000FDFEFE0300FD0401000001000200F903FF00FF0200000001FE0004010000FE0100FCFE000102FE00010202000000FE0300FC00FCFC000000000002FF01000001FF040400010402FB02FEFC01010400FDFE0304020204FE030006FF000001000000FC0001FBFFFFFF000103010402FEFD0000FFFEFFFC00FC000401FB02000200000000FE0200FE00FDF703FB0303000300FF000301010100FFFFFFFAFC00FEFF0004FE00FBFDFEFBFD05FC0502FE00020000FD04010302FF0400FF0000020603FFFA00030204FA030500FF04FFFFFF00FFFE0200FB0002F9FDFFFC00FEFDFE0100FCFE00FD00000100000001FF0304FF02010201"> : tensor<20x20xi8>
    return %0, %1 : tensor<20x20xi8>, tensor<20x20xi8>
  }
  func.func private @expected() -> tensor<20x20xi8> {
    %0 = stablehlo.constant dense<"0xFFFC00FBFDFCFF00FC00FEE800040000050CF400FEFC07FC000002000C000000F804030000EBF9020C00FD000000F8F0090300F800FEF700F00014000000FC06F4F800F70001FCF8F8FBF900010004000000040003F8F400FD0000FC0008FE03F801FCF406FDFD0001FEF600F4000A0200F4000000000100FCFDFF00000008F1040000F8FF04FEF800FA020002F800000003000400000006FAFD0000F406060000F4E4020000FC0002000000FE00FCFA000000FD060004FF0000000000100800FFFE020000040C00000008FA000800001400000000000006FC0000FFFB040400FE140205FCFA080103E80003FCF708FE00000A0300EE020000FE00000000000005FF000800FAF10300FAFC030000FDF6040000FC000CFCFB0000040000000002040002000900FDD8000000F4000100FDFCFFFF00FC00FE0C00000000000C040000F40200FDF1F8E2020000F40000EE000021F8011400000000FA12FAFC0000F4FE04EEF70A00FCF8FDFFFF0001FEF600EC0004F200FC080000FA04FE001002000000000200000002000000050401FC02"> : tensor<20x20xi8>
    return %0 : tensor<20x20xi8>
  }
}
