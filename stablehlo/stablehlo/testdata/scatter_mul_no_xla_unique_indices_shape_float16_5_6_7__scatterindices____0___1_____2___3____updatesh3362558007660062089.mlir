// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>) {
    %0 = stablehlo.constant dense<"0x56C06DC18E387DC3C3414EA8FF378DB7DDB9A53BB3B969C24FC26CBFE5409EC58B43613E5D37C53D1444C13E47BDF74103C1BEA6A93AAA352D34EBC5DEC25F34893496393C448DBD5A41F82E5ABAC83C3438083A0AB83C3F66408EB4C5C01CBFE0BC32BE2AC1AEC02BA081BC17BBB0346042863883B3374068BFB7B5DEC1D43E1EC1C03D6A46AABCBC39D3C3263C123F71C3D23DA0BBA8BAEBB59EB445C60DC498C17F3EDBAFDFC03EC237BB9641233F9CBE6BB868C16539B840E741BE38EDC171404EC4E9C10B3CA3BC86409F41F2B82AC46C3986C0213D2DC664419B43A6BC64350FBD79426EC3ED44D63E073AF5C676417BBF974175B5B4BB4D3C79C1E63EBCC4B533CBBD4DBBEDBA7534EEBB38B5D0383ABF4EAC0AC5F4C1014067C0133EEFC3C2C38BAEAEC46A44CDC308BE82B1E5C002463336B5BDDC3DA4C3D740854475C54835C3A870B84D3ADA3EACC6FDBD773708C214C040B26B440441A9C29DAE81C33EC4EEBF953E2E44194592B679C0EC46CCC3164044400D3EA8417FA125BCAC3AD2BBA2B3DD450FC1A1BF3AB90FC740384DC5E13B19AC9E40F9374AB8A6BC5138B7C4"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<"0xDAC0CD40B4C107C18CC470466AC8E2C3A83E65C3BC45C1C32B400539623CC6B3F43C9C40E1C3653081BFAAC5EA3C0A3D983B0DC4A8BE6045C6BD17C68F31ECBF7E3F43BCE03387C091443CC05539F0C40C443F2E3E455FBDCA3D2DC30BC6D833623848C5E53DA4C316C5FEC585451DC146C18DBD97C0CAC568BEC43C94C4D6370345973C743CBBC161C470BC3CB1ADB4ED425941B62D242DA2B88A38F5C1C7BF05C4C04027355BA4C5396C41DBC1BBC0FE3E87C17DB3BEAA943A81B05CC47B44F6C318B9E438A7BCE43EC5C0182ED14442C09B3BEEC1524210439943E740354058C0FD388EC3F842E63C1BC0103F9D4038BC0EB9D83D6BC4913D3EC26340B63C7A42824372430E3C10459CB938BE349D94C3D4C014BA73BC"> : tensor<5x2x2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<5x2x2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0x424583C67EBEB5488DCAEEB269C4713FE1BC11C316C4374A93C6A8BC5D41753DAC445A4340BF5732A7C7C8C87CBE8443C2C0D42E8BBD9C3F2D34EBC5DEC25F34893496393C448DBD5A41F82E5ABAC83C3438083AD43982C91D36833877C4933FCCB40343E5C9F4448E9D8F452CC352272D4C13BA70B590C798499AAD6EBE82C88AC37EC514D0FD46EA430049263C123F71C3D23DA0BBA8BAEBB59EB445C60DC498C17F3EDBAFDFC01D48023D69C62AC94B4143B9304A4935EA49C64248393F48DDC8C744BC37BAB404C40C4603345BAAD3402736BD46FCC0354E6746E63C102564350FBD79426EC3ED44D63E073AF5C676417BBF974175B5B4BB4D3CE5BFAD44EE4A8FB810C10B417C3283A385BAE0293FC10CC849346B4247BFA8C095C33EC30BB6ACCCF73273C48BCA2ACA53C53BB900C6524A3336B5BDDC3DA4C3D740854475C54835C3A870B84D3ADA3EACC6FDBD0EBC85BFB44772B9694526C5E1C5A1B3EA435C41CBC145C7D145F5CB35BB45C19B4D51CB9B475340A847EFBF4624641D52C2B840CD3186C60FC1A1BF3AB90FC740384DC5E13B19AC9E40F9374AB8A6BC5138B7C4"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

