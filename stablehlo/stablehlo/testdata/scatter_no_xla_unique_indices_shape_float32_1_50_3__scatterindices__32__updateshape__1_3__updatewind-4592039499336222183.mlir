// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<32> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x50x3xf32>, tensor<1x3xf32>)
    %2 = call @expected() : () -> tensor<1x50x3xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      stablehlo.return %arg1 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x50x3xf32>, tensor<1xi32>, tensor<1x3xf32>) -> tensor<1x50x3xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x50x3xf32>, tensor<1x50x3xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x50x3xf32>, tensor<1x3xf32>) {
    %0 = stablehlo.constant dense<"0x07D590C01BB634C018DF02C05906A13F713638BFCB64D5C03FA732C086BAACC0B551633FEF7BAEC02B6D6BC0B839DD3E4D8348C079A49FBFC041183F0825A6C0D0FE9ABF1CA4573FF4E19540B54F05BF44092BBF3A4E79406B8282BD24386840F5E682C0740CD63F7F234DC0B1E4CB3E3DE9A6BEC08B32402455363E31B568404F118CC0AADFE2BF4154BF3FF5EEAB402AE29A3E0B5587405FAFE83FD0F3D4BFC63DF6BF275C4B3F3B069DBFD37D4540E81A1640CFDF2540C8D7A73E56B9BA407104CCBFA4C118C0EFF4803FA0D4544065FA15C1BE4E4240992400C0AB8B41C0DFE0A3C022302F40AC7D254035F36440BF3EB4C08E420CBF6DC63BC0230D31C0F05A58C0938A49C08C574840C89438BF3CC581BFF4E1E3BE0D2E87C01F7872BF576B8ABF51C91BC0B65FC9BF732A89C05D9458403C9B5B40C0FC4940613894C0B8F23AC0F1E7C5C0100ED3BF69CD9D3F7568AA3F28786440B6F3E5BF9047783D3D808840CFCF17BEF8A73BC0176E68C067C60B40B769894008573DBF815C954065D919C06B8F0A3EB1FA023FD36D8E3FD0BED540AB00D93FA466033F44F6333F960921C0DFAD82C03DBCBABD9F1B90C08457ACBF1346DB3F77017040C7C5604003B357C007B20D40EFA281C03A92A1C076D05A4013DC4A3E23F32DC0689B354015D60140F3BD0CC0FC012BBEB9795BC0F29D6E4062F52540D39F8140847F16404CCF843F1C179DC057CB763F78827CC08F0AC4BF9B92FC3F4966B43FC53C533FC4C7A2BFF1371A40CC123ABD5EEC92BF0D4951402D6EE8406F3B25BE8077603F29078FC0C80088C0B179384065321DC048A699C081589040"> : tensor<1x50x3xf32>
    %1 = stablehlo.constant dense<[[-0.358316064, 3.7893486, -0.990965366]]> : tensor<1x3xf32>
    return %0, %1 : tensor<1x50x3xf32>, tensor<1x3xf32>
  }
  func.func private @expected() -> tensor<1x50x3xf32> {
    %0 = stablehlo.constant dense<"0x07D590C01BB634C018DF02C05906A13F713638BFCB64D5C03FA732C086BAACC0B551633FEF7BAEC02B6D6BC0B839DD3E4D8348C079A49FBFC041183F0825A6C0D0FE9ABF1CA4573FF4E19540B54F05BF44092BBF3A4E79406B8282BD24386840F5E682C0740CD63F7F234DC0B1E4CB3E3DE9A6BEC08B32402455363E31B568404F118CC0AADFE2BF4154BF3FF5EEAB402AE29A3E0B5587405FAFE83FD0F3D4BFC63DF6BF275C4B3F3B069DBFD37D4540E81A1640CFDF2540C8D7A73E56B9BA407104CCBFA4C118C0EFF4803FA0D4544065FA15C1BE4E4240992400C0AB8B41C0DFE0A3C022302F40AC7D254035F36440BF3EB4C08E420CBF6DC63BC0230D31C0F05A58C0938A49C08C574840C89438BF3CC581BFF4E1E3BE0D2E87C01F7872BF576B8ABF51C91BC0B65FC9BF732A89C05D9458403C9B5B40C0FC4940613894C0B8F23AC0F1E7C5C0100ED3BF69CD9D3F7568AA3F28786440B6F3E5BF9047783D3D808840CFCF17BEF8A73BC0176E68C067C60B40B769894008573DBF815C95403475B7BEB0847240E8AF7DBFD36D8E3FD0BED540AB00D93FA466033F44F6333F960921C0DFAD82C03DBCBABD9F1B90C08457ACBF1346DB3F77017040C7C5604003B357C007B20D40EFA281C03A92A1C076D05A4013DC4A3E23F32DC0689B354015D60140F3BD0CC0FC012BBEB9795BC0F29D6E4062F52540D39F8140847F16404CCF843F1C179DC057CB763F78827CC08F0AC4BF9B92FC3F4966B43FC53C533FC4C7A2BFF1371A40CC123ABD5EEC92BF0D4951402D6EE8406F3B25BE8077603F29078FC0C80088C0B179384065321DC048A699C081589040"> : tensor<1x50x3xf32>
    return %0 : tensor<1x50x3xf32>
  }
}

