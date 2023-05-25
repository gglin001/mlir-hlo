// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.sine %0 : tensor<20x20xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x53AA47B91D3A9944B0B930BD4540EAC0C2BE5AB896409F383B400B43CA425E439BC183B913B6843F6641B145543D5E3D00C1C9C3663C594068B962AF0CC1CC4303C52BC22FC26539F5BC9D404BC4B5BF86B9333C6C4637C16B453C3D443B87C4D3BAFA41663EE5409A40EEC1EBC0C8C0F94034BD4D460937C3439EC42C444241D7C08837DAAA1FC03240E8348A39E3B9883FE9C3BAC612C51FB8C934173833BE2CC34CC465C153C153BB6D3B5A47903CCDBBFF41DC402EBECD39CD3CACC265C47D34DCBF273FC3B82A35BC42F540213F1CB40033BE3986C0F542CC457FBC8BC40EBFD943B8457FBC1BBE9EC1A5372C402CC67FC4EEC32E3B1C3E20361ABEBB3957AC1FA75D425AB39B3B94440EAD363A5B2FC3C32F394E40403E9AB8A4C197364C48EF362EC2C2B86640DB427FC2C343AA41C94109BBA1C11A3E10406BC019407A413E41353E533C38BEB4C67AC13FAE00BD2CC09731193F0E3F81C1BAC03CBAE4B61BBFF1A2CC299DC4F4C1B23F1336FBAE82C2614001C25946704339448DC0A6420CC2A63853C688C48EC195415FB5D736F0456FB68C3D52401B45114051C0CC2C3C4085C1F5B8394901C5FF413940703C5FC468BD0CC7CABE3FC14BC3863D0ABD12C6ED44924116C1E0C020A62DC54C4152B01AC148C4E6C28D3B1BBE00C8EA4433BD95BF6736AAC6D8C2F03DEF432DB3FFC21545903CD02CAA3B21C079C53BC53C4431C60EC132B5F9C02AC4FDC56A42E4C36FC0F13E4037794445BA52BA8F407D4141BC08C48EC1CD39634039B8ACBB22C67C3E233FAFC52FB03B25383A5F4438C45943B6336A413FB57DC40E2DC03E7FBA4E41CFB43CB50F45A443FEC43D4262C65D4131C07B365D4196C43239F23DB6B3E94024400AC160B4A13EC641D4B5C8BF7AC4CC444C39D9C12136353E3B408242E2C30A3D91C343C54848EB3CAB3B2231B9BF5CC473432D400EBFE03E51430D46E7387EC0CE4069401B4807443646253FE83BFD453B3CC0C106B5DE3E73435D42AB3D56B154B8843D1BC42D3E024163350B3A45A5CCC32CC2713DE8C665BD143CDCBA9BBA773839BAB3BC4DC31D3F4E4275C13CBD7D4372C4DD422E3E142EB13F4D31E3311D4217C7EFB5CC3F"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x52AAE7B88939F3BB38B9B4BBC33A0FB9F2BB24B8013A5E38D83AEFB501B420B852B516B9EEB5A03BD93676B8C63BCB3BCAB87539213B973A01B95EAFA3B87EB9A53B5FAB5FAAFF3890BBEE394E3B80BB18B9F03A6D3013B817BABA3B4F3ADD3B07BAE330FF3B1E39F639A0B10CB975B9E038B6BB8124D03664B9F73BDCBAD93749B94237D9AA0FBBEA3AD4341B395FB99D3BD039DDB67E3BE2B7B734D43700BCE136523BE1B662B758BA683A033B453B9FBA94303A39FFBB4E39753B2E32993B6E3463BBD03B7CB8133528B3ED38D23B10B4F23243392ABA4AB57AB737BBE33BDABBA4B948B837BBFEBB3BB55B37F63A1C2FD03BDE39413AFE3BFA35FEBB413956AC1FA720A949B3833AEEBB0DAD9B39572F6439D438AF3A003C5AB80DB56836E939B8369FAA7BB8793A84B4CD2E64B9E034E3332ABA24B5FE3B2B3B6DBA1A3B4836F537003C0F3B00BC86B648B63CAE98BBF6BA9031D63BDA3B14B69EB99FB9AEB6D5BBF1A2CB29F63B42B1823BEE35F7AE2C2F843A74B0202C5DB80FBB18BAD0B18BAF643840A9DE3BB3B57F3545B5A2366CB543B6DD3BA63A64BB293BA9BACB2CD63AF6B5A5B8D2BAAA3B9430DC3A2A3B8A3BCFBB88B9F0BBEEB7BD37DB3B9EBBC332D2BB953582B82EB920A6283B93374FB075B8453BD8347B3AFEBBEABBD6BBB5BB95BB3C36F3B56D34F83BE1B91EB3953576BB453BCF2C8B3A0BBBCC39F33A1ABBDE2D9CB81BB5E0B8D43AA6342FACC23963BAE43B0137C5BBA6B9AFB9133A3136FEBA373AB3B54E39803A07B88DBACB30FD3BD23B84382CB03B259C398ABB0B3B0FB8A333BC3627B5CD3B0D2DF23BCEB98537BDB424B586BB06B9B03BBF255EAE1A37ECBA4E361A37F03BD638F93BA3B31239063BA9B852B4F83B0934B3B572BBC73BF9BBEB38EAB2FB35003CD83A2CAFBD399E3BCA38D33A133A8A3B8C3A1C317DBB823B68B8F43ADABBEA3BE7B75FB39A383FBA6439723A7F3B32BA9FACD13BAE3AA6B4F83A37B4F1B4EA3B68B820A9E83B50B11FB8DA3B923AFF3BC33849357C3945A57E391FABD33BABB8CEBBD13A0DBAE1B93D389DB962BBCB37D43B81A16CB6BABB89B8B73B93B4FF3B122E823B4731DB316E2DC7B9CCB56F3B"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
