// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<2x7xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2xi32>, tensor<2x7xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<2x7xbf16>) {
    %0 = stablehlo.constant dense<"0x4CC05B4080C088BF25400740CA3F7340893FE13FD83FC5BD5ABE2B4083BDE03F14C059C090400CC0BDC04ABF22C029BF6CBF2ABF683ECCBFEA3F48BE5E3FC2BF8F3F83BF1C403EC0A540AA3F0EC09A40C8C0F9BECE406B4003C1DDC03F4014C0F93F9D407CC04E40E53F9BBF5CC00FC0CE3FFFBF01C1DFC0AB3FA63F31BE1940DB3F06C08CC0913F76BF87C01640AEC02FC0203FABBFF63F33BF11BF33BF07BFD13E31BF9F3FC93D96BFE23F12C06140C04016403CBF1CC0E13F0741243EEE3E3BBFEDBF863E35C0A240C1C05BC00540E4BD39C07BC0143F423DE33E823FA5BF57C0893F324036C01DBFB6C02FBFBB40B0C0ACBF73C0D5402240094042404ABE243F893E87BFAA4049BF90C0863F973D48BF933F2140C1C02F4019BCC8BE07C0F93F84BF46BEEB3F44C073C0C8BF3AC0C3BF22C0EABF973FFBBF083F01BE98BF533F71C02C4042C0EEBD233E27C046BFDBC01EBF9EBF093F25BF8AC0A2BD9EBED5C074C08ABF843F933F30407DBEA8BE524027C0E1C060C070C08A405A3D18401340D43F55BF244021BF1F4083C011BF91C0A84020C0103EABBD12C00E3FF4BFDEBF06C0"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<[[-7.578130e-01, -2.859380e+00, 8.203130e-01, -5.517580e-02, 7.593750e+00, 7.128900e-02, -2.234380e+00], [1.164060e+00, -1.351560e+00, 6.656250e+00, 4.343750e+00, 8.476560e-01, -5.031250e+00, -9.218750e-01]]> : tensor<2x7xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<2x7xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0x4CC05B4080C088BF25400740CA3F38C044C0B93FBFBD3BBF79BCBFC083BDE03F14C059C090400CC0BDC04ABF22C029BF6CBF2ABF683ECCBFEA3F48BE5E3FC2BF8F3F83BF1C403EC0A540AA3F0EC09A40C8C0F9BECE406B4003C1DDC03F4014C0F93F9D407CC04E40E53F9BBF5CC00FC0CE3FFFBF01C1DFC0AB3FA63F31BE1940DB3F06C08CC0913F76BF87C01640AEC02FC0203FABBFF63F33BF11BF33BF07BFD13E31BF9F3FC93D96BFE23F12C06140C04016403CBF1CC0E13F0741243EEE3E3BBFEDBF863E35C0A240C1C05BC00540E4BD57C0AA407640533EC03EA4C0983F57C0893F324036C01DBFB6C02FBFBB40B0C0ACBF73C0D5402240094042404ABE243F893E87BFAA4049BF90C0863F973D48BF933F2140C1C02F4019BCC8BE07C0F93F84BF46BEEB3F44C073C0C8BF3AC0C3BF22C0EABF973FFBBF083F01BE98BF533F71C02C4042C0EEBD233E27C046BFDBC01EBF9EBF093F25BF8AC0A2BD9EBED5C074C08ABF843F933F30407DBEA8BE524027C0E1C060C070C08A405A3D18401340D43F55BF244021BF1F4083C011BF91C0A84020C0103EABBD12C00E3FF4BFDEBF06C0"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

