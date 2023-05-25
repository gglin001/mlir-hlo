// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xbf16>, tensor<3x5x2xbf16>)
    %2 = call @expected() : () -> tensor<3x5x40xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xbf16>, tensor<2x1xi32>, tensor<3x5x2xbf16>) -> tensor<3x5x40xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xbf16>, tensor<3x5x40xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xbf16>, tensor<3x5x2xbf16>) {
    %0 = stablehlo.constant dense<"0x863F29C01CBF903F6AC032BF3440DDBE39C17D3D26402640D0BF98C0093F813F90C097BF1EC11A40D63F6FC0A240973E1140CEC03CBF05BEACBF963E00C0373F95C03EC06BC078BF5E3E44400B40D8BF9B40643EB4BF8A3F4240A9BFF23F66405FC05DC0EB3F2CBFC9BFFC3E97BF08BF6EC090C08140BCBF7C3F8FBF13C0B7407740C9BE09401F3F93BEB7BF23C07DBF77BFE7409FBF823E23C0C2BF4FBE1FBF75BF06C19B3E1D409540CABE354085BF3F3FA33FDF40E03EA43F5D4061407040F2BE87BFD0BE8EC007C091C0803E15C0BDBF17C0BF3F3D3E94BFFCBF364052C02540B2BE683EA43E694011C0BE4073BE153F7CBF55BF613F293FF53F52C003C0AA407E3DBE3F3DC069406EC0EEBEBE3E3340424005408DC02C400EBFDB3E1DC0283FDA3F3E3F39C0733FE7BD9BBF37401DC02A4074403DBF6BBFD0C0B3BF73C09A3FACC0C7C0A4C0224069407BC0D83E604034C0DCC0E5BF74BF3DC0EFBF7F401B4079C0793F4FBFCE3EDCBE37C0C33FD63F4CC00940FABF3FC0493D50BF2CBF5FC08A40944041C094C06BBF29C019C02C408D40A24069C00E4016C018C0EDBF39BF92405E408840B5BF1F3ED43F95C0C93F9940B03E2E409CBF64407040193F79BE89C0F93ECFBE85408F3F243D0E400FC0F5BF033F95404D3F5A4089BF36C03F4025BE39BFB23F8FBFA5408AC01A3F53C0B7C02DBF043FAD40FDBF05C0BABFA5400340B53F714049C00DBE7E3FC6408B40EFC0A840BABF6B405F40F9BF173FB040CCBF993F2740723FEEBFA53FE5C0BCC0123F82BF6CC0803F19408ABE5AC0B63F40407E3FE03F5340893F0BC08C40F6BF3F400C4016C0FDBF4DC0423F83C0EC3F5ABE36BF36C083C077C01440853EF13F7ABDE53D9D3F97400BC067BE204088403BC0AEC09C3F86403A3E28C0F9BF403E02BE03C084C05740A73F86C02DC029C0DBC0ACBF603F02BF9D40BF403F40353E33401E3F87C091C0ABBF94C0E23E88BF6440D3BFE83FA5C006C061C0F1BE9340383EBA3FA2BF0FBF6A3FCD3E46BF0640D93F1B40DA3F0740B0BE983F5AC06BBFA1BF354059C0E1BF97BF253FEA3FBFBE87BF6CC05B3FAB40FCBFAEBFD7C073C0ACBE444091C077C0353FB9BF56BF0D407A40E7C09940A53F5EC098BFC8C04C4005C06C402BC050C07D4032C03840E6BFE1BE83C07FBFEF3F90BFD0BDA340A5BFA640AFC00140E53F8A40FB3EF93FE33F81BEFD3FB1BF7DBF92C0BE3F48C0AC3FDA3FA6BE05BF993F1A4053C0944012C01C3DFEBFC0BE8E4045BE4D40FF3F00C023406740853F31C0C7BF814095BF42C028C046C0023F42C0993F91BE664082BFE63F9B400640C1C0933E0BBEEC3F53BE6BC01640DDBE36C053C0EEBFD5BF56C0063F01BF2AC09F3FAFC0D1BF8C40C2C085400CC0A8C0AFBF9DC06CBEC3BE853FCD3FEFBF2C409DBD17C1F5BF1740A33FB240044089C0A03FFFC0A2C00E4026408740FCBC04402DBF5AC0973FA1BF35402CBFE73F3CC09A3F5C3F36C08B3FF6BF464018C0713F5CBF7EBF20C0E83F3B3DABBE74401EBF40C00140703EBEBF53401040453ED8BE104093C0173FFD3FB2BF1FC03CBFB5C0223FD4C0E2403A3E0D405FBEC0BFB2403B40BABFA33F0CC00240AEBF3BBF2A3B79C014BD0FC019BFB140DCBF95BF84BF48C049BE8BBF34C0EE3F11BE634026BF573E44BF814053C0"> : tensor<3x5x40xbf16>
    %1 = stablehlo.constant dense<[[[9.437500e+00, 9.062500e-01], [-3.812500e+00, -1.742190e+00], [4.468750e+00, -2.000000e+00], [4.472660e-01, 2.250000e+00], [6.750000e+00, -6.494140e-02]], [[2.390630e+00, 3.375000e+00], [-2.578130e+00, 3.574220e-01], [9.023430e-01, -7.734380e-01], [-2.812500e+00, -2.468750e+00], [-3.125000e-01, 7.812500e-01]], [[4.589840e-01, -1.867190e+00], [1.054690e+00, -3.375000e+00], [-7.343750e-01, 1.179690e+00], [1.416020e-01, -3.390630e+00], [3.222660e-01, 2.890630e-01]]]> : tensor<3x5x2xbf16>
    return %0, %1 : tensor<3x5x40xbf16>, tensor<3x5x2xbf16>
  }
  func.func private @expected() -> tensor<3x5x40xbf16> {
    %0 = stablehlo.constant dense<"0x863FF7401CBF903F6AC032BF3440DDBE39C17D3D26402640D0BF98C0093F813F90C097BF1EC11A40D63F6FC0A240973E1140CEC03CBF05BEACBF963E00C0373F95C03EC06BC078BF5E3E44400B40D8BF9B40ABC0B4BF8A3F4240A9BFF23F66405FC05DC0EB3F2CBFC9BFFC3E97BF08BF6EC090C08140BCBF7C3F8FBF13C0B7407740C9BE09401F3F93BEB7BF23C07DBF77BFE7409FBF823E23C0C2BF4FBE1FBF75BFBDC09B3E1D409540CABE354085BF3F3FA33FDF40E03EA43F5D4061407040F2BE87BFD0BE8EC007C091C0803E15C0BDBF17C0BF3F3D3E94BFFCBF364052C02540B2BE683EA43E694011C0BE4073BE153FDB3F55BF613F293FF53F52C003C0AA407E3DBE3F3DC069406EC0EEBEBE3E3340424005408DC02C400EBFDB3E1DC0283FDA3F3E3F39C0733FE7BD9BBF37401DC02A4074403DBF6BBFD0C0B3BF73C09A3FA83FC7C0A4C0224069407BC0D83E604034C0DCC0E5BF74BF3DC0EFBF7F401B4079C0793F4FBFCE3EDCBE37C0C33FD63F4CC00940FABF3FC0493D50BF2CBF5FC08A40944041C094C06BBF29C019C02C402341A24069C00E4016C018C0EDBF39BF92405E408840B5BF1F3ED43F95C0C93F9940B03E2E409CBF64407040193F79BE89C0F93ECFBE85408F3F243D0E400FC0F5BF033F95404D3F5A4089BF36C03F4018C039BFB23F8FBFA5408AC01A3F53C0B7C02DBF043FAD40FDBF05C0BABFA5400340B53F714049C00DBE7E3FC6408B40EFC0A840BABF6B405F40F9BF173FB040CCBF993F2740723FEEBFA53FE5C0BCC0323F82BF6CC0803F19408ABE5AC0B63F40407E3FE03F5340893F0BC08C40F6BF3F400C4016C0FDBF4DC0423F83C0EC3F5ABE36BF36C083C077C01440853EF13F7ABDE53D9D3F97400BC067BE2040884004C1AEC09C3F86403A3E28C0F9BF403E02BE03C084C05740A73F86C02DC029C0DBC0ACBF603F02BF9D40BF403F40353E33401E3F87C091C0ABBF94C0E23E88BF6440D3BFE83FA5C006C061C0F1BE9340263FBA3FA2BF0FBF6A3FCD3E46BF0640D93F1B40DA3F0740B0BE983F5AC06BBFA1BF354059C0E1BF97BF253FEA3FBFBE87BF6CC05B3FAB40FCBFAEBFD7C073C0ACBE444091C077C0353FB9BF56BF0D402040E7C09940A53F5EC098BFC8C04C4005C06C402BC050C07D4032C03840E6BFE1BE83C07FBFEF3F90BFD0BDA340A5BFA640AFC00140E53F8A40FB3EF93FE33F81BEFD3FB1BF7DBF92C0BE3F48C0AC3F20BFA6BE05BF993F1A4053C0944012C01C3DFEBFC0BE8E4045BE4D40FF3F00C023406740853F31C0C7BF814095BF42C028C046C0023F42C0993F91BE664082BFE63F9B400640C1C0933E0BBEEC3F53BE4EC01640DDBE36C053C0EEBFD5BF56C0063F01BF2AC09F3FAFC0D1BF8C40C2C085400CC0A8C0AFBF9DC06CBEC3BE853FCD3FEFBF2C409DBD17C1F5BF1740A33FB240044089C0A03FFFC0A2C00E4026407C3FFCBC04402DBF5AC0973FA1BF35402CBFE73F3CC09A3F5C3F36C08B3FF6BF464018C0713F5CBF7EBF20C0E83F3B3DABBE74401EBF40C00140703EBEBF53401040453ED8BE104093C0173FFD3FB2BFEFBF3CBFB5C0223FD4C0E2403A3E0D405FBEC0BFB2403B40BABFA33F0CC00240AEBF3BBF2A3B79C014BD0FC019BFB140DCBF95BF84BF48C049BE8BBF34C0EE3F11BE634026BF573E44BF814053C0"> : tensor<3x5x40xbf16>
    return %0 : tensor<3x5x40xbf16>
  }
}

