// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xf32>, tensor<20x20xf32>)
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.bitcast_convert %0#0 : (tensor<20x20xf32>) -> tensor<20x20xi32>
    %3 = stablehlo.bitcast_convert %0#1 : (tensor<20x20xf32>) -> tensor<20x20xi32>
    %4 = stablehlo.compare  NE, %0#0, %0#0 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %5 = stablehlo.compare  NE, %0#1, %0#1 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %6 = stablehlo.or %4, %5 : tensor<20x20xi1>
    %7 = stablehlo.constant dense<0x7FC00000> : tensor<20x20xf32>
    %8 = stablehlo.bitcast_convert %7 : (tensor<20x20xf32>) -> tensor<20x20xi32>
    %9 = stablehlo.constant dense<-2147483648> : tensor<20x20xi32>
    %10 = stablehlo.constant dense<2147483647> : tensor<20x20xi32>
    %11 = stablehlo.and %2, %10 : tensor<20x20xi32>
    %12 = stablehlo.and %3, %10 : tensor<20x20xi32>
    %13 = stablehlo.compare  EQ, %0#0, %0#1 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %14 = stablehlo.constant dense<0> : tensor<20x20xi32>
    %15 = stablehlo.compare  EQ, %11, %14 : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<20x20xi1>
    %16 = stablehlo.compare  EQ, %12, %14 : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<20x20xi1>
    %17 = stablehlo.and %2, %9 : tensor<20x20xi32>
    %18 = stablehlo.and %3, %9 : tensor<20x20xi32>
    %19 = stablehlo.constant dense<1> : tensor<20x20xi32>
    %20 = stablehlo.or %18, %19 : tensor<20x20xi32>
    %21 = stablehlo.compare  NE, %17, %18 : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<20x20xi1>
    %22 = stablehlo.compare  GT, %11, %12 : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<20x20xi1>
    %23 = stablehlo.or %22, %21 : tensor<20x20xi1>
    %24 = stablehlo.constant dense<-1> : tensor<20x20xi32>
    %25 = stablehlo.select %23, %24, %19 : tensor<20x20xi1>, tensor<20x20xi32>
    %26 = stablehlo.add %2, %25 : tensor<20x20xi32>
    %27 = stablehlo.select %16, %3, %20 : tensor<20x20xi1>, tensor<20x20xi32>
    %28 = stablehlo.select %15, %27, %26 : tensor<20x20xi1>, tensor<20x20xi32>
    %29 = stablehlo.select %13, %3, %28 : tensor<20x20xi1>, tensor<20x20xi32>
    %30 = stablehlo.select %6, %8, %29 : tensor<20x20xi1>, tensor<20x20xi32>
    %31 = stablehlo.bitcast_convert %30 : (tensor<20x20xi32>) -> tensor<20x20xf32>
    %32 = stablehlo.custom_call @check.eq(%31, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %32 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xf32>, tensor<20x20xf32>) {
    %0 = stablehlo.constant dense<"0xBFF0B4401EEDD5C0E44F2140C497603FC6C889C0D6180AC01501FCBFBD2D72C082BDA8C076047CC03ECB1F4099B1D9BFF0953CBE606E39C0A01141C04DAB4F4016E533406DFC47BFA17585BF48CE023CE00F38C0700D01400BA85CC0D0990FBE100F88407FC4A4BF7CC300C0C31C31C0047D69C0BD9179C0B95D8AC0BD6AA23E6C818B3F9031B73FD7443CC05EB607406F0B70C03D02F1BFACEC0B40A09A5E407859A6BE0F5D61407F558D4019932E4081A80AC0A2C821C0FCF9D9BE9B3AECBF736C13C09C645AC0791CE93FD22E823E6F569CC0FAE134BF22B7C640AC8529BFE535D8BFFC564B4001F5DD3F78D43340D4BC843F21715ABF1D88E8BE4350583F9D593B40485EA7C0D5C2843F00F4ABC013DF1CC08FDDF9BFCE58063EF3380CBE2A8449BFBFB3E93EF64FDF401ADAF63F4E814640D5A6193D34D88340D35C6840F011BAC095F6AC3FAFFF19C000589A4001D635BF48B41D409C21B23F7D8CE23F98D19EBEEA5D0EC0935CD24082955540321789C01E3E8D3F1F77B7405AB36A3FABB2D33FD94221BF7B81233F7779EFBDBDB705C02AE381BFAC0B53C09402C43FF2BC904020554C3FA0B09140E8014BBF2B15B0C0AE9EA23E035F7440676F00402FEF38C0C364EEBF5BA724C0ECC246BEC0C73B40C317033F08CE8DBFFEE2ABBFA096EEBFD2F96A40D5482EC036C594C041EBA2C089566CBEBEC1C13EB33A9ABFD321A2BF47D68640C57162BF457FA14089A742C08516F0BE585D1F4067679A3F127CADBEC9EBD13F4E92EA3E9D68304011D4253E1612943EBA62A03FF3CBA6BF3224DBBE0ECF5C4094D7933EE2628CBF80E567C02EEEE4BE1DA103BF8653993F3A362141C02D3740C3E054BF8659B6C0DCFAD13DF59FFA3E55B299C05020EF403FE8A6C037DB15C0CD8128C0B47A9BBF39543F40125F91C0022123405CA4813FADE165BFD6412AC0EDC89F3E3BABF9BEE72D343E966709C0DCD10ABDCB180340956642C0E273C23E91F774C010EB03C0E976FD3F06DED3BD44F9923E6E53BEC02A0B07407BE69FC0B2EC094047068E3F7B9F5AC0C3DB89C00EAED13F3C7FC6BF31A2243C6B2FCE3FC4EB483DC726AE403C57AA40D89995401D08674046B43A3F26ED0340E10E76BFC8C41F4044B20BC002AD84BF378A3F408385B8BF941C07C1EB93583F58FFD7BFBCF5D13FD90F68C09FC9E5BF5883983CDB1E1DC06CC0B3C08CE6C6BF220DEE401CA80DC057ED81BF2D4F1440129AB6BFFFFBAC3FB7548940044D61C0C10EA5C01335653F41183AC007D705BFD665394060D7C73F8066B53EDE801040AED78C4097C4D43F61A989BE4194B1BF331C62C05F9173BDA52A2840589242C017FB883F7B80883F36380740E23F293F06DF75407C520ABF758094C0855C5D40890588C052AC03BFE46088BF46EF9D3F943B7740C58B97BE79204A3F7F5AAC3F9CD01940B1DC65C0D34A1D406A9E2B40BBE2B53F7A16683F08565C409C8DE83FDA76A7BF847E0140D1FDC83F9DA819BE1499B64068D79140412729BFF97ACB40DDEA9AC083AE973E7B41503E7B6F7FBF17A83FC0EE488F3F205EC8BF938F87C0961886BF6907803F9C8C88BFC3CA7440F335F9BF5469463F7D4DDE3F7ECD513FE5E4753E8EFB0F411E63F1BF2383CBBECE826A3EA62959C0D04D09BF1EA576402C073C406AE09040D03E134004D6C5BEC1B0A73F16F7893F23D5C6402C1EBF3FED09BFBE4EA855C089C489BFFB214AC079D8A73F236BC040F441D23F04ACEB3F28513DC07CAF1BBF60D4D2BDB53417409ABECDBF771D0DBFCAECB4403DDACABF597F8ABFD89E0B4002C4F340E15145BFBC9E80BFEBD49ABFDC0AD4BFA7068540D6930C40254D19BF5A9ABD3F58CAC0BF68D5B7C04BAB31C0F9F4D73FBA87134041C500C09DCB7640D460ADBF5C1D0640BE32D5C0DF90FF3F1A424940D6A2C2BF6C5EFE3EE3ADA7BFEBBFF0BF08E73C40D999E53E6D585540C4C2C5BCFFFF58401D44C240C108A0BF8CE7D4BFBCFADD3FE33A813FE31781BF0143E83FF8A4FF3FE9EF83401A9F10BE50613D403F5518BE3D4F83C033371D40BB2F0C4091F8623E0DEE1F3FC2B8E9BF1A79943F6F2DC93DEF732BC0677D2640F781AA3F5A88B03F2B41CC3FF49437C08509C2C00C6AA93FB5E60540C3D786BFF7B96CC09B59AB3FE64BBF3F2FF8BC3F9B7B98C06ADE1B3E200381C0D893AF3FDB6A8540E0F87EBE78CF05C01B93503F80BA553E1CD7CA3E244B6540304F0E41B5003840"> : tensor<20x20xf32>
    %1 = stablehlo.constant dense<"0x113B1CBF3CD712C033990C40341D5BBF3A3A34C07A99E3BED3A4B4BF6DD578408C668D409928574019205C40B7888EBF457E4FC0FBE227404723BC3FA5EBCABF29CB55C0F6808A3F3301B2BF9D19013FD18206C09259174027342840E2E665C0A4329B40C138BF3EA5D21540C7C523BFE355223F7D7F93C0229BC04053BC5340C0061B3F63454540CC9EFDBFE3994EC0C945DF3E475F15BFF05016BD7F221BC080DB2ABF79CE41BFDB1423BEB1A414BF65357EC0929C8240DA6F874087907AC0F16C3C3FFA769940832FB2BF3ECE31C029A419C0EB69F8BF471B4940B2CD2640CE3689C0AC723F3FAF3970BD520F4CC034050141F0E8D6BF7DA0F23FE30C75C03B5F2940E3890FBF2A5CEEBF667A02409728FC3F23A03F401B5B2ABE2AA4CABFC6403E3F9DC15840A6A6143D2ACA193F94EFC6BF981DD9BEFD9ACC3D9FCEE5BEA608A63F9B5817C0254A8440BFAC613F9AA35CC00AE7D2BCE95D65BF9CFE744082D18040EC199BC0AAB70840024D4340C4922FBEA9001141E6EA25408359923FF15A0740D24553C042B938BEC5356EC02D3933C01EAA6E4016B9A3C06B5F56405C26763D081F52BF5578A9C06DAA06C0E6EA14417A64E13F919D61BFF8BD74C01CF804BF7FB3E73CA04B5C3D463C44BFA0F551C09ED8434055E375BF3B1D973FB328B0405482D4BFD42650404000DB3F7FB4153F9612ABC0F09B91BFD7D8CBC00B6C863EF83DBDBF97AC6540EA0A98BFC7A8C8BEEBCBA4C02534CBC07ADEDB404D690FC08DD40F405EF488408C6A8FC01D48153E25B53C40E747C43E6F79D3BF8CC1B63F5E071CBE372820C033C597BFFFB923C0C1AB28C037903C40D0F7ADC0167CAAC08088E340945E144090CA5440E809203F8EFD5F403A6E5740B3EACD3F71973CC0D0F03DC04FE8A0407D77A4BE2522BA40D3F1914065AE0840321C56BEAEA5CB40EF2D7F40C87E2A40A8FFD3BE19B0F5BF73AE5D3C222774C020BDB7BFC73A3E4004AE3940A57C4ABFF4F07B3F39677DC0A9CA4FC0AE279C40945D4EBF75CF8F4089E6C23F76596E3F731C95C080311DC0DD554CBF5C292041AE85C6BFAC3C6240273C44C0110A86BF5B54E8BDA9E0553F5BBF633E576FFFBF857AB9407F2D6ABFB01A10C0D7C6BC400062E84016E718BE32D4A9BEBAB6464049B0683FC689844003645E402B8FD23FD097FE3E30294D40CCFD7FC029D1FABF0DD7DCBE427718C016DC18C15CF180C0C8FFB9BFDFC64BC045170F3F8C8028408850F83F5468AAC03D81523FACE1B1C0276099BE171A8B3FD33685BF0BDD33C0D97F883FAFCF8A40638DB0BFBF468DC0511C233FD258503F64BD99BE3E9FF6C0A5952BC0662F2EBE0A61D7BE311A1840F67E7EBF318743C0F37D3FC0E84C34C06092C8BE3C56223FD9E08740C7259B3FC056AA40BD503640531EF6BE231BD93FF3605E40B949AF4031AE33406D0D3E40F82806405B685F3F518B1640E06C5740C576A0405AED263E112AFF3E049D9CC002D16D40E4FB0340EF5C62C0FC3FB5402B95593F70AC814075D3C83E9B9505405ACC7B3F6B9EDB3F2F0E36C02C99EBBCC8A3D5C0BDDA9E3E2704D8406990203F61BF493F93C00C40C612F3BFBA369A404E3A77C0D2840BBFF462174068C4F8BD30883640A09EC9BE20942D409905AFC0FC18823C9023AABE8D1844C083C08ABF959BCC3F8E6CEFBF67A841BF7856FDBEC0000FBF659216C0FE500A41FC76C53E72229D3EF44644BEACBF01402681CB40DF50A34017988E402217803EDF63A0BFF43E6CBF345B60C0D044174070424BC016C905BF6041A3C05929393D895616C0BA6601403F38A6BF9F4F5BC0FC99C4BC9E7F32C015D128BF7D2EC4BEA18D48C066DD4DC0DFB22AC0A19156C08F7806BF199B7BC0CD99093F3C649C40765ABE3F08AD7FBE41B962C0D292073E74ABEBBE6BBE204024FB13C073B2873F578B8B3F71219C40E58441402E25BEBF05ACBEC0F77916401B75ABC0A46A34C0137913BE57723FC0508B31C00939F5405195F6BD098D3F3FD0739DBFCFDF3EBE360D5040116418BFFD0AD33FA325C33FD6E730BF743C7FBEAE8EAABF48201EC0611D7FBF47D8C3BF423595409E8D63C068AF11C025B55EC00F399AC0733EE3C0615782406BFA8FC0D13DF2BF0A3958C0AC1EA93F480726C0C6F503C0D5FDB83F588E14C0FECE3740CDD64C40156E6740E712E440E5AF0FC17F57AF3F86B365C0D2A428C0782586BF8BF1803E13B87B3F79F792BF5BBE9D40"> : tensor<20x20xf32>
    return %0, %1 : tensor<20x20xf32>, tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xBEF0B4401DEDD5C0E34F2140C397603FC5C889C0D5180AC01401FCBFBC2D72C081BDA8C075047CC03FCB1F4098B1D9BFF1953CBE5F6E39C09F1141C04CAB4F4015E533406CFC47BFA27585BF49CE023CDF0F38C0710D01400AA85CC0D1990FBE110F88407EC4A4BF7BC300C0C21C31C0037D69C0BE9179C0B85D8AC0BE6AA23E6B818B3F9131B73FD6443CC05DB607406E0B70C03C02F1BFABEC0B409F9A5E407959A6BE0E5D61407E558D4018932E4082A80AC0A1C821C0FBF9D9BE9C3AECBF726C13C09B645AC0781CE93FD12E823E6E569CC0FBE134BF21B7C640AB8529BFE635D8BFFB564B4000F5DD3F77D43340D5BC843F22715ABF1C88E8BE4250583F9C593B40475EA7C0D4C2843FFFF3ABC012DF1CC08EDDF9BFCD58063EF4380CBE298449BFC0B3E93EF54FDF4019DAF63F4D814640D4A6193D33D88340D25C6840EF11BAC094F6AC3FAEFF19C0FF579A4002D635BF47B41D409B21B23F7E8CE23F97D19EBEEB5D0EC0925CD24081955540311789C01F3E8D3F1E77B7405BB36A3FACB2D33FDA4221BF7A81233F7879EFBDBEB705C029E381BFAD0B53C09502C43FF1BC90401F554C3F9FB09140E9014BBF2A15B0C0AF9EA23E025F7440666F00402EEF38C0C264EEBF5AA724C0EDC246BEBFC73B40C417033F07CE8DBFFDE2ABBF9F96EEBFD1F96A40D4482EC035C594C040EBA2C08A566CBEBDC1C13EB43A9ABFD221A2BF46D68640C47162BF447FA14088A742C08616F0BE575D1F4068679A3F137CADBECAEBD13F4F92EA3E9C68304010D4253E1712943EB962A03FF4CBA6BF3124DBBE0DCF5C4093D7933EE3628CBF7FE567C02FEEE4BE1CA103BF8553993F39362141C12D3740C2E054BF8559B6C0DDFAD13DF69FFA3E54B299C04F20EF403EE8A6C038DB15C0CC8128C0B37A9BBF3A543F40115F91C0012123405BA4813FACE165BFD5412AC0EEC89F3E3AABF9BEE62D343E956709C0DDD10ABDCA180340946642C0E373C23E90F774C00FEB03C0E876FD3F07DED3BD45F9923E6D53BEC02B0B07407AE69FC0B1EC094046068E3F7A9F5AC0C2DB89C00FAED13F3D7FC6BF32A2243C6A2FCE3FC3EB483DC626AE403B57AA40D79995401C08674047B43A3F25ED0340E20E76BFC9C41F4043B20BC001AD84BF368A3F408285B8BF931C07C1EC93583F57FFD7BFBDF5D13FD80F68C09EC9E5BF5783983CDA1E1DC06BC0B3C08DE6C6BF210DEE401DA80DC058ED81BF2C4F1440119AB6BF00FCAC3FB6548940054D61C0C00EA5C01235653F40183AC006D705BFD56539405FD7C73F8166B53EDF801040ADD78C4096C4D43F60A989BE4094B1BF321C62C0609173BDA42A2840579242C016FB883F7C80883F35380740E13F293F05DF75407D520ABF748094C0845C5D40880588C051AC03BFE36088BF47EF9D3F933B7740C48B97BE7A204A3F805AAC3F9DD01940B0DC65C0D24A1D40699E2B40BCE2B53F7B16683F09565C409B8DE83FD976A7BF837E0140D2FDC83F9CA819BE1399B64069D79140402729BFF87ACB40DCEA9AC084AE973E7C41503E7A6F7FBF16A83FC0ED488F3F215EC8BF928F87C0951886BF6807803F9B8C88BFC2CA7440F235F9BF5569463F7C4DDE3F7DCD513FE6E4753E8DFB0F411D63F1BF2283CBBECF826A3EA72959C0CF4D09BF1DA576402B073C4069E09040CF3E134005D6C5BEC0B0A73F15F7893F22D5C6402B1EBF3FEC09BFBE4DA855C088C489BFFA214AC07AD8A73F246BC040F541D23F05ACEB3F27513DC07DAF1BBF61D4D2BDB434174099BECDBF781D0DBFC9ECB4403EDACABF587F8ABFD79E0B4001C4F340E25145BFBD9E80BFEAD49ABFDD0AD4BFA6068540D5930C40264D19BF599ABD3F59CAC0BF67D5B7C04AAB31C0F8F4D73FB987134040C500C09CCB7640D360ADBF5B1D0640BD32D5C0DE90FF3F19424940D7A2C2BF6D5EFE3EE2ADA7BFEABFF0BF09E73C40D899E53E6C585540C3C2C5BCFEFF58401C44C240C008A0BF8DE7D4BFBBFADD3FE43A813FE21781BF0043E83FF7A4FF3FE8EF8340199F10BE4F613D403E5518BE3C4F83C032371D40BA2F0C4090F8623E0CEE1F3FC1B8E9BF1979943F702DC93DF0732BC0667D2640F681AA3F5988B03F2A41CC3FF39437C08409C2C00B6AA93FB4E60540C2D786BFF6B96CC09A59AB3FE54BBF3F2EF8BC3F9A7B98C06BDE1B3E1F0381C0D993AF3FDA6A8540DFF87EBE79CF05C01A93503F7FBA553E1BD7CA3E234B65402F4F0E41B6003840"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}

