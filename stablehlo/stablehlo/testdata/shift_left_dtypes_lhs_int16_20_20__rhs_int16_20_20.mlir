// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi16>, tensor<20x20xi16>)
    %1 = call @expected() : () -> tensor<20x20xi16>
    %2 = stablehlo.shift_left %0#0, %0#1 : tensor<20x20xi16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi16>, tensor<20x20xi16>) {
    %0 = stablehlo.constant dense<"0xFBFFFBFF00000600FDFF060001000500F9FF01000200FDFFFCFF04000300010000000000FFFF0300FFFF02000300000000000100FEFF0100FFFF000002000000FCFF0200000000000500030000000400FEFF01000000FEFF0000000002000000000000000100FDFF0000040000000400010004000000F9FFFFFFFFFFFDFF00000000FFFFFBFFFEFF020001000100FFFFFCFF0100FDFF0100FDFF00000000000003000100FFFFFBFF0100FFFF0200FEFF030000000000FEFF0200000003000000040001000100000002000500FEFF05000200FFFF0000FDFF04000100010000000100FEFFFCFF030001000400FFFFFEFFF9FF020000000200FEFFFFFF0000FEFF000000000300FFFF00000400FDFF0300020003000100FDFF0100010005000000FFFF000000000100FDFF00000200FFFFFFFF0500FFFF03000100010000000200020002000000FDFF0200FFFF02000300FEFF0000FFFF0100FEFF010002000100FDFFFEFFFDFF04000100040003000000FDFFFDFF0300FFFF000000000100FCFF0100030001000000FEFF000003000200FDFF060000000100FFFF0000FDFF00000300FDFFFDFF00000000FFFF0000FEFF00000100070003000100FEFFFFFF01000200FCFF000000000000FCFFFAFFFEFFFFFF0300FFFF00000800000001000000FEFF030001000000FCFF00000000FDFF040002000500FFFF040000000600FFFF0000FCFF0400FFFF00000200FEFF0300FEFF000001000200FFFF0200FFFFFEFF00000200FCFF0300FDFF020000000100FEFF05000200FEFFFFFF0300FFFFFFFFFEFF00000200060001000000FFFF0000FFFF05000000FAFF02000000000001000A00FFFF00000200FDFF0000FEFF020003000000FDFFFDFF0300FBFFF9FF0500000000000200FDFF000005000200FFFF050002000000FEFF0100FDFF0000FFFF0000FCFF0000FEFF0300FEFF07000500040000000000FFFF00000300F9FF0300FBFFFAFFFFFF01000500FFFF01000500FFFFFAFF0000F9FF000000000000FFFFFEFFFEFFFFFF00000000FFFF0000FBFF0200FDFFFFFF01000300FFFFFCFF02000200FFFFFCFFFEFF03000000FEFF0000FFFFFDFFFEFFFEFF0000020000000400"> : tensor<20x20xi16>
    %1 = stablehlo.constant dense<"0x0000020000000200010000000300FFFF01000300FEFF01000200FEFFFBFFFFFF0200FDFF0300FEFF0100FDFF010009000300030000000000FFFFFBFFFFFF020003000100FFFF0300040000000300FDFF0000FBFFFFFF000001000000F9FF0200FFFF0100FCFF0000000000000000000000000200030003000200FEFF0400000005000100FFFF0100FFFF0000000003000000FEFF0000040000000000FFFFFBFFFBFFFEFF020001000400000000000000FEFFFEFFFBFF0200010004000300040000000200FEFF02000700FFFFFFFFFAFF02000400FFFFFFFF0400020003000700FDFFFDFF01000400FEFFFEFF0100FBFF0000030000000300F9FF000001000100030000000100FFFF0200FAFF02000100FFFFFFFFFFFFFFFF010000000600FFFF000002000000FDFF02000100FEFF0300FFFFFCFF0000FFFFFEFFFAFFFFFF02000000010000000000020000000500FDFF0200FEFF0100000000000000FDFF03000000FFFF00000000030000000200FDFF02000300FEFFFEFFFFFF03000100FDFFFAFF0000010003000300FEFFFEFFFFFF0300FDFFFDFFFEFFFBFF0000FDFFFFFF01000200FFFF01000000FEFF0200020000000400FEFF060000000200FDFF0300FDFFFCFF000002000300FAFFFFFFFFFF0000FFFF02000000000004000200FCFF0000FCFF03000400FDFFFEFF020000000100FCFF020000000100020000000300FFFF0600FFFFFFFFFEFFFCFF0200FFFFFFFF000000000000010002000400FEFFFDFFFDFF010002000000000005000300FFFF0000010001000100FFFF01000000FDFFFFFF00000000010008000100FAFFFEFF00000100FFFF00000000FDFFFEFFF8FFFFFF0000FFFFFEFF05000100FCFFFFFFFFFF0300010000000000FFFFFEFFFDFF05000000FCFF0100FEFF0300000000000300FCFFFDFF0000030004000000010000000000FEFFFFFF0000FAFFFFFF0000FFFFFCFF0300F7FF03000100FDFF0000FEFF03000200020003000000FDFF010000000200040000000000FFFFFCFF01000100FFFF0500FEFF0000FEFFF8FFFCFF02000000000006000000FEFF0200FBFFFEFFFEFF00000200FFFF000001000100FCFF030000000100000000000700"> : tensor<20x20xi16>
    return %0, %1 : tensor<20x20xi16>, tensor<20x20xi16>
  }
  func.func private @expected() -> tensor<20x20xi16> {
    %0 = stablehlo.constant dense<"0xFBFFECFF00001800FAFF060008000000F2FF08000000FAFFF0FF00000000000000000000F8FF0000FEFF00000600000000000800FEFF01000000000000000000E0FF0400000000005000030000000000FEFF00000000FEFF0000000000000000000000000000FDFF0000040000000400010010000000C8FFFCFF0000D0FF00000000FEFF0000FCFF000001000100F8FFFCFF0000FDFF1000FDFF00000000000000000000FCFFF6FF1000FFFF0200FEFF000000000000F8FF0400000018000000040004000000000000010000000000000800F0FF00000000400004000800000000000000F8FF300000000000FEFF0000F9FF1000000010000000FFFF0000FCFF000000000600000000000000F4FF060000000000000000000200010040010000FFFF000000000000F4FF00000000F8FF00000000FFFF00000000000000000800020004000000FDFF0800FFFF40000000F8FF0000FEFF0100FEFF010000000800FDFF0000FDFF0400080004000C000000F4FFE8FF0000000000000000020000000000030002000000F0FF000000000000E8FF00000000000000000000000000000600F4FF00000000000000000000F8FF000010000000C0000100F8FF0000080000000000000000000000000000000000FFFF0000FCFF00000800000004000000FEFF000008000000000000000000FDFF080000001400FFFF080000000600F8FF000000FF0000000000000000F8FF00000000000001000200FEFF0800F0FF000000000000F8FF0C00FDFF020000000800000005000400FCFFFEFF0000FEFFFFFF000000000200060002000000FEFF000000000500000000000200000000000000000000000000000000000000FCFF000000000000E8FFFAFF0300FBFF000000000000000002000000000000001000FFFF05001000000000000100E8FF0000FFFF0000FCFF000000000000FEFF00000000040000000000F8FF00001800F2FF0000FBFF0000F8FF04001400F8FF01000000FEFFFAFF000090FF0000000000000000FCFFFCFF000000000000FFFF000000000000F4FFFFFF0100C000FFFF00000800000000000000FEFF0C000000FEFF0000FEFF0000F0FFFEFF0000020000000002"> : tensor<20x20xi16>
    return %0 : tensor<20x20xi16>
  }
}
