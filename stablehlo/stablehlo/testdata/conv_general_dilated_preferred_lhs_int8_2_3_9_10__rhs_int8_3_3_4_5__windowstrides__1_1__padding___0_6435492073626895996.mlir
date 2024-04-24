// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xi8>, tensor<3x3x4x5xi8>)
    %1 = call @expected() : () -> tensor<2x3x6x6xi32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xi8>, tensor<3x3x4x5xi8>) -> tensor<2x3x6x6xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xi32>, tensor<2x3x6x6xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xi8>, tensor<3x3x4x5xi8>) {
    %0 = stablehlo.constant dense<"0xFD0002FF0102FDFDFF000206FCFDFAFFFF01FCFE0004FB0001FFFEFD0100FF0400FD0200FF0100FEFEFB00000000F9FEFDFA0200FE00FCFAFBFFFC00FC02FFFD000003FC0300FE0206FF04FE00FBFC03FF040001FE0200FEFFFD030003000007FDF802FE01FAFFFE01FC000007020006FEFEFD00FE03000301FEFF0302020302020400030306FF01020100FEFFFE000003040200FB040304050201FAFF000003010000F9020403000401FE00FFFFFDFE0005FEFF0000FA010001FE02FF040500040006030202FCFE00FD0001FBFFFAFD0002FE0202FF06FC0005FF0300060103050002020201000001FB000003000001F90002FF09FC0100000100FC04FBFFFFFF030002FC0000020602F904FDFFFDFFFD00FF00FDFFFF0102FE0100FE0305FEFE03FAFAFF02FF02010001FF0002FD01000007FF0103FEFEFBFFFC01FEFC0405FE00F9FC00F7FF0001FCFD0200FF030005FEFE030006FE01FD00FFF8FFFD00FFFE0100FBFFFC0002000201030300060000010103FB0003FF0102020000FF010001FFFE04F900FDFFFC0004FC030206FE00FC04FC00000003000000FF010203FE00FD0200FA01FF000000000000000300FC01FCFE02FF0003FDFF01FEFEFF0000FEFB0005FF040001FDFE01FB00FB020006FD0000FF000100FE0102FFFC000401FBFC00FC0200FF00FE0202FF0101000006F801000200FF00FD01FFFE00FA01000104010508030206FA0401FBFFFE01FE00FC000001FF030305FEFDFE"> : tensor<2x3x9x10xi8>
    %1 = stablehlo.constant dense<"0x030000000500FDFFFBFF01FA03000002FD0504FCFE000000020600FFFEFDFFFF04FD04FEFE040000000501FE00FF00FFFD020300FEFE010100FD00000002FFFF0100010201FA04FC010000FC0201FF00FF02FEFF00FF03FF04020001FEFD0100FE02FD01FE02FD00FD000201FB0101FC03FCFFF804FF01010000FEFE01FDFEFFFE00FE00030200FFF9020305FD01FB00FFFD010300FD0104000103FD01FD00FE00FF00010000000000FD0004FFFDFE0004020201"> : tensor<3x3x4x5xi8>
    return %0, %1 : tensor<2x3x9x10xi8>, tensor<3x3x4x5xi8>
  }
  func.func private @expected() -> tensor<2x3x6x6xi32> {
    %0 = stablehlo.constant dense<"0x92FFFFFF3A000000F4FFFFFFFEFFFFFFE2FFFFFFF9FFFFFFD5FFFFFF620000000E00000009000000FCFFFFFF270000001200000002000000C4FFFFFFE5FFFFFFD4FFFFFFE0FFFFFF0700000014000000F4FFFFFF4B000000E0FFFFFF5A000000F2FFFFFFB5FFFFFF5B0000001D0000005C000000B9FFFFFF4A000000B5FFFFFF18000000FBFFFFFF14000000ABFFFFFF440000000C0000009AFFFFFF4C000000F3FFFFFF4C000000AFFFFFFFE4FFFFFF07000000D5FFFFFFD1FFFFFFE9FFFFFF00000000BEFFFFFF5000000014000000F4FFFFFF5600000080000000D4FFFFFF120000002F000000AAFFFFFF28000000FFFFFFFF0E00000015000000E1FFFFFF0B000000C1FFFFFF82000000B3FFFFFFF6FFFFFF0B000000B4FFFFFFD4FFFFFFA8FFFFFF1E0000002A000000E1FFFFFF070000000F000000590000000A0000003E0000002F000000CCFFFFFF36000000F3FFFFFFDEFFFFFFEEFFFFFFEFFFFFFF08000000F0FFFFFFF7FFFFFF32000000D9FFFFFFEBFFFFFFF0FFFFFF1F000000E3FFFFFFB9FFFFFFE0FFFFFF1B000000E7FFFFFFFBFFFFFFFCFFFFFF62000000F8FFFFFF02000000EAFFFFFFB5FFFFFF2800000014000000A0FFFFFF16000000F9FFFFFFEAFFFFFFE7FFFFFFCBFFFFFF3C00000018000000E8FFFFFFECFFFFFFCBFFFFFF24000000C4FFFFFFC7FFFFFFDCFFFFFFD4FFFFFFF5FFFFFF220000005B000000AFFFFFFF6D000000C2FFFFFFA7FFFFFF560000001B000000160000003F000000E4FFFFFF77FFFFFF1C000000A8FFFFFF87FFFFFF020000009EFFFFFF2F0000009FFFFFFF120000004E000000F1FFFFFF1100000000000000E1FFFFFF0A00000026000000E1FFFFFFCBFFFFFFF7FFFFFFDFFFFFFFE3FFFFFF2800000029000000E3FFFFFFE6FFFFFF1D000000F8FFFFFFF8FFFFFF36000000CDFFFFFFF2FFFFFF3700000093FFFFFFF2FFFFFF000000000A000000E1FFFFFF0E0000001300000013000000F5FFFFFF12000000BDFFFFFF110000000B00000035000000A2FFFFFFC1FFFFFF000000003E000000FBFFFFFF1700000005000000340000008EFFFFFF10000000F0FFFFFFC5FFFFFF330000000F0000004C0000002B00000043000000290000000A0000003F000000D4FFFFFF3000000011000000F9FFFFFFECFFFFFF0200000047000000D1FFFFFFD1FFFFFFF4FFFFFFF3FFFFFF20000000"> : tensor<2x3x6x6xi32>
    return %0 : tensor<2x3x6x6xi32>
  }
}

