// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.constant dense<-1.000000e+00> : tensor<bf16>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<bf16>) -> tensor<20x20xbf16>
    %4 = stablehlo.compare  NE, %0, %3,  FLOAT : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<20x20xi1>
    %5 = stablehlo.multiply %0, %0 : tensor<20x20xbf16>
    %6 = stablehlo.constant dense<1.000000e+00> : tensor<bf16>
    %7 = stablehlo.broadcast_in_dim %6, dims = [] : (tensor<bf16>) -> tensor<20x20xbf16>
    %8 = stablehlo.subtract %7, %5 : tensor<20x20xbf16>
    %9 = stablehlo.sqrt %8 : tensor<20x20xbf16>
    %10 = stablehlo.constant dense<1.000000e+00> : tensor<bf16>
    %11 = stablehlo.broadcast_in_dim %10, dims = [] : (tensor<bf16>) -> tensor<20x20xbf16>
    %12 = stablehlo.add %11, %0 : tensor<20x20xbf16>
    %13 = stablehlo.atan2 %9, %12 : tensor<20x20xbf16>
    %14 = stablehlo.constant dense<2.000000e+00> : tensor<bf16>
    %15 = stablehlo.broadcast_in_dim %14, dims = [] : (tensor<bf16>) -> tensor<20x20xbf16>
    %16 = stablehlo.multiply %15, %13 : tensor<20x20xbf16>
    %17 = stablehlo.constant dense<3.140630e+00> : tensor<bf16>
    %18 = stablehlo.broadcast_in_dim %17, dims = [] : (tensor<bf16>) -> tensor<20x20xbf16>
    %19 = stablehlo.select %4, %16, %18 : tensor<20x20xi1>, tensor<20x20xbf16>
    %20 = stablehlo.custom_call @check.eq(%19, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %20 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x2940C83EE83F7B3F24C097BD92409B3FA5C0E3C063BF8F3EF6BF953FA1BFA5C00D4062C087C087402940E7BFAFC06BC017C0B73E5CC0FD404140FABF9FC01BC0A5BE84C07FBED8BEEDBED43D61BF6E4004BF2E3E6CC05BC022BF2340573F69C01B404CC08A3F9F3F6740ABBFC640ABBF90BE94BEB3BF1FC010405E4096C0C0BE3C40013F40C04240AEBE6BBF0FC03B3F103EB2C057C0503F8CBFA83FD8BFA8BEB63EC63F383F72BD9C405C3F43C01DBF8A409F3F48C0ED3E144080C0BD3ECCBF823F2E40113E3ABFFDBFA8C044C045C051BF8E4096C089C007C0C3C069408840B83F8FC0B7BF50C00DC04A405AC00240EBC0D6BE1AC0EFBF03C0B33F2440243D43BE3E3FE23F26C03A407B40073E5E3C9240C0BF883F2CC0E03F7ABF8FBFD5400B417B40383F37402AC022402B3F683F873F4E3F2FC0B0BF87C0B3C0CA3E563E8F3F223FEF3F273F353F6B3BD8BE0EBFF73F15C0DB3FD2409740A3BFAB3F01C066BF8AC05F3FE5BFC3C0BE3E13BF45C06D40023FA3C0CA3F714053404C3F06C06FC08D400FBF06C0793FB0405840BCBF3C4047408BBF57C08A3E1E40DA40C5BFABC0804064C00FC01F3FA8BEB040E1BF8CBECE3F14402240264024BF994038C0F3BF9B40A3BE23C0F33E763F26407F3E893FF73FC940FE3FA5C06A3FD63D513F4B40CD3F8CC00F3FB43EA03F3B404BC0EE408AC0AAC0A0BF033F2B40BCBF26C081C0CBBF42C083BE063C363F6E3F76C067C09FC099C0A1BF47C0CABE4540F43E6BBF4FBF6D3DF8BF18C0223FC23F0CC039C0583FA1BF80BFD8BEE2BF0FC05540484080BE92BF18C07C40C83E083E2F400741D7BF963F81C0C43F5BC015C0633F98C037C029C062BF3D402140C6BE44401B400540EE3FAD40B63F43408E4063C0133F42C0CBBEA640714092C085BF01C0D6BF293E853FABBEDC4085404C400140C4BF53C08B402EC0ACBF86C0233E304010C082C055C03A4073406A409EC03D3EC13DCC4022C041C09DBFB83D0F3F6B3FFDBF00BF24C0453F333FB440BABF5DC0B0BEBD3FC73F9BBF81BFA7BF88C00CC057BF55C049C012C0F0BE69408AC0B63F4340A1C075C02E3D9E40C53F64C037C07640A1403B3E0040B9401F408040D8BF"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0xC0FF963FC0FF4B3EC0FFD23FC0FFC0FFC0FFC0FF2A40A53FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF9A3FC0FFC0FFC0FFC0FFC0FFC0FFF33FC0FFE93F00400340BC3F2940C0FF0740B33FC0FFC0FF1140C0FF133FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFEE3FEF3FC0FFC0FFC0FFC0FFC0FFFA3FC0FF863FC0FFC0FFF63F2F40C0FF403FB73FC0FFC0FF1F3FC0FFC0FFC0FFF43F9A3FC0FF453FD03FC0FF0A3FC0FF0F40C0FFC0FFC0FF8C3FC0FFC0FF993FC0FFC0FFC0FFB73F1940C0FFC0FFC0FFC0FF2240C0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF0040C0FFC0FFC0FFC0FFC0FFC43FE23F3C3FC0FFC0FFC0FFC0FFB83FC73FC0FFC0FFC0FFC0FFC0FF3B40C0FFC0FFC0FFC0FF453FC0FFC0FFC0FF573FE03EC0FF233FC0FFC0FFC0FFC0FF953FAE3FC0FF633FC0FF5C3F493FC93F00400A40C0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF2C40C0FF033FC0FFC0FF983F0C40C0FFC0FF853FC0FFC0FFC0FFC0FF253FC0FFC0FFC0FF0A40C0FF723EC0FFC0FFC0FFC0FFC0FFC0FFC0FFA63FC0FFC0FFC0FFC0FFC0FFC0FFC0FF653FF43FC0FFC0FFEC3FC0FFC0FFC0FFC0FF1140C0FFC0FFC0FFC0FFF33FC0FF893F913EC0FFA93FC0FFC0FFC0FFC0FFC0FFD53EBC3F1E3FC0FFC0FFC0FF7A3F9B3FC0FFC0FFC0FFC0FFC0FFC0FFC0FF843FC0FFC0FFC0FFC0FFC0FFC0FFEA3FC83F483FC23EC0FFC0FFC0FFC0FFC0FFC0FFFD3FC0FF893F2F402140C23FC0FFC0FF633FC0FFC0FFC0FF123FC0FF49400040C0FFC0FFC0FFC0FFE93FC0FFC0FFC0FF963FB83FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFF63EC0FFC0FFC0FF2A40C0FFC0FFFC3FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FF753FC0FFFE3FC0FFC0FFC0FFC0FFC0FFC0FFB43FC0FFF53FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFB53FC0FFC0FFC0FFC0FFC0FFC0FFC0FFC0FFB13FBD3FC0FFC0FFC0FFC0FFBD3F7A3FCF3EC0FF0640C0FF313F4B3FC0FFC0FFC0FFF63FC0FFC0FFC0FFC0FFC0FFC0FFC0FF2440C0FFC0FFC0FF0440C0FFC0FFC0FFC0FFC0FFC0FFC43FC0FFC0FFC0FFC0FFC0FFC0FFB23FC0FFC0FFC0FFC0FFC0FF"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
