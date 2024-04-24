// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xbf16>, tensor<3x3x4x5xbf16>)
    %1 = call @expected() : () -> tensor<2x3x6x6xbf16>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xbf16>, tensor<3x3x4x5xbf16>) -> tensor<2x3x6x6xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xbf16>, tensor<2x3x6x6xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xbf16>, tensor<3x3x4x5xbf16>) {
    %0 = stablehlo.constant dense<"0x2FC00BBF734049C086BF74BE2AC0DDC0043D90C015C02CC0BCC0B140AA40653F483E923EDA3FB1C01FBFA63F35C0A3BDCAC038401F40EB3EF1BF5DC0243F224017C099405640873F26C05AC02EC198C02640C13F7DC08340F43F2BBF90C083C03F3F823EEDBF9FBFA73E3440D140F9BE7A40B8BFE43FAEBFDE3F543F41BFB6BFFABE1CC01640FCBF13BEF33E8EC024C0673FA9C0044053BF61BFBA3FCB3F863E9240A8C00CC0DDBEBF3F61C062C0A2BD81BFC93F5040CAC05D40FC3E014025407B3FABBFB9BFDC3F2E3EF23F204088BF4640C9BF02BF0FC0FB3ED7BF57C094BFB83F1440C83F64BF44C09D3F10BE39401F40E03FF8BF8B4047BF3140B2407C40E3BF6440A73F0CBF63C0E9406440C13F40C0373F1B403C3E78BEB53F91C08E4044BFC53F5C4086C03C3E89C0ECC04E4099BF903F5D3F8E40E93DB5BECFBA9CC006BF9040CEBF6A4088BFAB40213F6DC045405D3F1940094163BFA83F6EC0CABFAD3CCEBF18BF2CBF65BF2A40B0C072C0ACBF3BBF34C087C0B83FF93FF7BDCD3E4540BC3EA8BF63C0F2407AC0A1C0144039C07040D3C06ABFBE3E654084BF693D0540F3C08AC0773F74BF283F8AC06240213E75C0AE3FE2BF8D3F9640A23FD9BF24C0693F13400440CA3F5E3D6B40C2C00DC0D43FFF3F61C08D40463FA73F783FACC0A3BE923F71C0943F81C041BF8D407E40813F2C40E5BE33401E40ACBF4F406DC0C63FF63FA33F15C0E43F2DC0F9BF8CC02DBF24403840944063BF0D4010BE87BDB2C0A73FEEBE5B4002C017404E40D4BE93BF5A3FC0C0B9C0963F7D4094C0824011BF1C3FA240873F2040C1BF5EBFE43EACBF95BF603F654014C044400AC032C060BFB03F26BF163FE83E98BF543FA7BC43C01B3FEB3F41C0C8C0384084C0613F2CC0663FFFBFEC3F8EC02BBE3A3E8C4021BE383F01C00740E140083E81C09CBFC0C0A9BFBC3DBF3EEE3F194062C062C03C3F2840CFBE50BF4F4014C0CC40FA3D20BF9BC0C73FDEBE8A3EA14021C0ED3E45C0E9BE18407940EC3F913F0BBFB83F933F6EBE5C407FC009406640FFBD4DBFB23F9B3F98C0EEC00D3F7F3EA6C09F3F8C403FBFDCBF84C083C0B33F8BBF93BFC23F7FC0AE409DBF6340B9C04D40A4C0233F67C004405CC03A40953F8B4026C0C5BDA33E553FF03FC74094C0E2BCD3BFCF3F2FC0AFC054BFD5BF804093BF2C40723FBAC00CC0413FA63FF93FF6BF17C01AC0F3BF26BF74C085403DBC07400A40A9C0D03FADC048409D3FC23F8240983F67C06740F8BE5EBF5E4067C0B33FC83E28C0CF3FDD40DFBE99C04C40F8BF8D3E994062402640B7C004C045BFABBF7EC0D7BF3B40E33F8C4005C1113FC4BF584013BFABC0BBBFF63F6BC0D13D37C0D3C0FD3EBD40C53FECBF89401ABFC7BF00BE02C06BC0993E703E01C086405E3F943F7BBED53B4A40DC3F0FBF863F944055BFC1BE59BFC240A7BF51C081405840763EEB3F5A3F8E401D400C402E3F39401FC08EBEEABF07C037BF5CBF99C0B73FCFC06AC02E40A73F"> : tensor<2x3x9x10xbf16>
    %1 = stablehlo.constant dense<"0xB1403AC07E3F32C00D400740C03D8DC0633F8F3F88BEF33F19C0ECBE81402740ADBF6B400E40BCC0A83F54C0E7BFFB3FB33FEA3D55C025404DC0B240EEBFCB4052BFAF3FD2BE13C0774072BF5740D33E3A40653E96402BC06440FE3FBA3F9D3F28C00240D2C087C0F2BEA23F3CC0B7C029407B40A140C53F544089C070BFA5BFB53E3F4008402A40C33F86BFCFBF23C0AFC0AF40A44064409A402D40273F02C011C07C40DBBF163FC740ECBF3440ABC00DC07EC06A3DC93F173FEBBF324085C0CA3F3F3D0FC03E4078406DC0A4BF993EC43F6DBF4B407AC0154044C0984076C08F40DBBF8BBFCA3F9CC00240D1C0E53FD5407C4020C01F3F1F4082C07EBF1BC0ABC02D40EFBF0340A34013BD8B3D20C06A408040FBBF854085BE2440F33E50C05D4085BEC4BF7E40C6BE8F4006409540CF4001C099C036C02840E93F05C094BFDFBF3AC04D403BBF32BC8CC091BFC9C0194041407E408A40CA3E2F403E404F3F553E563F28C0953E"> : tensor<3x3x4x5xbf16>
    return %0, %1 : tensor<2x3x9x10xbf16>, tensor<3x3x4x5xbf16>
  }
  func.func private @expected() -> tensor<2x3x6x6xbf16> {
    %0 = stablehlo.constant dense<"0x5F42ADC21D43C0C2A842A1C29C42ABC2414230C12842C9C0FAC22A42A7C16942DB400642A642B142FDC21B42E3419D4291422841B0C09EC2BF42B641774205C30B4285C2CF4254C251C32143F2411A43F7C186420A42FCC16FC2D5C000C305C350424541E241C9C26341C8C0CC426FC25A4251C2BDC172C266C208C26AC11742B2403A420E42CCC1BDC169C2CE41C1C2C7C2FCC03D42A1C2A4C26BC23041B5408B4229C29A42A7C2E4C2C541624397C197C29442FAC130C24E42DC428D42B741FEC0C0C29FC2B34248428CC2B240C3414842BA42C74282C12B41D1417B4294C225C280C21CC1AAC01C43C6C2D541E2C16BC29442AC410DC3FC4119419F414C42F341C4C169C26BC284C2AF40B2C13D4208C21AC3CE3FD0C2B5C201C257C1AAC1B73F30C208C2ADC20E42DB3E5C41E3413D415F42E6C1B6413FC0B64281C2EEC28EC196C27742FA419F409A4139C1AEC248C103C2ABC292C16DC2954218C215423342F54231C190C29FC19F4239C22BC2E74201C2824280C287C2BDC2A6C292C14042A2428EC15342AAC24D402EC20D430E4210C206C2244242C207430AC2A2C1A4BFB8C1D6BF18C278C247C21842F340"> : tensor<2x3x6x6xbf16>
    return %0 : tensor<2x3x6x6xbf16>
  }
}

