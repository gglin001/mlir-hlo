// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xcomplex<f32>>, tensor<3x3x4x5xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<2x3x6x6xcomplex<f32>>
    %2 = stablehlo.real %0#0 : (tensor<2x3x9x10xcomplex<f32>>) -> tensor<2x3x9x10xf32>
    %3 = stablehlo.imag %0#0 : (tensor<2x3x9x10xcomplex<f32>>) -> tensor<2x3x9x10xf32>
    %4 = stablehlo.real %0#1 : (tensor<3x3x4x5xcomplex<f32>>) -> tensor<3x3x4x5xf32>
    %5 = stablehlo.imag %0#1 : (tensor<3x3x4x5xcomplex<f32>>) -> tensor<3x3x4x5xf32>
    %6 = stablehlo.add %2, %3 : tensor<2x3x9x10xf32>
    %7 = stablehlo.convolution(%6, %4) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64, precision_config = [#stablehlo<precision HIGH>, #stablehlo<precision HIGH>]} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x6x6xf32>
    %8 = stablehlo.subtract %5, %4 : tensor<3x3x4x5xf32>
    %9 = stablehlo.convolution(%2, %8) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64, precision_config = [#stablehlo<precision HIGH>, #stablehlo<precision HIGH>]} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x6x6xf32>
    %10 = stablehlo.add %4, %5 : tensor<3x3x4x5xf32>
    %11 = stablehlo.convolution(%3, %10) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64, precision_config = [#stablehlo<precision HIGH>, #stablehlo<precision HIGH>]} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x6x6xf32>
    %12 = stablehlo.subtract %7, %11 : tensor<2x3x6x6xf32>
    %13 = stablehlo.add %7, %9 : tensor<2x3x6x6xf32>
    %14 = stablehlo.complex %12, %13 : tensor<2x3x6x6xcomplex<f32>>
    %15 = stablehlo.custom_call @check.eq(%14, %1) : (tensor<2x3x6x6xcomplex<f32>>, tensor<2x3x6x6xcomplex<f32>>) -> tensor<i1>
    return %15 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xcomplex<f32>>, tensor<3x3x4x5xcomplex<f32>>) {
    %0 = stablehlo.constant dense<"0x63F0A4405BC5A03FB42A92C044E29B3EE91DAC409A03B54097FE2D407C19C5BFCFAE0440A6B2C93E0307323F073809BE78AE5BBF33E2C0405DFAF13E6D5A5D4073989EBE4765D3BF4B7214C03C9A44BE894A664088301D40B96E04400C4D12405D3C47406CC93740EB6B3FC0843E34BFBEDFD9C09A2BB53F9A9E07404EEC2ABFF8044A401FC868BF5D9FA740575C3DC09EBF17C06139CFBDF9B7F13F3CE0FFBF01E569BF2E30FFBFA76F873F7FF45FC071BBEBBF0B81E7BF88466C3E741C943E1D1D34C0DA42C7BD4BDFC5403A3914C0147C01BFB15A0FC072C519409097D2C0B0B8A73F7EB03F407074D54097D429409D4BDFC04BB590C035CC3C3FF8BDD7BC03C5F53E8AD633C09DDB5440B4D18D3FBEF789BFB3BEDEBFC1D9813F5A09AA401335FE3F3D5DF0BE52BA9FBFA46594C04DE990C0616507C18CC86C400B8B404024B9A33FAC194CC09F7D41BFFF7C283FA99102BF4174ECBFA8116240B3DF413F7957ED3E52E9EABC875C1CC07A0F12404973BABF97DFB940C20D233F1952C7BE3103AC4057A14440D546514066FC4FC029B02A40C7286ABF640F1CBF0A68783EECA7CCBF1591CB40C1B490C0F516B7C06C66A5BF559DEEBF38D551406CDC35C046F18B40F75E2840E9BCD240CE88354062EA723F48242CC0F7899C3F9706D0BF1DA63C4000D847404E1E80407FA778BFA423ADBF1CE74440BA25F8BFD55538BEB66DD4C0AD3186BD4642F4BED065D43F8400B6BE11C836BFF5C00640A00EBD3F5B02A440B926E33FD0A06FBE3FC219C085050E3C606187BF0AC037C0E9779B4068390F4137693EC0D976A0C020515C409454EFBF50830E40096E37BFC2F20B3EFF81873EA9261FC01A1E98C045443640862C1FBEFC0AFC4047EF55408FBAA8BF4FD550C04C3456C0A1E39A40BFB9ADC09B68FE3FF59CBFC065DAB1C0E516073EC5619340D528123F171359BF20AFDDBFC846B04028D0E83F60DA7A408C9AB23FF682C6408CA3433F8E7400C0F8B27240A6CAC53E18576E40237CA440B5EDAB3EAD4FC2406A2BB4BF0BA306403AF4BBC0166AB73F20C702C08582A74075E1CB3DC532743FA944BDBF91AF1140E1F1B04089FF053F5CA58C3DA334ABBEF7B2F43F292D2E3F42D584C0E3DF0A41E0C03C3F6285BD3F73B924C04681ACC02C95E03F164EC53F3B2F2140996EA4C08147583F9E6808C06D233640DB21EE40B45C0140CE00F4BE66BFB23F0015E8BFEC440040762A2940EBA5A33F3E6748C0A5817440B1C4C9BFCEF2553F4098923F87552640A16BCDBF4B900640D84EA1400667BFBFA5004540DEC0E840F9FDA03FA3250E3F17C15D40A14BE9BF7072BABF61D88CBE43555540CFA8DE3E148000C0AED387C02793D93FCFF9ED3E5F53BD3F1CB578C03041F3BF01EE4B3F7DEF63C08242FD3E1D3C8A40A3D0C83ED5BFC8BFFA794EC0D5F6E53F156B4440244686C097057CC088B95940A207AB3FE8C171BFBDE1803FD35E0A3FCA71EF3F9788C6BE2D9289406EEBCEBE285D09C01E2C33C0F4342EC0C9CE984013A7C73F1BBE813D6E82BE40888ED2BEA95AE9BEA1A8D7BF2FFCAA3F3E8391BF94D816C0389F31BF6CD022BEB91183401726824038F409401643BB3F2EE01C3F56B118C0342F8C3D8436D2BF09699A4022CFAF3F7B530BC03668E13FBDEF834008DF0BC038BA5AC00B74C53D40400E4048C4A9C0E9F8F6BD45CDF2BE2DCEA1BF52535340FE8282C078FC8AC08B892B4071CC4B3E7D3787BE07AE42C0EA1F5940163CC2C00AFF6FBFFCD716407D117FC0472F07BEC93305C0FED39EBE390397BFB1244DC0F471EABF20A8693E3AD1923F4F3DB63F2B355F3F5AF74A401709DE3F86D8103F18FC72C04ECDC8400FAA143FCFFE4BC07CF77740AF92EEBFAD65414050B919BFDBD83BBE2E4F933FB72FCA3F6C43823F8F537F406C3A7540639F9CBAAC64D93F6ECB494045D02B40C43CEDBFEBA5F8BEE05710BFCA3FA43F1C6EBDBFB8CC75C0664B93BD2098A7BFCEA1103EB8873E402A956740D8AB573F8B9A9240ABE3CCBD7475D43EE0A48C3F8544943F5C56B2BD103283C0A3B39CBF840EFFBF9397B23F033184BF9855BEC0E0984240B6BBA4404CD0C03F86EF59C0E663A34017FEB83F2FFF1FC0BF3456C0C2EF50C0E027613F2B490A3FDD1F92C0EC13953FC3AC1CC02EBB073F12A446406311033F9D324CC089347DBF02E23AC020DEEBBF089D20C0E2B7A83F7A091E40D96BB6C078EA8EC036F1B0404BFAB5C07DCC8B40CAB823C0757161C0285F4D40090753C068DFFE3F66B4BBBF45AB06C1EE993C4004E78B3F8703873FC79F27C0A93780BF836EDABE6A5047404DF28C3E8E20C8C02D73063F8D2812BFC80113408C4A11C03A156FC0E389BB405EFD6A40F14829C06FEC34C00768A4C06319A140369B31C071E000C09AA37D40E009213F5DE42DC0ADEE2EC04CB6CEBF1EC36BC0DF6A6FC063C817C0724C01C07E3644401CFB7A3FC4CBD93F6ED166C0E9D72DC0D2649BC05411C93F04D87B40EDD09540CBA4CF3F6ECECF401BC220401476493F090076C0A8EC3B3F1C988DBF24D7E73EF4645040980ADABEE92300C053364B3FAF06BABFEC291F40E65429406568D93F062F02C07ED0823FF390A13FE7343CC066D181BFB4256A402050A9BF138AAD4064F887C05E1D653E65F060C01C0E16BF9F8AF1406259243E29A7EFBD4627274043FAA23F3860CFC0D51E43BF617B7C3FBE5455C0ADBF89404026283F851C44C0DF6A983F9EC0164038AD88C04A1A4F3DE6729C4046DAE73FC701B63F8274A3BF8A0ABFBE9E60963F7AF0DABF02469CC0D1638F3F13EE0640A393293F9D3DADBFCE831FC0C46F1540F03821C0C026E2BFF40A0340001C9F4039D356407C1DAF40D40A7240A0EC2D40FB4811C04CA11E40CBB200BF94EC8240B9B0EC3F03C28D3ED0B01AC01266DFBFBCA21EC07A9015C01BA5A63F06622DC0732AC840C8534ABF952EEE3FF12C653FFC21F63FE73EC0BF37935040F32F00C02B411EBF0A0D84BFD22FF2BF22518FC060330B40437846BF14F860C0BCD9513F6EE131401918E23F3CC19E4016C6523EB3D86FBFCE0A0C3F87FBC4BF29B53BC0A9F64FBFB028BBBF2231ECBE08418BBF2C1933C03A363FBFD263803F9B991CC0244A0EC0DC085340349C503F467A55BED62F30C0938883C0BA5E423FB32A8BBFD9EBB5BE5EF0EA3F31C2A1BF6839963F477E1F40CDA5D8BFB1D174406F22B5C06DE996BFF901C43F3C29AAC03CADAEBFD7235B3EF9430FC0A3DB3B407584CEBF3838B8BE2CBCBBC0F1FA1BC0F1C691BFB0544BC0B1BEEC3EB25F4B4046CB0840ACDF8E40738E8140EC1ED5BFA68202BFC24991C0ED66CD3E80DC9340027C0EC04815A33FEED0E73F076F1540612B15C06272C2BD90968F3E745B44407E5755BFCA7108C102F39C3F4ADC41C079FAB93F592838409AFE97BF1066E640D707F2BD336F873E1F6140403918C33F8E7B37C07B5711C06B4A36C06E97F43FB76B4EBF02BF353FA1D6BE3E1D11474020CAE63F6177D1BD856788C0241FFABF165A2F3EAFDE49C05D5AEBC0CEB208BEE7FDE13F528126C0079B1540AE565F3F7985563F106282C07E064BBE541054BEC77AA7BF7003154028BC79BFDB1917BD97BFC83F6A753C3FCFA5F7BF5D4A0FBF34BB5BC0D0113BC05B7F4CC095562F3FFD32CF3E318D64404005653F7BF5FBBF4B3391C065AD27C075E02F40E95AEABE908B80C052C79140DFFD2F3F69371440255944BF692C19C03E482E403D0AA23FE27C05C0FE81B23E2B00A3401E9C80BE694726404038D1409A43CDC03BD403C1525A9BC00DB283406C1D313F22AB23BE877D0CC0C045ADBF344969C0CF5946401DBA353FBE531FBE0C71E53FE5B4A8BF976E3540510846407E0BABBFEF10D6BF3A60E13FEDE941C0B6C7DB3F95DD07C07B3F1340D87457C0F4AAE13F443F4BC004B10A40E80F4EC0C90D793F5FE25D3FDD8118C0D27A8DC03BB191C0BEFF8CBFD9079E402EFBBCBF50B339BF0D71FE3F78F2B740C27205C06C5FA0BF94BA32C0543880BEE103D43E868A9CC0AB1200C0FFD4C7BEBF4CE8BF0C31933F16D8873F214E823F28CD5D400E8F3740292BCEBF856AA8C026E358400386514098C7E03FB5D1B8BF5850D1C0F8E2493F49B987C0B71681BF1E27E6BFB3C10B4080EF494037BE974025657BBFD20C37BF34E03D40F7582CC040DF3C4029D34AC04952023F7C5B5C40AD1A62C04DE614C0750ECDC081E3953F50FF333FAC8B2BC04E450A3E6F174CBF392074C045CE49C0D890803FBFD12140303F14BFB4FD66C0101E06BFA6E145BFC61948BEE3FE194073045C4027BB98405B57893E406F164057901BC0E539BAC0DF4613C05C3227401C0F48C09FC82AC069E6A140D78E684021812A405C25954010D82ABE5B5A823E3EE93840CE422DBD86836F401B7CD7C0A8C1943FB8459ABBCC408A4093F5CC3F42083A4056284ABEEFE3C9BF313C0EC0110C19C051BFD23F32636A3FDB6BE4BF747EC23F32F7E140572E4ABEBEA383BFAD9D6B3FF28A85402AACE23FCF6EC5BFC2D08EBD398498C018EF8EC0F0896F40596D7B4076A05B40B59773BFD9B71CBF5B12C9BF529CFEBF90C9933F0C363040E51101C1C10C90C0F261EBBD355A4A4063DDF63D025A21409914BEBF8FEA6EC019C5543FA5AEAABF1FEE47C0EB4D02C039164BBF8F7993C0FC3AD63FD314D53F86F28D3E09F186406DBC86BF53E3563F9427EDBFE0301240B66DFB40A204B7BF2274773EFF0961403BB56BC058A6EE3D339720403D9E093FEE458E3F0BA47D3F87C220407CBA6B4098A280C03A3CB33DC16BA33F5EF6BAC04208E3BF493E1F406CF552402FAC0EC15D0DA7C05EA83AC0FE7D65C0BAF7C9BE7F3E93BF1D6D83406AF2DBBECFAAE63F0FFF30BEC0074F3FB8999DBF098C2740BAB11440D4D64BC0CDFA89C0F085C6C063D383405B4686C034ABCD3F1BCD484041E6A0404D75B0BF144A26C05C025F40CF77B6C016CA31BF05CA5D3F8A5B1B4085B7273F0564F7402F36BC40423D49C025C66C40E72200404C3A51BFA5FF80408E14E7C033C013BD5D7DDC3E079B703D24DD09C123D4013F553605C0516692400BDB8840F5333CC0F65BA83FFD8ECDBFAF058DBFAE53993F35DA893EDB29B6C0F5FE6ABF8CE4A840EEA1373F15E2B2C0E7C81BC0FCB501400323983F9F0B41BFBBEDCDBF8B01553F34C1743E73E829C04770503FF15DDE40472D03C0D4D17E3F1B79AEBF8803CFBF434E20C02DB96EBFB68B6840D15F3FBF02489340C0EE8AC090AB9EBF63755F3FFD7109C0F1BE9B3E96BAE23E6EBC513F3BCC28C04061DD401F4E913FE0EB99BE51539C40A5B5D3C06052F03FF4A447BFEF05A23F1451CCBF3EEE1FC069175740B219833FE99D7F4083A6B0C07DD2333F1B633FC05E4819C072B012BF519DCA40AEF72BC044DCEBBFE4523540492C9E3FFE151740CA249140BBC6F63F83A99A3F0B5E393EC4DCDA405FB00D3F4C13A03F348DC9C03E153A3F98D8253DF28A7340BE9A4040268F38401029A53E35CCE6BF005F753F0EE54D3F522797BFE6825E400B0A6ABF2F99FFBFEE4D41C030D10D4087D54140DCD8CD3E94361840D26B503F22D54AC0F5A3923E37EABC40568F8FBFC65E8FC084188E4000D582BD5D0BAC40B321D0BF67464EBEFBBD394035DD1ABFFE7A1D3E54AD95C028F502C08986A1C0BD23C3BEF17C0BBF8546DEBE22B14240B03215401CB01BC0A18D673F7A0D68C0071407C0D491CE3FB163E6BE46673540F9A02E3FF05B92BF7B0F8940A47786404464C13E509E4D40C95DB4BF9890893FB97263C03543B54003B393BF3A69F740370940BE4E55DD4091A5FB4004FB46BF82431540168853C01DD59940C750BE3FF322A4BFF700D2BF05082040DCF01F4033431F40305A06BF61E2A63F61E2B43FEFA9A6C039E35E402E45D13F6FF6254011C394C0CC3DC2C07C2E6C40F19E6D40A96AF23FAD2F0FC0CFF270409B3980BF2A2F963FC250303F68E5944067E2A4BF16FDFABF8179033F579E5FC0FAE588C04B3B22BF69614FBDF75AC9401C49D33F2C1DFFBF27366D40666DF4BFD52C7640"> : tensor<2x3x9x10xcomplex<f32>>
    %1 = stablehlo.constant dense<"0xFDE71CBFA5E6B8C06567FFC07A01D33D8EDE943F1C6F0B41767B00C1BE685540E81E37C0C9C71740061FBCBFD646F640816F7B400F0A75C0112DE63D3A6D51BF961CADBF346DB4BFDB842B3F038D6C3FE3D3C6BD6C15AB40F9DA4C40F91B163F741B40C09DF38CBF203D1FC0A6962C3E743CA43F7AC0BCC014BD3B4018B926C06A86FDBF073FA8C0EBBF9DC0E26962406D25A7C02FA011C0192A4C40785F853F1CDB27C03C28D0406108523F870F30C08370833E7D7894C08760D23EB0718BC04F70BFBFE268343FCD9181BF245C903FCE1B85404B82F0BE58E2713F29616A40A67EC94009AA0BC037667C4013E2853FF4AF393F459A3EBE35F5AABE97561DBF87CAF83F32182C4007E28D3F1B426FC0596A5FC05B13A03F330A2DBFFA5A31BF85B62DC02DA3EFBF14D24540F14A104099045A407FD8D2BF071A94BFB91C613FFE73DEBC1D0E94BF9B7BA33FDD1E81C0CE5B85C07F71373F01BB83BFE8C00341EF88EDBF8A0DA83FB1305FC0EE65C53DB1FF46C0F5035BBF782E903F2157BBC0FC3E48C0A52843C0E1CD073F67A4663ECB3A58C03DF5C6BF252AB9403A110FC04FF27CBF87D463BE99E53D3ED8B285BFC67FA43EEF18E5BF8CB30A40D942B9C0B4E16E3FD9E3E13FBDA880407D6451C07DA0C1C0328565C02B658040B23F44BF374DA13D14D40E4043B09540DE285340FED44E4041ED17BE7314A8C0EEED1EC02A7D9A40554716C0E2F87EC02014FCBF9C4E423FBCEB93C024D272BF8D749240B9B5ABBEF4247740BF9A283F2440104013EE98403B538D40AC825D40A87996C0C9A98DC08E3A12C0E14F033EF16068BF674238C0650D2040082CB93FCA5A3C40C1D1F3BEF8D0BC3F3B004BC01ACBDEBECDF16140F3EAB8BFA7EB58BD5F66AA3F6BE6C5C028FF52BE646CCEBE278EF1BFCE19FD3DB08184C07A40A2C0562DB1BE924619419CA1494088AB8E40F57B57C0365C8A407C58E33FCC624EC04A7D59C044B4D03F5521934065CF0DBE22792540A85E8CC034E0EEC0E686F7C024BCE33FCD149C3D68A982BF475B0A3F7321BF3FD11E544042292EBF38413B3EF69E04C08A3B064112EC14C0ABAB60BFDE4727BEB42FF3BF17A1133FAC3212405C6A024058AB504022CB8D3FBD02094118C065BF79AC6B3F7D0D8A401C98CE40CA1128BF722E1740533D10BDC50048C0F93800402D1E22BFFF6F5FC0DA9D3D3F309623C0887AE1BE2A0754C0A56E3BBFE5F79DC0FB9264C074DC0840AE3EC7BF686772C0AD163D4004287CBFD8FEF6BE1BAEADBFCFCC4B40B7C34AC0C18A11BD059DED3E646A3AC09B6CB7C02C5CBC3F31B93440CC97D8C0BB45C84014341BC0E5A402C129F5294063BCA8409FFF0EC00FA6814099263640514281BFACE8A240696C86C0D6AFF73F19794A3FDBB069BEED2D023FB78B433F8CC8E93FC8EB94BF3FE75CC0D3F4853FAA0A02C0177CA9BED353BD408D558640FFFF9C3FD526183F4B4D833F6D9B1240D504E7BF42945C403809433FE90F08C06B83BCC04E968C40396ED8BF3DC9CDBFF7A33E40252E2741FDF317C050E58CBEC877BB3F679005C01E2B213F06B48DBF61C40FBF06DB15BFC7AB053FB1253CC016FD06405208B54044CD523FCC0CB04091B875409551994027F23240868ADFBF834C54BEDB754DBF34381540FE513F4073A66C3FECDC513F013251BFC52BAF40E82308BF8610ADBEF491D83E25F6CB40FBED5C40C0C583403D723DBFE290F9BECCE478BEE6C63EBFE152DD3E94E3A73F5D885CC0525F5BBF896CB53F65844C3F55AB8CBF9A3112401BA5AD3EB23610C0CEBB163F39E0373FE438DDBF8FC2CF3E4767C7C01C2CB63FFA706EC005765DC05C53B5405D1031C03E8B48C0AD1F64BEF8BC183F18F293BF83EEA7BF7AC39D3E7EE689BF3314E43E43D991C043DBBCBEBD684240564C30C0BA7B5EBF6998083E9A8BB2BFE02878BF1DBC51408893153FB63607C050D9CBC0E87EC840942180BF6759564046AA93C01160CC3E39EF9FBC22DAF73FC66561C0D3407E3D"> : tensor<3x3x4x5xcomplex<f32>>
    return %0, %1 : tensor<2x3x9x10xcomplex<f32>>, tensor<3x3x4x5xcomplex<f32>>
  }
  func.func private @expected() -> tensor<2x3x6x6xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x96DAC9C22CAB2141220F62C28806CF42332B99C31E18A1C2A9CE96C2707E2042D355E9C2041770C246D1E84211A74E43D007BB4160FB62421072ED416CCFA7C20A1B9A422EA2BD4248A60F4318FE0E42D02E1F4196DE47437BE2CE42009948BFE0B30B43F9D91942D42DE042A5072743529C8C42FCC2A9429452E0421E1E3542869E36410755AE4255CC57C30E23C0C2C85BAAC2496AB14220CFCA427620B3C2D91DFC42C405C041FFB13142632A46C202F502433388AE42AECA0F42E21130C29C6436C221619343E0D532C0DC6FFD4100ACB4415688A6C2964150C135F031C3D9C05F432258ABC2CEBD4043908AC4C260D0F640786BC441AA72D842B4BA57C3562CF9C1A49F8142D1EB0DC38A7C25C2B46844424D7055C27F64CBC2E41B06C2BE2691C2651F87C3678AAA42162208C378B3C7C2F0DB01C144E93B423CDD874374A1CFC2602F0D42AC6EB6C2202BB742389457C1547F7C41BB178AC380DBF1C0480EFE41C86E2D431ABD024388E441C130E06741F44B0BC3CA628DC16C201543887A69421AA899C2EC1F3D431CB15DC200D4C23DEA32BAC2ACD9E4423593FAC2AA2D2C43625722C3DA227DC261351843F4374C428BA6F2419E1671425C0F124318FD6AC15271A1C2474283C380E65D40F42EA2C25373EEC2604EEAC1D077F9C26E842EC2B454E3C2B68D0743D2DB21423EBC8243DA7D3D4344C057C28C22A14322708EC29D4D5C41601651C2BE0B49C25C2B46416635854268B49D42667CB4422E289F42A41206C3561D36C220DA1940BBB71142129A03C2152D6C42A45230C26C6B544258AA16C286BCA2C13A68D842BA6A82C2F87EF842B8EAE642F4D5CD4270818842BC435B4388572B40B36E22C35CEDA7C2C27667C28826A941503CFEC0A419F0C15D9F46C270D4ABC230B79241317BF3C2ACC4CC4159DE91C20CD9DD42CCC4B941C2E32F43360AA9C2E7A3DDC27BE1A042E67468C28DEFAB42D62260C2F0DB33419BCE7EC280B39EC1C8653942087D3043988187425E88DFC2F0C47EC1C5B9D0C11064E3C002065343F46977C26C1CD0C2FCC680C24149F2C272F75FC1BEB21443480295C2345224C244D20142CF18974260C320C080DDD53FA0A2274220578F403AD69EC24C411FC39008A8C21475CA41382F0CC3054D14C3FC5843426F432D43B08ACE414C9CC1C125D68B42F6391D434C4DFD42F055D4BF1EB84242919A8E42A0B1A0412FFB97433B22C9C25E5139428C58A24114D50EC13A7B06C2D666B341E8109F40D65ACEC208418BC1804F49409B3FC3420AA1434290A0D9C2367B28428001B5C1DC674F42BC960E43F6409BC16430EA42E372EFC0EB79F84294184FC2F06384C0041E1543C49F8B402CE89E42A28D6C43CA9FA9C1D7150AC39D5CB0C2664F4AC3A44961C2F834FB40FC6552C2D4A0ABC236D3BCC2756DC1C2907C10410FC79B4229DEB142081E86C1259EE0C234C553C2E0691943CED17D429AAED2C261B7FDC1133A1A43BB0416C31E6D98C23360F54122090C431E99ABC263E7344200614143708B9CC19CFA65C2CA72D6424E825342C6BFED42E858DAC26E60FA4285E98143E1EB0042C4779AC2E4B067C199568B4268761E434E6CBF42B0110A41C4B28AC2B8DB034244E02E4320C6C4421FE097C3CDD024C37C4C9EC314E7E5428AF60D42FCA70D42236C9EC2E4B7D7C148E8CDC2EA185BC2ACB12E41EFDE9CC282441D422CDB40C3466637C2F08970C2C89ED741995B54432A6936C38A7F1843AD7667C2D018D741A9A8BD4235963043C83FECC2F3991F436A6CA842F6EE6BC2007E88C2428F87427E1090C2E0E643434CAC1E42FE7369421C42E44140A2F7C1966498C15000F8408196DD417CE13B41194B0BC3FE940EC39725D142FE0FD3C2E6A325C37A3220C34869334111E9264356F1F5422C76ACC21097C9C1B26C04C232FAF4415006FA42BF97EE42926491424809834104F80CC299B886425B910143300B83C284421B43994B0CC2E8A85EC200E69EBE9071B6434A8BC8C2DC22E642B4E090C2C4D6D0C228EC8FC1C89301420C7E7142634D52C3A459C3C2C8A223C2C250A0C2178C55C2B22C81C1601BC2420485D441DF2369429D0812C2587FDF41022902C36844D8C2F3F68EC316E4A241E08711438FFC09C25B3E19C2D66604431C8064432AAFD24280592E410C04A7425068B2C22597EEC2ECEE0DC30813E74060BCDB428E25ED42000E5DC1C8BA19C3C453B0C22CF07B41D8FB8342944C1B42733CA6C29FE25FC21B110AC3EA6B8A42EB3514C30C43A141C80226C358CC58C122A312C2B967A3C220DA4AC29ADD04C240D15A4310C315C2F57F30C2DFBEA9426E139B4276D50FC30B8647C39A425A42CACC9FC2A16CB7C28004A43FF3EB05C29EF79C42587616C2E032904255B459438AC4E84250B83CC11631C4C2"> : tensor<2x3x6x6xcomplex<f32>>
    return %0 : tensor<2x3x6x6xcomplex<f32>>
  }
}

