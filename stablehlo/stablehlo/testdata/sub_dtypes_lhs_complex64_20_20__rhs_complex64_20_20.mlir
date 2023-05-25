// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.subtract %0#0, %0#1 : tensor<20x20xcomplex<f32>>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) {
    %0 = stablehlo.constant dense<"0xD885BD3FAB1CBCC021ECC5BF4AC9E2BF9C9DB7C0E1EB0741FF6A35C1E00133406CD2683F64E9B440A166EBBD23B1A93E2BD34C409391E5BEDD4820BF3442923FE1C602C056D9F93FA38A7340D74339403275B6BF28ECD13FEB35C53FA0C9C23E41F49DBE147469406C6B5BC077EE3BC05EE63BBFEDDAB640EF77A540D24576401A7CFDBEF7A20D407C78BF3F59FE9F3FFD9818C09B86AB3E5DB81B3F59080040F00AC8BF46A54F40198F3DC0E4363EBF7D7403C02AB365C00A02463F8014A84069627440FF28E03F8FC1013F2F016F3E2947AA3FAEDB6F404D42A8BF99115C3DCCF7C5BF106B0FC0FDB4DDBD312201C0062101C0E277C6BE68B89DC09E9AD9BF9D2D47C0C86B99C0B4E56ABE4D9BA8BE16D750C0331003C0474C4940B711F03F53B481C00A1EBD40BFFB1140CBE99B40CCF87EC01F079EBE2FE62CC0AE9E96BE5471D73FB1F143C0A61C983FB07864C0F9A6D1BE1ED8D7BF5FFC593FDBA9A4BEB08197BF96D9DC3E3055DB3F760C58C0230EE63F5A748D3FEBB3D4C0F19ED0BF79DDB33F357827406DF1423FCC3825BE23F82B4050A262C089CF41BF28460141E9ED01417D17683F0EE5A2401B56C23F8C840840B70E9AC07FEA9DC034CA13C045B38740A404D33FC293343FE0BF664063C582C0A7F48E3F842CD83FF17BA83F56F319C0478033BFB742983DE977D140943D9E3FFC0B2DC07B182FC068761AC09CAC4CC08E1614BFF7BD3C400B648F3FF9142BBF0CA379C0F8E0A0BFBDED244010411640705A4F3DE5C34AC07C582F3FED981C3DD2059BC010A59FC0DE43BFBFC81F99C0B5DBB6BFA75EAB3EEC0735C0ACC8BB3F0FCF24BECA2F5940158EE1BF9310BABFEA113840AAEA39C07D3F8240CEC254BFADFCCB403F6AC43F1317F53F61FFB53E9039233FEBFCE03F1A86B5BF3E3872400C5B01C0F2B5FB3F5A3C7B40D0D9BEBECC8651400EA2AB3FF8EBC43FFC01D6C08A68583EF4BC283F0B7C8F3EA21A093F36C2A6C0B9D2813F36D0B9BEA62EB5C0A23716C05582AB3EC2E7664045728EBEB45511BF2D5E7CBFB9A4EC3F97F86AC05DA63C40683D2F3F30F3973F2636FA3F8AFD9CC0BBB7D1C09613E03FC4DD3CBF4CD358BF632F9BC0B0F0314096ADA8404B554EBE19064ABF847911BEA726E33FB7639C3FDEA133C0EF3851C047030D40FAED94C09F0E99BE6A735D40F1F28CC07B91A43F766A423E9B59C4BF17BDE43D992411C0E4D81940A9E180C02A09F63EDFDE8EBDD6560BC0069E963FD9B4A53FD9D8163F932C903FAD189FBF8B356AC0CF6F77407F964BC051B7203F296CB340151CC83EB4F0A03EE0DA623F669B623F1A374C3D9A0773BF8ACD0BC091D76EC09CE4A3C0FF9295BF7D08903F2B1CAF40095279BE088E253F6D33EABEC69009C02E5335C09B5282C04FDDF13FB55B0740BCBB77BFAB7B30C068209B3FFA996AC08075973F2AB7553FAC0223BEF1141640A2D0A840C27167405AFEBB3EC237B840682BE23F721BB23F9B0D5640F2345940F27CF33F02FBB1BFAE984EC0D79F24C0F9C96F40FE53A9BF3AC5953F693E2EBFC3F3DA3FE215F03E833C0C3F63787C40D29524BF024E973F70E1993FE80A913FE225DEC0C482E140517BA0BF184A9EBC716A79BFC29F4BC03667BFBFF8E6EEBF50FD9E407529B0BF4AA3ACBDD43E03C0E0C088C0E211BEBF8D4114C0884EDEBF733785C09BC7393EB4B397C096F6793E6228013E4756C13C7C598EC09D99ED3F6F0BD7C075832FBFF5AC5E40FFE23CBEE98F96C0DB979FBD97F57A3FA05114C09F81E1BE9271A73FA0AAA63FE233D7BFA14CE83FE9B8F1BFF35F91405E859CBEC311493F58E8A54057AEC5BFF7A2343EA94D5BBF9FC1DD3FA23D78BF25B53BBF52B090BE6F59494028F232BF3F896740F086634079CEA73EDE11B640C604C9BF220E7BC03A4B66C02B163F4007D441C05F4BA5C06AE798C00BC0B43FB323E53FC35B7BC08C614440C5C8DEBFD744E53FD7B01A418B26B1BD9715053FA27DF8BFC8FD0F40BED1D8C0802894C0051926406B7EA1C0AA3EA5C0C649AE3F4E74F5BE1671BFBFDAE850C03D50C3BE303703BF8D1A4440E8D8EDBEDFA264BFF28C2B400F58CAC014CE2AC010D3A1C02CC3C0402184FCBF425886C0F18CA2C0A53D04406C5E3A405E9811C0E8E223BF5E48C93E5A231A407F85AC3F1A6E4B3F981F46406B84583F54698E3F57F59EBFE86F31C0584F7EC08942A74060CFACC0832643BFEEF0A2C0CC7A58BF2E6BEF3F252F363F952CD83FE0C285BF8576BEBF2893E83F0200B73D092EA83DF3488BBE3CBAE33E695746C00ADC093E194315C05B8ED5BFBD919C3E7A69A1BF7AFE7C40981D003F57F971BFB22437408916CBBFE8EFD13FFF7D023DA02548C001ED993FF2152EBFDF63A8C0AC242EC0591382BF52158D409984D2BE9543D43FDDAE81C0726CDB3FEC7822C027550840FF108AC07079693FCF19A8401BCC863E5207DDBDA18D083FB35A9ABFB08ABDBF7E8F94BE33CFA7BF3FC6EC3DB45D7940F0C630C097A65AC0AEA3B4BD30AE8CC01EDB324021CAD13FFD5633C0919C3640D521BA3E14C600413DDB83BF18A70AC0284FA1C0DF709140AEC17C40793BCE40B1235FBFAA6086BF46A831406FE8ED3F7CD7F63F0D76AE403F281FC05FE472C088093F409712744027B2F33E28561B40ED9210C0F0FEBAC07AC2CA4007F3D13E0C6CB4C0F347503F6276A7401967013FFA8450C08AA0F8BF5ACA1D40DCBC98BE983157BD061DCFBFDEC025C04F8B0340478F33C0F74D0240B909EB3EC1B72EC012648B40C27A48BF7CBF4140C36BD3408C7259C04F60A34089EA0EC03683DF3F430C713FB399D1BE79155FBD91133F4021D6863FACB6493FF93901C05AD3A1BF9FDF383FF01F493F9C3FD0BEF0A7544041B21A405DE988406C4F913E0B17D33FAAB6FC3F84D241C050DE62BFAC7465C05CB88040C79DFCBFAD42DEBF04A2BF3D0F3215C09AD88B40F4DE813D02BEADBF7A516D40CC1A5DC06F43FB3FF0A5EABFF1775B3FC4F90B3E41120C4023F19D4072EDD5BDEB7B30C0FC38C1BFA0FEF63E2894233F624C8A3EFB96E23D067AF1BDE601E73F7EC281402D83CD40B436903F7720894066C35CC0094F103FE3AD23408184D5BFAA51B33FC4C96BBFC92BEDBE507DC9408B523AC0010DFA3F829BA140A85C1CBC8F95E23F4556204050CC9D40F86A263FCC37C73F9EAC34BF5D2859C0F87E12C0766675C0A17A34406A802FC08DD006C0B2C16DC00FB94BC01E09A9BF78BE303F97D96340E8D5AF3F2166A3403BD0E54007E0CB3FB89F924096FD8D3F287B21BDB683B43F5EA43EC0D90B0FC014810D401D3C0EC036BC63BF855CA7BF91D68FC0C392A1C003FEB8BE6D0AC4C0256217C0C4E3FA40793F82BFCE384BBF892E08404CEFAE3F0006AE3FCD2A18403F260DC034C29440DF330BC06C4F0540A34BC9401F3FDDBFF32150C0D84F58406962193F96E019C0DB6CB13F342625BFD5E175C04581E8BFF0FABD4039BE144099E8FDBF16159D3FBD3A00C0841E3740973019C072F86A3F059B1D406954893E69DF96BD48A0AC3F7F2AD740628F1B3F0B467340E4C8B13FC19CD43F40B988C0410A08C023D2713E99E87B40D94B5D3F79EAB6C03FA51D400F1F8B40879BB7C0BB7B0B40FDE96140F4A991C0FC6FAABF73BD8FBF57A622BD7F0308C0F6C275C06E8E47408FD3CFBF05B07EC0A760C93E8112B1BEA9EF94BE73FAF03FD969B9400D3CA540CAC2AFBF75506E4041D9AABF845EE340864DCE3DAA8091C0A2D2B9C0C33E134032226AC02CE04CC0D81814BD8D1405409D4A36C0AE7B96BF74043FC03F57D5BF6529563E33AB1440BB54A03F6117A2C0CFE7D53F39CC1F407EA7CDBCDEAD7E3F2945F9C006BE92BF2807A13F7FD65B3F22B308C0D5A16E3F6E61EEBFF29BA5BF47B384402498A8BF6C2DBCBF2136C9BD826C7340A93605C0FFDD4740C92A34BF23A1463FAF8C3E40C24A52C029234DBF9FB6C23FBC5007C01F80A4C0E7ECE53F4C87D7BEF7071740957184C0E05D40C0D0E811C0D4B3A7C04D895D40D8C0104055D5A7BF24C471BF1BA502C0BE64BCC0AD7082C0D7B33440294CB23FD06F0B40FAB53A407995B0BFBFCD3E3F86B1F5BE33CE8EC0506C6EC044F1E53FF9FD66C028BB8240D13CFE3E9216264088453D3FFD79393F2ACF4740987DB4405789BCC04A9D503F9EDD5040B3D9494017E176C091274BBF24F7D2C066D22740951E02C03FA0D23F675974BF3B8BE13FA2D8E6BFD7F4D2C016EA904026153B40BDB611C0C9243340BF0CC0409F9EB540AD470E4045F3523F64E46440564AA33F83D59740C978D83FE0D47DBEF45C13C0D921B73F76171A404BF240C0B651BABF36316B3FCC5D994022B72D40CF9EC33F9454983F228E453F37324FC044597F3ED941C1402824AE3FDE6A9A3FA130824028AF07C0D034AF3E9AD18E40C8A679BFDCEFF140DC4C58BF945CE6BEB2C83540F077BEBF54F8BD40B00F4640ABA0BDBF071064BF"> : tensor<20x20xcomplex<f32>>
    %1 = stablehlo.constant dense<"0xE0C46CC05FDD3D3F989841C099676EBF61269EBE83E18A3F4284CABF5B8422BF977F96C0C99CE63F1466F93FB1BF8240426B22408CAE4F403FA74740A6776D40123A2A40D228164044C9A9BE93EE83C009087040DFDF70BFE70A093E82CCDBC04239AEC0300C8340A7BEBC3FA536B0C04962A23F8AE2A2C0918A8A40A6FF613FEF8912BFD2E47FBF1D6E23406006A6C07A379340789934BFE1A4B6C08CEEE7BF2A781FC0C9651F40EB33C53FB7CDF03F5775A1406EEC913F9A75A4C0973A723FB4E9B4BFB77C3FC066AE25C0BC06864059F3E0BF12140C407118B540C828D340456F0DC06C41B43F2D40B2BF9401D3BFFF870440EC260ABF67918EC0987366C0319D994057924E40F030AF3E57BB3B40791928C0646DF540FD2516BDEF1D7540D86E93400164A7BFAFD05CC06DD2B73F5F09A43F024D354074EA5040D59F5040F1DC0540498CC03E261FF53F4674C33E0F3F3EC01D87693FFED3EEC0671D4D40799B1C40E6D084401A05633F2292B8C082A481BFE5BDB13E950A3A40E2451C40BB431DC0DC7A00411EBBAF3F45024EBF5BAB6140F93C9ABF2E424540BCFC49C06617AFBE4AC336C0F8F2C33F77BA46408D82B7BD0CDE2A4032221DC0A4B33CBF58C4833F2A3EEBBF8CC0A84099BCA3BF0363B63FD808DEBD79B8D13F7F760ABD535CAE40E1968B3F792FD3BFD654FCBFC6616CBFF50C1CC045A206BF7F576140EAB3934093463ABF8BE6354072624E3F2DA120BF3F52823F05EAAFBF77309FBF1E8EF2BE9FEF8CC06D7A3B40B9C3BE3FF62370C0EBC90EC058194C3E8FAA7D400CD212C0407D51402A7139406D48FBBF01DF0A3FBA7DF03FB355B74040DF044064B21D404C6E5340C3F56AC02025E2BEDEA3B4C0CB354940883C63406380A73F995D0ABFF93A7D4027A3924033C0B7402B521140166F8840AE8AB440B7CE89C01793223F4C65BB3F6DC42AC0A74A3EC067C7AD3F19CA0EC0C53ACDBFE9FA893F0DB14940C79487C0BD21813FFE50B73F5288254009A58940BE7D85BEAB327C408C5FA5C0661DA73FC0BD8E3F68941BC023048640E8EC54C0A58956C09E5D074090871E3FEB5B91BF66501E40F1F561BF70E291BFC8F21EBFF1440840FC9B6240ED2319C0E0B32C4021A9C43DB83FCEBF79952D3FA8A0213F0602CA407B01E63FA39A9EC061384CC06D673F4012893BC0DD22503E9A58F13FA6E195C013F55840EC325C3EC6731AC0CED8D43F9801A93F7406A43BFC9C32C05EC45FBF41FF4FBFB78E5A40CC3DDABE6F899040A52B2D402C59EEBFFCEAD9BF4CDC56C03BD783401376F2BED485DCBFB5DB07C0AAF2EFBFF4011040C92542C05B3CAC40DF3233C0B91B774084B1E9BE8EDD0340697D73C086E5F93FA33CE9BF16650640E051963F4053153FCA293DC0996C50BF5BD60340D0669840842A3F40AC9610C0199D19C0C73A28BF6F255740ED06AA3F526642BF2F0F2CBE666EBE3F0C1D7340125077403B0EE4BF959B53C08B2D00403413DDC0FB0394C003846CC019CFC0BFA60D6E3F28C9DA3F4C8CB2C0FD4CBB4081A410C0A4EA0FC0A32DED3F6670A23D271725C05DF205402D035C407A20FEBF18564ABF203C3F3F383756C0E47A5C4052B67FBF61ABE1BF489EA6C0CEF1B93FCF0C61BF19E07BC0FC372740341D65C0CFA4B840D521BB3FCB2D4D3FB19D37C0ED1DD5BF35A691C09CEC14C055583140070837C0C2BED3BF26D1CFBCF5EA7AC02FA9934009D68A3E096FE6BF40E798C03B5CC7BE0DA0E73F6A8E193EA8CE7E3F10AFC8BF1C04F3BF6BB2E33FEA9E6FC08E172B406503DA4000113CC0BA64A7BE4ACCEEBF54D900C08D5D81403B5687C043A56CC009718E3F4A3A913F80AC0D3F89D716BF83B7B0BF6B9C10C01AEB0B404143B73FAD208BBF86BFFBBE3C81933EA87F29C0E5F368C071B6BA3E421E37C0503189C077DFA140EB45B5405C4C59400CFB1EC07AC3FDBFE677943FC20B133E5639AFBE1D99CF3FD3DB183F8BD674BEE6211440AA2D50C025C95C3D305007BE879992BEBA38B04094BF2EBE1A09D13F58CA5BBE9B301B40D2ED3240D3281DC0EE390840B994813F5CABF93F84241640D2DC06405A678DBF3E182BC0548543C08DF96FC0CED23FC07642F93F974BE33FEE1111403609393F01E539C073C422C0815745BF02EE56406EFB8F3EAED620C094CB023F0AC4E7BFBE6436C021FEA73DFC09A3405311A3BFAA52C73FA3A57C4098DE76C02925403E6C8650C004C990C0EE4158BFF5792A3E531FCB3FEDA382402496DC3FCE3E8D40025106BF83B8C3BE1C6BC8C00BFAAA3F20F861BED5E26D3FEF7BC13FD9BD6E40438236C0DCDE75BF41AF8C3F6AA637C045262ABF285205C1DDAEEDBDB1FA63C0F6F436C0B15B17C01D5036C0869B9BC0EBCC0841B450B23FC151D73FA6DAA03F387106C0602AEEBF87781EC0894A1E40578B413DE3C9893C88286E3E57D2473F12E797C0B08FF4BE99CC58C0953BE4BF96B51C3E341964BF3E75D3BFA08D51C01273ACC0E36FAF3E4291F9BFC86A98C0E25825BFDC0E9840655E12BFF625B93F10E3DFBF8DA39C3D57376AC0202FA43D8FB5A2C08A9409C0F2EFBCC0BF8DB2C098A1164080CE454050C049C005B818C091A0CBBFC1BB2F4067C931C09B3A5BC0F111B43F08ABAB3FB1DC9FBF31820EBF3D1639BF78EB3DBF0ADE20BECEA521C0C6CF7BBFF99FA83F39DBBAC01DCC0B3F5CC230C0070ED93E8090ACBFF49C00C04AD93F406509DBBF5875B7BFFC5C2AC01592BF405F41DFBE0B0C3C3F469B893F21DE2E3FCA1894BF7FBB17404DBE9B40530A9CC0197808401AC97CC086F567C046E86CC07008ABC0C1E7B4BEB717DDBE3CAFF43F803CBEBE8DA9443FA5B72A4079FE0EBF70718D402257B440B825BE3F97E761BF03BC33BD71B0A0BECD99C5BE3A10D13FC27782C06C6E9FC0190FCDBE95EA7ABF7E839EC0CADCF8BFE381A5C0E6BBB84056DAC44084DDCB3F7979A9BFE6CF13BF9A6683C0286082BE0F514DC0BD76DC3FDA945940DFACBBC0B51901C0347E4A40318D02407A951E40842C44C01EA72B401768993FE5FCD1407EC71F3F4ACC7C40E0B726C024FC02C0045C1AC0C98FD93FC7EC164098D15840665B3140ED740D3F72A105BF94D570C013D0193C856D7D407DC8B2BFBD0E3E40033D4A3F1FA899408DA323C03D6E2740622BADBE4D2FDB3E584952BFAF52ED3DD60143BEEFB3EA3F355D0B415B3EEA3FBCE48840287B053F05B9A940E206ED3EB25E3640C59609C066D7CAC00A2F744092EB69BE7C654B3E4ABD40BFBEFF383F29C94EBF59D88CBFCDD29BBF55F95E409762A1C0ABA7E93F28D03C406BCCF7BFD2BBB1BF710F2DBF5E490540C70B003F72F7443FB9BBAABF6D6CF4BFBFC2453F4582C4BFEBFEC53F260152407A94D13FC41B1340EBD2AD40B4895F3FB48565C07F3F60408F9C4F40DA9236C0C00A3FC0BBD7173FD934703F34707C3EE50E544099E403C08D301CBE59ABAFBFF71AF53E0C3E293FD073CA40F497BFBFF98040C069878BBF89C1F6BF6BD71E3E40CA28402DBFCD3F6337BAC0F251A53FAB7E514040938A4063A905BF83B511402AE9B740EC5574C063E0F93E3DAD4EC0EBFC884092E408C0B2375FC00C5B96BF7161E23FF9A0FABF000AD53F33B08CC0CF3C66C09B2A8FBFD49CADC013A069C087734CC057F0B840EB47333F94B39040ABE50A408DE445BF428F7F3F315954BFF933B1BF5D8FD5BEB8EE0EC0E5EB15C080054FBFD698BF3D3855023FFEEF9A4044383540901F4EC0F6A39ABFC39DF73CB6382740555EFC40F2C4DBBF6CAE5840F9F780C03B1158BDD58B6CBF501E9B406E904540A669343FFD928C40CFA4A93F130AFABE40D78CBFC6C4E2BFB4E743C0DF7BA73F327D0D3F2C3C2F40F84528BF9A0008BEB0A4A5C059A8ECBF2CBAD63FE3D365C0E55F5340FD240B400410C6BFD26A67C01E468E3F04CBBFC056274C3F7A9DD3BFCF0661BF285E6ABDFD4F9CC097D06DBF0940F2BE088C1EBF9E5D0EBE8EB1B5406E05B2C0613C8ABDEFB905C048F9CB3FA2B9863FA40893405529AEC0A9B886408898853FECAAD340A528AB3F0D55813F39A181C085B495405AD6C040AC0082BFC2719940D8B9B5BF20A1D8C07C27FEBF6529B3404A761C405C9EAC404A4F34C015C628C03D68B33FC14E4C40F40D824054CA9CC08336C83C052723C0C11FEB3F63585A40301A363F16F40D40D5AEC140832D33C0C6B53240874D9EBFA965DF3F0A9FAD40F6CEC0BF3ECF79402575C2C0B930A7BF3A06403F5A9C663FE214C1BE172F82C06BC182C06F8AE33D5FE6D74082BE78BF3F01F0BD0F0403BFC56BFB3F573BA5BF6BAA6CC0E16F7640219C6040173082BFDEFF6CC0A1742FC030A2B93FDA34563E8BFC423FCD3720BFBD06E9BFD45CFCBFE657C63F55BEAAC03361DF3FF2308B3F790EB13F256E9ABE5E84413F484B52C0B59819C0F67B1BC091B5C0BE866AD4C0B529A8C0496E963FABBF0240E26D2F3E3BEE1AC09382E9407C279240"> : tensor<20x20xcomplex<f32>>
    return %0, %1 : tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xE6C3A54057D8D3C00F45BD3FFB2A57BF36BBADC0611FED40771A1CC1F7A25B40E499B340648476403F0E04C03E4970C0A49F293FBE606CC076B96FC08C5624C07A8096C038E1C9BEE66184407E90E04051A1A5C00C2E25408E14B43F1CF9E740FE59A4406022E5BE60E59CC0D37E2440BC2A00C0BCDE2C41F06A573FE8C53D40105F9E3D2C9C4D40BE6387BFF605CE40F883DFC0632E853FED1BCA409FFF7340C8CA6D3FF4FD403F871490C094F427C0962FE3C0B05497C0DB35BD402DCD8940A26BA7409BC89740CA1E4640651D7DC0419D4540388FC73F0429DFC0A570D1C07CCD293FC68B69C0DD64A43F380BBDBE82D482C0ECAB1B3E1070F2BE924CF33F0034FDC07A5A00C1E55112BFC1CE50C074F622BFBF7A1BC1DFA44B40272AFABF96910AC10AF7E6403766B74060EA5B40BE7EA8C0E60D49C052E8BEC0AB7363C03822D1BE3A035CC000053ABF39E77CC0300A2440D64D26C0C5090541A2B261C0515C68C099066EC046A5533FCE17194052D93340C209423F9BDC18C1AD4A82C0783277409E39ADC0CF841CBF12B4243FE0CC56BFD48315C010B675C057C53341A466074129C97040A0D06340D31ECBBFA0400E40BD7DEFC0CCB21EC0963AC9BF5E844D4067215F40142E92C0164F9C40245EB0C034D59C3F60814E3DA5CFAC3FFE55FBC00457E5BFA4B3DC3F8F4608413C370A4038F887BEEA6F0DC0F4E6BDC0380AFAC014C0183E80EDDA3D48CBA03EC03C27BD16669DC0D090F03DF8857440D4923440548E8E40291FC3C0F62E4EBF5A967240B94127C0DB05A6C03FA6AEC0846D1FC08D7596C0550524C0D68E5DBF57B26C3FCE8B02C09C7B15C04AA675C0AEBA7AC010E3DABE642C443FCF619040840B9A408FC34E40680701C0602D1B3F4A5D653F956C54C0D8C734C0BA21E5C026CCC13F9C1CC9C0633A6BC072B60341000081BF4CA8E73FBA4A804052609040EBB900C1A2501C40A0CC1040CC374CBF646A27C0786B79BF00FCB03B0CC5E5BF68F903C1DAC0D4C00A80183F4857AABE68789C4040C8EFBF6B7606C062F388406E80FBC0A2C9C840802C814018906DBF5EF2AA3F1E4D71C0F76F10C14787284038CECD3E108267BEDC51DFC030AD42BF8C3FF540359939C03D9B62BF8810BC3FEA5B8C3FC626173F7AE911C1D61CA2C0461CE5402647BBBF418952C03E7ECC40087493C03E8E19BFFAF49B40F0909DC0C1A8D3BDD0F2143EF4B13D3F0F22ABC01079F33E05262E407DCBA6BFA69DFE3F4AB407C0E0FB813F94FC58C0FCB77CC0EA11E6BFA632B240D05C343EA2805FC08A93C2406D460740CCF91B400DB0304035B6AEBFA55645404E9DCAC054951D3FA5F9F2C0844995C00EA74EC0D4C09D40934561406212CA3F2803BABFBBDED0BF96E52EC080D3FA3D108A50C0387B2EBEEB7129C073197DC0F827FFBE4D2D6740488B40C0AF6A0BC060ADFCBEA7A5193FE4D52040116A7240A0B43ABE47D05FC0513BF140A458A240487F1CBF010D24413A4F00413E21B3407041ED3D0C0E85C0360289C0A4381541FCA1E5C01E875B4014B6C83F00CF11BEC879C73E482648400C0CED3F519482C03EB74A407C0CFF3F60B3C53E8C1466C0A48A6640A08082BE3932DF3FFA708740544C94C09DC11DBF9D6C0440A4C216407A080D405C57BBC0BECF60C09966A2C08029B13F5ACA26BF262534409404EBBFDBBB25C0C2BEF0BF95FDF23F87221B3EA26D7C40560111C11BE4CA3FAD6F9DC0D1F682407C9877406D3CFFBF5C5C9BC0D26089BFEE142340907CD6BE69090EC0DAABA1407C84AFBF2FE807C1A81B9840BADFC7BF0613CD405091DA3FA97650C04A9F164118CE094054B96FBF1EE1FEBF5FEB963F32CCC2BEE1B9253FC20CFD3F54B9753F2A5E08C0CB8C9640707F8140E869223DD968054182710440783289C0E0B33CBF66BCE840BD6401C1A5482DC1CCC602C1125B794096737140DBCBA2C0D0303B4070FAB2BFD05D2D3E1A23114146431C3E00B9E5BFB2DDA73FA38A0C403C97D4C0E8FE8AC06F583AC06E089CC0F080D9C011C3C93F25DF39C02E5389C01C004FBFF6A320C05130C3BFBE898E3FA1DF33C08A0540C09F407240E09769C000BAC53E2659A7BF4A5610414CE37AC0282BBFC0E815EBC0AFF6AB3FB621BA40A860893E64D2053EF6C43DC0EC2308406E1977400C45913ECE009D40D9856C4072E9833F52C7CAC07DCEBFBF56FCB0C0DEBEA33F5080C5BFCD2F73BFE0B6EABF55736B4012C62D40A8900B3F20D4D03DA514A4C054864DC0083426C002311D3F05C4ED3E8DB6BF40F81664BFE73738C0D26B4BBF100176C083C2ACC07B144A4030E899BEDAA63640D0AD574024A68FBE541B33419B3BBCBF5279A640EEFE3840BC2743BF4FA38140C8D88540DAFE5CC183A683C08DB22CC051BD49404A41D83FFA36614066CAC9BF405142BF197F25C093410740438291C0649C063E70002041E6AD3D3F5EE451403341144066F1ADBF2CFC16BF5E51AE3F0D4CFB3F2B26B040B86F63403CF94FBFF25DAC3F6CC40E3F865E12C1B77257405821453EEACA86BF75B73140C9BD80406CFBFE40C0BE8140004789BC50065D3F4FFF21412C40CC3F72A8564064F71140600FAB3F47BC8B40261E63BF929A9640AD090E41383179C0F25CA4C0F07B874092D98B40A877993F06D14A400C8506C0125854C0733CEA406E4668BFA0E54D3EACF7883E90D7FF40AC00A73D7479F4BFE095893DC03B08BF2EDAB43FCBBBB03FF29C853F423909C17B731F404A9262C05001763F126565BEB856C9BF4A19FE3FA5CDB4C011EAFC40B62F8F40385A0D3F89AD0B417AFBBB3F3EE9E24012C0A53F40E0B73CE8A7FBBF21DB56406A05923EF493F0BFB6F4BABF46E6B5C02E3B9DC0802B33BF928FF33EE07657404FC82E40FA4295405FBCACBF853DB740169CDE40A13028C02862C03DA024AF3F8EEFBE40E2B44C40914CF0C0CEDBC1C0D1207BC0F836B640C40B243F33EE2F407F9D7D40D09B7CBE9065763EE973A7C0DD1BD74051D90940CCAF79BF15553940E64425C0C8849D3ECE2186C0DE5037BF608ABDC09A42B5BE92B775C0102C1F40177D764080F0CE403B1F9740DAA29DBF58BD653F660FC7C00087363C40164540541306400A1EB23FFB2F9CC016FB6E3FE3EB5440CCE16CC0BE4936C0486DF3409A0A28C034F006405BF004407B15B840A2C0083F0798DF3F1F8522C04CA741C113CF83C0FCCB01C1D71B13409DBC00C1697124C03210D2C0944484BF1E95A0406CFF47C0507872403869963FCA7DBB4043B0CE404EA21940CED5B54032E81440427F61C08483CE401ABC99C000EEA5C0A5B38440D07855BF14B35ABEA0F758C00AD89FC0B131BAC070F8783F52EF86C0D5D248C02B021641321F24C0AD6782C06022FB3E78906EBF6B5182C0C090C03FEABEB03FD289923F3768ADC023F19D40826814417E9514C0951786C0D58848404BB62DC0E8DFAFBEEDF2C43F7E303A3F9A428AC026901EC0008EC7BE338A74405919833F404E1440103F9BBD0D312D406CFDA0C0E88530BF73820441D8FC82BFA63556C05CD63EC0ABDFE74055A3D5BF9218F9BF2F9DA640A824963F868A85BF0C02CDC0B40118402690ED407C800240D582EFC0DE7A8D401EB92B4050ADABBF45DCB840A5BF944000975F3F15681440CE940440A435BAC07AD534C088CA05C10CA3723F91C259BFEB499FC0C2849C3F59EF843F683F013EF9B58340E62F0241BD1CBF4057BCBBBF27BB4D404EA6C5C062C28840FC91544059AF55C040CABAC098CF9FBEB7B738C166FBBDBFCFFE5AC04082C34058EA32C00ED780BE8AA0FAC0071E98C09ABEFDBEC77A04C0400195BDC07692C0885F31404E978840654C4240C093A0BE687A05C12F9B78C0242AF53FA6D67D3F3E964240A2FC3140CD8D62C0EA051340A41A583F0F715FC080299E3D2121614073492C405F5F7A402AD414402B10733FF9D3D33F2836424070AACC3FB8B5023EA146FF3F745BBFBF320DA0C0A86C78C0F98CA440DA591B403B2903C0422D93C0A14555C03C5E1DC1FE760E41F460F9BFEEB616C070E3F1C06E3958C001BADCC00074CFBC666AEDBF504394C026704C40145BF0BFE08B243DD87AF0401ABBC03FCCFB20C14D71C5C0164466C0BCBA4ABF321ED74012B267BFBCE018BF86CA54C094F9B340BD3E46408D0803414751F7C0103126C01257234074966F3FB08F1EC19F630040042916C12AF976406AD171C0F4ED71C085440D3FA00909C0FCBE8840A928A9C09ED27140106E01404228F3BF7CC1DB40156721417510B24088C290C0E4D8E53F6E646C405ECCE43F24F5314010DA3E401DCD5C406AE6C4C0340B05C0822F5B404C36303F8C97A43F2A1308BF25AC9240FEEFF93F5BDD0940A8AD4040F2912F40152F99C01FB9B2408C698940D8CC8B3ED81C35BE83D78B40401038C0E2316840F49DDB408824BA3F35FBFD40EA60B940ECC399401B23D53FA3FB61C0E57CB840F67EB0405F750CC17DA9AEC0"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
