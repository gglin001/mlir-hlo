// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xui8>, tensor<20x20xui8>)
    %1 = call @expected() : () -> tensor<20x20xui8>
    %2 = stablehlo.shift_right_arithmetic %0#0, %0#1 : tensor<20x20xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui8>, tensor<20x20xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xui8>, tensor<20x20xui8>) {
    %0 = stablehlo.constant dense<"0x00010104010001020001030001000603030104010200010003020102050206000402040100020302020304010105020004020305000000010100030201000201020100000100010402010501020103050301010403000403030002020102030007010204000507000103060101010000030407000303010100050706020102010003000202000000030004000001000002000400000102040300000000000000030401020103000108040302030601010201020101010100040001060303010101000101000501000203020300020407020000040007030100030500060601030201010203040004000003050000050004040206010400020701000500040401000104040103000100030201030002050400010503010400000100020406000203000100020203010303000002010100000501020005050006000000070300030401010202000204050307010300050501060601070001050600050101020702000102020105000002010101000002030402000001010001010201030200030606010004050304000102020007010201"> : tensor<20x20xui8>
    %1 = stablehlo.constant dense<"0x01020300030601060104000101010500050202010001000602000200000300000402040700000802050401020305010002030101010400000000020404010000020000020000010300000401010101010201040302020000030000000005030202020000020102020102000202040002020201060300020501010103020100010304000100000500050002020004000401000703000000020104010701030102030303000403040104000101030402030501040300000000000102030300010400040000000202010007050004010505040B05030401040301000302040202010600010301010204010207010100010300000500010402000200020002030201010101000003040001030101030401010402010301030301010301000102030103050502040402000002020306030102040103000100010001040200040001010403010300000400000102010104010405040600040001000201030100010301010101040200030001030200080105020201010501000404010301000305030204000102030305000301000203000102"> : tensor<20x20xui8>
    return %0, %1 : tensor<20x20xui8>, tensor<20x20xui8>
  }
  func.func private @expected() -> tensor<20x20xui8> {
    %0 = stablehlo.constant dense<"0x00000004000000000000030000000003000001000200010000020002050006000000000000020000000002000000010001000102000000010100000000000201000100000100000002010000010001020000000000000403000002020100000001000204000201000000060000000000000103000003000000020300000002000000000102000000000001000000000001000000000102010100000000000000000000020000000000040101000000000000000001010100040000000003000001000101000100000200000300010000000000000003000000030000000100010001000001020000000000020000020004040006000000020101000500000100000002040100000100000100000001020000000001000000000000020201000100000000000000010300000000000000000200020005020003000000000300010000000002000004050101000100020000000001000000050100000001010001000001000005000001000001000000000101000000010000000000030000000100010001000000000001020000010100"> : tensor<20x20xui8>
    return %0 : tensor<20x20xui8>
  }
}
