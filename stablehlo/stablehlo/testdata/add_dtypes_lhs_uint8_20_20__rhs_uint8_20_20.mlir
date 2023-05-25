// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xui8>, tensor<20x20xui8>)
    %1 = call @expected() : () -> tensor<20x20xui8>
    %2 = stablehlo.add %0#0, %0#1 : tensor<20x20xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui8>, tensor<20x20xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xui8>, tensor<20x20xui8>) {
    %0 = stablehlo.constant dense<"0x0107040301020301000006010002000202000202010103050205000302000100020107020000020000000803010101020500060100030000000101010000010305000001000307010100030504010201040900000403030100010202040404010300020500050201060000000003070103020102020504030203000400000102000100020101020200010203000003010002030000010102000101000208000102040102010202020201030004060302030102000302050106000002040400010103010003010601030305020200000104020301020604010002030200020403030A030002020106050001020003010002030802060301030102010100010005000103000301000705000104010101020203030302010104030402010103010202040103030601000405020304010206000101030401020201030000040601030602020201000003000301040302000000010107000100010101010201000000020201060400020104020504000300000102090003000400020001020102010003040302040201000000020300020100"> : tensor<20x20xui8>
    %1 = stablehlo.constant dense<"0x0403020202030001020304020106010002020401010408000201010501040400010002000006020300040201020000000204050501000302020300000400050101000500020401040100010200000002000506020500010401010007000003000202020005000105010200050002020003030202000002050102050302010A020301030202010300010201040001000304020603020000000304050402030204040001030103020201030202010802000305070102040001050103010200020007000004000201030102000000050004000002000201010704010108010000030000010200000102020100000001010304000300010603020006020203040100010004010500000203010100020103020100040102000100010100010102020106020901010201000201010001020101020201000101070306000000010306000404010201000101000001010503020103010503000204010100000003020000070304030302020301000404000203020200000402030400000204000001040101020102010303010601050001000301"> : tensor<20x20xui8>
    return %0, %1 : tensor<20x20xui8>, tensor<20x20xui8>
  }
  func.func private @expected() -> tensor<20x20xui8> {
    %0 = stablehlo.constant dense<"0x050A06050305030202030A03010801020402060302050B050406010803040500030109020006040300040A040301010207040B0601030302020401010400060406000501020708050200040704010203040E06020903040501020209040407010502040505050306070200050005090106050304020506080305050702010B0403020304030205020103030700010304040409030201010203050604040B0205060402050205040403040502050E050206060901050605020B010303060402010803010403030704040505020205000504020501040705080403040A01020406030A040202020208070101020004020306030B02070904050108030303050105010107010801000908010204030204040303070404010204040502020205030308060A04040802000606030305030307020302030502090507030000050907030A0603040200010400030205080502010302060A000304020201010204020000090505090702040405020908000503020302090405030800020205020103050104060404050504010601070301020401"> : tensor<20x20xui8>
    return %0 : tensor<20x20xui8>
  }
}
