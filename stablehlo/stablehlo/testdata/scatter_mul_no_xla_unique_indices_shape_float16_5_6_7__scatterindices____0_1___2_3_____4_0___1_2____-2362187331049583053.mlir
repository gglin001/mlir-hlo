// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<5x2x2xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2x2xi32>, tensor<5x2x2xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<5x2x2xf16>) {
    %0 = stablehlo.constant dense<"0x0FC596B776BC51BE14BF9E3CF84126440B41A934D8C2323D98C0F241933EE0C15FB831B9F9C276B8043B74C3BAB73B39CEC0DDBAF3C43BBACFBC79C1AB455640B13CF1BCAEBEE73B2439C23D06C397B59C443A3EEEC198C4B0C0D8BF90BFB24437C389C2BF37FFB040BA5C3D8AC2B04292B2AB43C7443E3DF4C60C35B5C2573D91C1E1C05E3A954673B84FC00641B638BCBCCABF42BD6FB85AC40B4047C4762FBE45623BB2439BBD26A74738C8C1F4B25C399643DDC1F0BE75C0ACC019B36AC351C13CC27E4196BCE8BEC3B0A33834B6444303C115C1FDB87A40CA3FA4C40E3569AD8B3AF841A53AF8346B415A444F455DBD9942C2BC83B87C43074041C5DD440EC43F47CEBD4DBBD13CA33372454E3804C3F23DBD41C8C5AD44EBC04744C84808BC7244D1C3BE3B5E3D7EC308BC73C0DAC558BF1E441C37EA40B7C479B1CEC50EAB8EC6E3C3CDC500C4CFC1F53AEFC168C5ABC17538ACBD67B0D8C2B0BE134161C13B419C3AB8429F41E0B19FC0E3C6F540FDB8CD458F39272C1EBBE6B9253D493E24AC92B43D38CB3C4FC0BCC4C9BE27C29AC391BF0AC1B5BB353D35401A4071444C44"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[[1.185300e-01, 6.058590e+00], [-1.126950e+00, 2.314450e+00]], [[-4.609380e-01, -2.695310e+00], [-9.038080e-01, 4.089840e+00]], [[-9.140620e-01, 4.699220e+00], [2.056640e+00, -5.132810e+00]], [[-4.417970e+00, -1.987300e+00], [5.644530e-01, -1.686520e+00]], [[1.162110e+00, -7.523430e+00], [1.621090e+00, -5.574210e+00]]]> : tensor<5x2x2xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<5x2x2xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0x0FC531AB76BC51BE14BF9E3CF84126440B416539D8C2323D98C0F241933EE0C15FB8DDC3F9C276B8043B74C3BAB73B39CEC0DDBAF3C43BBA6B3D79C1AB455640B13CF1BCAEBEE73B2439C23D06C397B59C443A3EEEC13C40B0C0D8BF90BFB24437C389C2BF371CB940BA5C3D8AC2B04292B2AB43C74411C3F4C60C35B5C2573D91C1E1C05E3A954673B84FC08AC0B638BCBCCABF42BD6FB85AC40B4047C4762FBE45623BB2439BBD26A7D2B7C8C1F4B25C399643DDC1F0BE75C0FF4919B36AC351C13CC27E4196BCE8BE98B9A33834B6444303C115C1FDB87A40CA3FA4C40E3590B18B3AF841A53AF8346B415A444F455DBD9942C2BC83B87C43074041C55FCD0EC43F47CEBD4DBBD13CA333724543BB04C3F23DBD41C8C5AD44EBC04744C0CC08BC7244D1C3BE3B5E3D7EC308BC73C0DAC558BFA6401C37EA40B7C479B1CEC50EAB8EC6E3C3CDC500C4CFC1F53AEFC168C596C27538ACBD67B0D8C2B0BE134161C14ACB9C3AB8429F41E0B19FC0E3C6F540B144CD458F39272C1EBBE6B9253D493E24AC92B43D38C53F4FC0BCC4C9BE27C29AC391BF0AC1B5BB353D35401A4071444C44"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

