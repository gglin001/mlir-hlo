// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      stablehlo.return %arg1 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x2xi32>, tensor<5x2x2xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>) {
    %0 = stablehlo.constant dense<"0xA33F03C0F740A9BFDBBF38C024BFF1BF04C02AC01B3F6D40A8BF2B401240C340F7BF8BC07B3F8AC04B3FBE3FC9C0383F0F40753FDDBF0AC09EBEA5BF0EC091BF14C0CD3F933F6840CCC0F7C0D33FA6C0084082C0D33FD4405AC0693FA040133FEABFA7BD1DBF824095C0B8C033C0D0C03EC0E0BFE1C084C0CFC02340E1BD073F07402BBF1CC0C8BF94C039402FC086BF1440B5C04CBFBBC0C1BF89C040C0A7C0B0C0DE3F09C0193E3AC025C09DC083BFFEBFFEBFC5BE4DC012C0773F37BF93C0B33E58C0D7BF703F5EBFF83F19403D400EC07CC01FC086BEC43E93BF2040723E42BEB9407EC03040C1407FC0BE3E22C0B53F9F40F3BF8E409040A23F3ABF72BF64C09540B13F47C049407540AB3F713E17C075C05840D8BF76BEE63E80BFF93D99C05EBF5F406B406240843FB5BE81C015C0CABFAD3E5B404CC042404440BEC02FC020C071BF9EBFF0BF58C0C7BF5FBFA53E3ABFF5BF953F8B40993FB140073F97BF1B3F4BBF0540ECBF9D3E19C0DA3F7B4006C00DBFFEBFC2BED9BF61C008C0C5BE784049BE2BC0933F8E40064022C0784044C02BC0573F263FB84009C067C0E83E3040"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<[[[4.531250e-01, -7.406250e+00], [1.109380e+00, -6.843750e+00]], [[3.703130e+00, 3.808590e-01], [3.140630e+00, 3.453130e+00]], [[2.519530e-01, 2.453130e+00], [-1.010740e-01, 1.343750e+00]], [[1.539060e+00, 1.687500e+00], [-1.240230e-01, 1.937500e+00]], [[1.500000e+00, -3.171880e+00], [4.250000e+00, 8.906250e-01]]]> : tensor<5x2x2xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0xA33FE83EF740A9BFDBBF38C024BFF1BF04C0DBC01B3F6D40A8BF2B401240C340F7BFEDC07B3F8AC04B3FBE3FC9C0383F0F40753FDDBF0AC08E3FA5BF0EC091BF14C0CD3F933F6840CCC0F7C0D33FA6C0084082C0D33F6D405AC0693FA040133FEABFA7BD1DBF5D4095C0B8C033C0D0C03EC0E0BFE1C0C33ECFC02340E1BD073F07402BBF1CC0C8BF94C03940494086BF1440B5C04CBFBBC0C1BF89C040C0A7C0B0C0DE3F09C0193E3AC0813E9DC083BFFEBFFEBFC5BE4DC012C0AC3F37BF93C0B33E58C0D7BF703F5EBF1D4019403D400EC07CC01FC086BEC43E93BF2040723ECFBDB9407EC03040C1407FC0BE3E22C0B53F9F40F3BF8E409040A23F3ABFC53F64C09540B13F47C049407540AB3FF83F17C075C05840D8BF76BEE63E80BFD83F99C05EBF5F406B406240843FB5BE81C015C0CABFFEBD5B404CC042404440BEC02FC020C071BF9EBFF0BF58C0C7BF5FBFA53EC03FF5BF953F8B40993FB140073F97BF643F4BBF0540ECBF9D3E19C0DA3F7B404BC00DBFFEBFC2BED9BF61C008C0C5BE784049BE2BC088408E40064022C0784044C02BC0573F263FB84009C067C0E83E3040"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

