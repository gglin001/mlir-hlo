// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>) {
    %0 = stablehlo.constant dense<"0x52C0BEBF8B40D7BF55C0E340B1BF59C08CC01FC0D3BFA2406EC02C403B3FA53E75406F4012C02C3F36BF87C089C0513F2E40E3C086C0D6C067BE5A3F3A40C03F153DA4409BBFD93FB1C031BF664076C04FC0E6BF05BF3F3DB7BF1F40213EC03F00401740D13F033F86C0104079BEEEBFF9BE69BEC53F904074BFC33F294023BF933FDE3F98C063C08D3F5AC02CBFFEBFD6BFA9BF82BF44C01040394071404740E0BF1DBD0F40B6C0F53FC43F1C3F3E40DFBF15BF6EC0BB3FB7C0F63F72BF92BF3240973FA6BF9BC0C33F6F4095C0594037C03DC092401CC09C40F13F023D133EF6BF47BEB93F3640B83CD43E85BF6D40E53DBB407DC0C3C026C02B3FCABF864042C0F0400CC0CC3F58BF4840FB40AA3FAB3FED3F0840283EB73FC03E27C035C00BBEAF3F37403E40824082BF46BF893F15406E40CE3F4EBF37C006403A409BBFED3FCA3F04BFCD3E623F00BFF740543E7A4086C04E3E1540B6C08CBEACBD6A40963EBD409F3F313F5F40F1BE4C405DBF1E40C1401CC018404DC09CBD183FF0BC1E40AA3F12407F3F6E3FDBBFD9409FBD6FC00AC088BF1C4081C097BDA23E2B405E3E66C0"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<"0xCFC0F1C096408140D640D63FB44069C02A4019BF01BE43C0B03E49C061C0AF3F0F40CEBF13BF53C07FC0E7BF1AC0843FCC408C40854070401E40D83F0B3F96BD773F053FEE3E9DBFB1BD6840DEBE9CC0023FCCC0C5C04A406F40C1BF2E401540A0BFCE3F98C0443F17C1D9408340303FAC3F8B4059403540C03E26C097C0D73F0BC09BBF5A4016401740F2401EBDDFBF24BF594036C0623F0BBFBB3FB2BFA8BEF3BF83C03DC093C03DBF1EBF4C4018403C40C2BF513F6E40AE3F90C01D4058C01CC034BEF5BF3DBF91BF76C0493FA6BFC5BF9D3FA1BFBB3F99BF70C08DBF7E40D8BF9EC05CBF8D3F86BF5ABEDB3F603E35403CBFFAC02FC03940E23E64C05B40AC3F1CC0783EFCC0A4BF60C064C0514080401ABF40406A40"> : tensor<5x2x2x7xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0xAA413341A341D9C0B2C13E41F9C046413AC1BE3F553E77C1A4BF07C124C0E23E0941C0C0A83F0EC03540F4402541583F8B41F8C18BC1C9C167BE5A3F3A40C03F153DA4409BBFD93FB1C031BF664076C04FC0E6BFA4BFA13D47BF3ABE1B3E483F6E3F39C011BEED3FE83F30C1FDBD3E41404038BFB840D9C026C0634053C083BFAFC0AA3F3342C0C1904016C02CBFFEBFD6BFA9BF82BF44C01040394071404740E0BF1DBD0F40B6C02540D5400440064127BFC13F8C411D40474115C04EC02BC0D2400F414D3D07417ABF4B4154414040C73F8AC0CBC04D3F14C1F7C0C0BD29BFF6BF47BEB93F3640B83CD43E85BF6D40E53DBB407DC0C3C026C02B3F953F25C01BC18E41CEC01BC030BF3A412B41BFC05240C8C0A6C0ECBC2FC08EBE3D402E41DABDE3BF8DC06940A4C0BEBF6D3F80C024C06C41CE3F4EBF37C006403A409BBFED3FCA3F04BFCD3E623F00BFF740543ED3C0A54131BE2440BF406E3D13BE4D3F543F8BC01BC1F2BF214155BE36C13DC054406BC117BF96C18340883E07C0C4BD1E414DBFDB4069406E3FDBBFD9409FBD6FC00AC088BF1C4081C097BDA23E2B405E3E66C0"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

