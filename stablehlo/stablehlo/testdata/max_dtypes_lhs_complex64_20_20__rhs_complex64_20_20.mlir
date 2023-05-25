// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.real %0#0 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %3 = stablehlo.real %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %4 = stablehlo.compare  EQ, %2, %3,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %5 = stablehlo.compare  GT, %2, %3,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %6 = stablehlo.imag %0#0 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %7 = stablehlo.imag %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %8 = stablehlo.compare  GT, %6, %7,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %9 = stablehlo.select %4, %8, %5 : tensor<20x20xi1>, tensor<20x20xi1>
    %10 = stablehlo.select %9, %0#0, %0#1 : tensor<20x20xi1>, tensor<20x20xcomplex<f32>>
    %11 = stablehlo.custom_call @check.eq(%10, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %11 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) {
    %0 = stablehlo.constant dense<"0x2862CDBE4433843FFA5E8C40169ED2BF6AB7D7C0CC6FB340721754C033F8483D7A098CBF607610BF6811773F9B0E18C01BF7063F226C2540F4AFA13F7B015ABD6E58B03FEB41B53FFC20223D39AF9DC04E20AA403EC01CC06B6BA1409C711D3F162E13C0FD1264BC87D6513EEF3E34BFDF3C68402044C8401FF983BF9E7CA5BFB54F343E4F0E8AC0B9E1A8C04FB2C5C0CB3AA7BE8024E23FEF4375BF6889EE3FD8753A40E07F8640FDDFBC3FB0A36F3FEEA7AAC0D1A34240185858C08EA4943EE34F4CC09AB6A240933C99BE6302D5C0BF07D2C0260CF53FBC13A6BF9885D83FE0AF4EC0992463BF05A11FC06EFCC3BF67E089BF8C8C8D40384B0140397A7CBFA70E393F126354404E49D63E4435EABF945B9A408AB784C0CFFD81401D84F140DAE78ABF8B54F23FF27B0940D9582C40F9A16A3FFE43783F5CA228C1A55E574005318B4036D7EE3FE3EF853E32F8B63FA6AE013F25AE9F401AC14F3F8BE7A4BE2E220DC09D3C87C029666740A11093BFEF9B1840A0884AC0577D50C09F6B5740DB03B5C0268C493F9C2CFCBF5CA959BF95A515C18729CC3F41CAB3406D8C1440A619E9BEE14D0440F97E12C041AFB4BF4356C83CE030B1C02333D0BED20E283EDA1A62C0613C1940E1E0943F034EA4BE2AFF983F220F9DBF84CFD7BF444BB1BF33D7C3C0D0F988BF00EF7B3F7789C83F83462B40BD58F0BF8D7C9B401DB353404139503F1027AC40B21C1EC018D4674078D413C01C0D2BC09503D13F9B08AE406F3FC8BF39C9883F0DAF194066BE0BC027C881C06EFA1B401357D6BF7FE8FEBFDD1686C0D4700F4016B613C08D5BA5C085326DC00A3D37C000C035C0AA4C95C0D2A5054198F3FDBF557CE53FD59E57C0A01A09BF0D8C79BD23D28E40820E2FC0CC2539C0CF071D406E08A2BD5E21703E002E5BBE67D13DBF51697DC080BB19C0325B84BFE1A2AA3F326CD83FA9EAEBBFC6BB08BE6C30224001E6D940A898293E88549B3D9A5C50C015D2CA3FCE1003C02C2FCE3FD11DDB3EE24D073EEB00D2BE4D6889BE2B2B3BBF99988B3F2AFB68C0B8AC353F3D1BB93F2DF9004073102FBF30CC3ABE4294C4BFC0117AC0D14FEBC0BBB2BCC06EB28FBFBAB7C13EADF7DC3F1002D1BF848963C03B270A3F24942B40272594BFA3C671BF4CC2DDBD45F6B1BD0F7A14C011A281C0468DD2BF5AF1EEBFE3D39440104851BFA62881C069B44AC0DE1FBF3EBFAE8040CC2D5040388DAB4045303FC0895B31C0014C043D70B20E40BCF9FA3FDF271FC0E1179ABFD8C2F4BFA968C13F9D5FACBF3F1B86403DD63AC0A290B1404F74BF3EFA2A33C02D49A54022B4683F7DEB5BC0CDC694C0C9DD05C0CB841CBF0EE19FC0EC480A3F0FAAAABF9F2A7AC06C6E2C4039672DC0B179A83F9848FCBFD45D18400A6F64400742843E986140409909AE3FDD679B3F71706B403BE5E1BF9C874FC068980BBFC73C27C08EF8CC3F84D6193EB78CC1402147DB3E467BEC3EFB8528C0F6F284403DFA013F13538FC07CBC733FA8928540DCCFD8C0026A7D3FBC011A402F50F43F8C3FD1408CD0AAC0AECDBC3FCF4446403BED623F0EB2463E371525C0AB1346BE4D0DE03F2D40C2C0209FBAC0192B11C0A89B8540AB8518C03AD6B1BF83C5E8BF0BB3C13F531D0B3F88C0A6404F8CE53FBCE5ADBF5F983740A8A9B2BF98D490BF49066940EAA73EC0F2C07D3F976564C0018987400AC0A54080FC36C055EDBD3F947B1ABF04840B40D35E364032666D3FF0E68D3F26B8B340081ED23E5697E4C0BBF710C0B9410940B9FCD74016FEF33F7B17E1BF65C602C0DC25CE3F90D63440650762BFBEE6F73E58636D40CE833BBE866025BF8C20BEBF203E08C12AEF0B4001740FC06AE886BF24F2E7BCB114EC3FD737BDC09D93C0BE72414D3F01BF0C400EA8F7BF0F5C09C0678BFBBFEFFA15BF7C43894026ACDA3F4B74D33FB50450409B2B40BFF58B9DBE6AFDE93FCCFBFCBF7F3695C01FF342C0549F02BFA4DD26406F872FC035D303C05E3C0040F093433FEE141F40490EAA4030A9293F69105CC0EC16333F30698340F1E80B403289D33F0CBB813F3450D53FB2C2A2BFE75556BEB55EA93F8E5685BF5648C4C0B557C13F97F7AD3FC4C7E23F6B70A0405654514004E9C93F81ABE6BF06B2CB3FBA70883F4313D93FC49C3AC04E5F2740697B07C0144A01C0F80A0640629C5B3FCE8439C057468DBF996403C0E71A2A401AA8B6C0723BD53D42E79FC0BAF8E73E44123C40D4E9CF3F524709BEE8D93840F4EE0040EA31464061CA11C0069FA4BEEAC193C0CF6F054025D5FB3FCF3C883E7B9E4940107A8340A147433FFE85294073403DC0885F50C098EF24BEA857CD3E2DF310403270D8BF34738F4027A0A3BEB17192BE88EE8AC0A81C7CBF629C78C0CAD40D3F5E0E7D404510C7C01F0384BF18806940DE12C2408733C53F65D91EC07EB10A3E33F1863E786111C059BF824053BCC0BF2F6417BEB71A893C2649F53FCBFC8EBECC4E01C00EE89A40F99A7DBFCAFB2E4084A9D23F09B0C1BE2408153F05321B40EE3C7240DF47724060C91840A156A2C0E52500408713C13F019457C053A102C0FA3783C0E9288DBFE59809402C9B6C3F8B520CBFE847C6409D090A4068E522C0AA4E0FBE2742703F71DA81C0D00D004133F7C2C0E17F59C07C72C3BF9960D13ECDC84A3F350FAB3FA3B4DD3FB69D75BF7BCD8AC0D86139BF3FE25BBE52420A403A32F0BE5B0886BF4B6E11C03BC60FC006809ABFF24ADEBFD2EF3B3F4F9F6740577D763DEB605A40B7D9673F7A8D70405FC30A3FA119E0BFD39FFB3EA3883BC0766155C07D739940544B9BBF01F506C0E6FD894032541B3FB4779740CA547940E0325A4081D032C0FCAEA8406E25D3BFA400B9BD069B25403B4481400F6DE1BE018D0C3FD75503C07972063F60E52B3F0D1D4FBF2835413F68A23C407C991A40EC1392C013440AC092A4803F112CECBFEC07AA3F04DE594016B023C0B74ADB3F59BA0C403BE3863D68481EC0D11EDB3FEFC92DC0C7A2C640C242843FF1D7D240A6B1863FCEA70D402473A1BF222FC2403165063ED3A099BD3DD0D440A986BEBF9FB8604019A76C3E58E5D53F919903C01FD332C0E49FB54073461FC01D05AFC093DB10BF9C60A540AEC294BF6B0D9CBF22613F3F554F71408112B1BF235E133E92E73C3F2E6F8B3ECB1A5CC0B75260402DF979C088E2DBBE3C5E0F40CACCB8C0960F9BBF8DFEBB40EE19ABC08C91AEC0121BD43FC6D4C23FAF969FC086612640639561BFA0E2F33FC8DF76405DADE6BF2E4D45C0693DEDBFD8C04B40A41E1CC0C82E41BEC9EEBB3F754E113FD521B23FBB8BBBBE331591BF43B60640A85C99C0002C5D3F4F0E583DFEFEB03EF3C5C3408C2C9A3E63D5554071FDD5C0FE314940969FB3C0528C18BF30F7444033664FBF5265F3BF1C695BBF7C6A8140F5E149405D8A08C0D99D8E401A9105C1BD80CBBFBF2879C044EEFD3F61D1AC40ED46BE3EE630E9BE433C84400C3C5140C729204037D5363FED79E9C00A7381C0934E45BDFAD50DC0A3BD24C0C487EA3E4C8EA3C06982F33F40633F4072A584C08FD7F9BEB9ABCFC0920284C099B090403D24D23E6ADC81BFA64F963F8DE56DC0735FF7BEE69781BEB1B87FBF4E3EB43F94E127C087162EC0D52310BF051EBB3F1FA440BF211F5FC03991F13FC0B1A740BF995540900C5FC00F27FABE6D5B3C3F30FB1D4068CAA33FF60EA4C06193E43DA83E93C0A3B635C0370E9AC01999CDBF07FDED3FA343713F8602C6BFAC91D0403A9E30C083134A3D91EEFABFE41A31C0F6943DBFB14812404AD091BFB69B5CC0941D09BE89DF083F22080640AB7AF7BF62AF353F23902D40BB58843F72B6BE3F50F71D3FE593563F4D2BC7BDCFE3BE402C15F53F0DB86E40EBA67B3F13155DC0F82E67409759D03E2176784093CC173FFC0D993E74379D3FA04BC03FC3EF094089440D3FAFBB25BFC17CE9408006C8BF4B52A3407FDC3940EDFC6ABF257960C0C44F56BFDB0AF5BF8BD6134068B6A53EB4FFB03E7DC06840796DB23F5B1AEDBF840B16BD3477FE3E5AF1A0BF4B19CA3F44E839C04D0604C06C3596406CEB834048A4403E49580FC0808F573F12DF09407ED1B7401559413F43A81AC0A9CB7A409783C03FAF33C2BF8300D9BFA7FCBFC09A9D20C0AC63CA3FBFD04A404369BABC61DE1540474E81C06396C63FCD6A23C0809CCB3FB0B1C2BF1EC3AB3D64AC0FBCA10B2B3ECF260640876F493E8F9614408192E3BEEAD4FC3DF78B67C0ABC08D4007C0F9BFC5D9F1BF1779933F2D6EEF3E9DCD2240A285F3BEC8857B3F966469C0962DB83C732004C087455C406729C43D88EB25402A2CB0BFDEB9BDBF7A3A89C01175B540A1F108407458A240DDBFD93F99B3E93F2A4F2C4041297D4028C56C3EEB0319BF542F924006A563C0085CF53FA069D2BD8E866A409E1D803FF852C6C00CE88E3FBC7D414093EFA4C0E19A50C04BEB1CC0DDBD2940F2C13BC09232423D61D2FB3FFFC71E40"> : tensor<20x20xcomplex<f32>>
    %1 = stablehlo.constant dense<"0xDC7EC13F486F32C004C34E403CA0AABF3D2BC33E333D4DC08006E9C068AC62C0BC3398BEF4EB403F23FEC540D136D440CE2287C0BEC6EA3DEC2F0F403D9A51409398C33F653A50C032B0A53E45FAECBE6C891840189FB83FED020F3F7099AABF2DDB8FC03A5CF4BFC7D9784008AF093FD1F097C04CB976402D68A73F8D18C13F711E24C06A2D20400CC3F6BF37BF2ABFF2C33E40E57873C08245C03FC3C81F408C52BE3E0B24913FCBA5E1BE230D3BBF61B9893FB6A8DC3F3C93AB3ECCA7CFC080383FBEF9C508C01F039240F69129C0180A364002DC883E42F7CCBF7EF6C4BFCBF5EA3FAF3F7B401B29F5BE3B1286C0F0D10540BCC1413FA9669DBFD6C1FCBEDC48793FC71D19C06EEC59C05DEC5B3F2C7105404A3102C0035D94C049D86CBF60F42DBE9B6125404ED08BC06E2A95C0FBBE3B400EC018BFEFEB1E3F5A9FA4C05FB8953FADE5864028A886407B8CB3BE6C56943F5944C0C0767A6FC0825BBA3F7FC932C08B0B03BE079436C0CE5E8B404609B0C0F6DB9BC033EDF2BE1234CFC0D160253F5B01E83E814467408D1C943F6552B1BF2848C4BFD6C9B7C050EA02409321FFBEB4C68CBF5BAFEC3E8B4E43BF52612E3F006E9E3ED040E33FE5C0313E9CC0C5BF48B376C06A1001C03FEF49BF8EB283C0F9F880C00C46874085FDC9BF4B07853E982341408B75BF3FCA1A5940BDE69DC04634A0BF6E7E7EBF655BC63ED594893FE3D6C7C03942ACC07C359940EB840BC085255CBF24FB4B3FDAB59CC0507E54BFE01F033E7EE5B9BEBF2A7FBE5F104240D8AA18C039E81FC049A75740A65D1E407A8D82BAEC219140FD777EBD06DFF1C0E4E9A840E361A9407C381CC0257A1740A4BAAD3D40FCCDC0CE4CCDBF52D0C0C002BBBBC03C7ABDBF5DF63EBFB64221C0B54E5F4056D680BF911E22C0A4AABD40D0BC7C3FCE6E153FCDAD66C0B7A9CDC0DF6B243F2431F83F8771F7BF6071033F49CA25C0048F09409BECAE40120D2FC0080A3440E86ED4BF1A76ADBFED7919C040FAA0BF307679404FEC9B40CC8741BF8F5F8AC04B425DBE1249F83F25972840354CE3C0E752F3BF3D6103C0BA8D7E3F599CA540A87FC0400CDB7C3F519E41C00F1B86C048D84EBF67B22340FF671341C04615408103BF3FE8C506401A010A403EB1FA40B94EA13E4BAA8640DC5DFFBEBFE6E5C0F88F40BE5FAA04C097E28C3EBF83BC3E2AAE2D4035294D3FDBEB703DB330A8BF00EE5640F4E28A40644A85BFB1BA2B402CF2CF3FBDB283C0BB413E403627F8BEE56201BEFD18A1BF3C3F4F40A176823E75AEA2C052692640893F98C01BD8ADBD4F32BF3EB860903FD0F5ED3FEF0296409C4CB94047271CC0085F92BF6E1C18BFD3DC413F944153BF89048CBF71263DBF370851BF5BB9E63FA10074BFA86AB4BF8A62FDBEBE79A83FF69E0C406408B240041DB2402FFCAAC0974805C0350BBDBFFCCEAFBFD92FE43F1C8877C0C62CCCBF229B5EC0E192923FCAC4F33F1B593D405F36C24059A7863F08BC45C01554A7C0D69F873E212F55400F5AD93F4F7E9940196089BF17A2AEBC77E0DC3E4CDF59C03BF0A440E706B33FA19D31406DFD92C06111DB3FF00AFBBBA8439FBFC217AABFCF58393F57AD82400C09A1C0E8392740F2F8A43FD25E1240CD8A9A405B745440E7F67E3E829F82405F0086BFA86A1AC08A2692C0653EA53E0BC4603FBF835BC0E6E3C7C080F318BF15AB75C068E292C038C63840D5D5994016C7C2C0708B39BA24BE1FBF7FEB4EC0389F7740E0FA85C05D720BC0DD321FC0C4E1B93F487F203FCACC3B405BAD5E3EDCF0F13F7596DE3F357F1D40F3FA84C061D9BBBFCA9B164032FE8340A8AB2CC0A9A366C05949AC4085996A40F899CEBF71730040FDC70940F718CABF3BFB93BFA6112140160A623E61CE09C0F35E24406F9907404638A9BF6846343FAB328DC0167AF0BF8346B7BF12C3C93FB153EDBE3C60803E35624A3FA4A01F3FDC5675C00A7796BDB761F4BF2EFEAD405C104B4081204ABE95B880BE512F3E4071380D3FC7B8D93F260B773F47BF6DC0555E2E40A0BA2040FC543EC005BF7FC0CBF31F3EE409BFBF80F2B23FCF312FC0656F4B3F932206404C504D3F07A034C0C6D57040270F1BBF5A69923FB96BF7BF732154BF3E721FC032854040C980C1C0583494BFFEF080405ECA9BC07B8E33C023F1A4BE3420353F9CD3DC3F8A2DE63F8D0560BE232823C069D74640FF80843FA3D59CC02C80C14017684CC0C987C3409278F2406755E2BFDB4FA9C041F54BC05CD87E3F6BACA6BF3594774073CE31C0E3A58AC0FD934BC00C87284091C9CA3E22C9494075929AC02AE6963F411ECEBFE98AC7C083DA52BF758F6BC01FAC07C01179F63F6E5D0EC0FA6D253F4B440FC09AD1AEBFA5988B404BFA263D7474F33DB2455B405F14CCBF320445404314D63F72B2B0C0377BA7C08F5FF9BEB59A14C1F4C1DC400D4C263F412D27C0289E16C0A34B9FC03F39154045E1973F28444BBEE8D3004023243540B07FE23F97E6BAC0DC9F88BCB8C82B4012DB82BD427E29C030B75E4072AF924089DFBDC02E2508C003B9A3C0ACFB5940B27CB040F8E6483FA03A68BF55CCE040D7881D3DEA263BBE175D0D40E84128C020259FBF37B3A6BFB670053E32C267BF15DB6240A3948A40534A963E0812B740B3FC72404DAEB83F04BAC9BFAF33CBBE9D55C2BF88433EBF76DBBBBEA07B2ABF83037C3F0235814095540B40074D81C033A173BFEEE2F9BD3F90D0BFEBBA6B3F63E90FC0EFBB05BF28B0A83E635A9DBFCC6BF9BFC167E43F1EE0DABFBFBC0940FED379C0F10165BF3FF576C0BA7CFA3EBF0C3640CDF491BFF622F2BF242860C051194340BDB368C071082B407FB0AE3FAC9C06C0E54746C0E09430BF1CB386400BD31E40C8FC2DC081EC8D40106F03C0C430044096AA35C0FE1880C05211F2C0FE5B213F4CBF20C03C683E404F63A44077A61440765F773F83CA6240E5EE2EBF55710940CD48D8BFA6CD18BF448C143FBA0F0D3EB4D4DD3FC4F9C4BF314BB3406F9781BEF3409240E3B8FA3FDD88053E22C93CC01E38FE3F025793BF5946F43DEB2DA640B90E483F1E04843FD12085C0A85867C0880D73BF9321474031F9404068B1ACBF0CBD1BBF2AFDC6BE222A8A40C10ACB3F18123C4085AE453FF69C683F2DA69F40D9A8763F2A460B4015DF8CBF0E5AABBFFCA1E6BBC6B73D4042C268C0776C8CBF2FFA60C046ADED3F4D4DB4BF05AB8E4067F844C165E490BFD76632C003E656C094F28EC020D83F40C49B8DC0A6B183BF133209402F4643C0C728CF3FF6D81AC0F4D5B5BF8F06A64001D6663D0F9A91C0E5B803C0273F073F29E32F3F59A30FC038FC8BBF8BF4A540268E3DBF102D8840728E3A3F367EB83F36EE1040DA0786BFC3898940F8998EC0BDBB15C0A566E13B0FB30EC0637763C0683347BFDFE8F9BF790BCEBE3AA29CC0E72D9DC0D6B2D13F094C26BF58D08B3FE6EC3C3E60754B40CE758CBCDF028EC074CC4AC0CB86D3BF2E9907C04361C23C6E2A394068E30540A60861C0E85E2E3E193810408AC529C09C303C3FC3BFA040DD1D86C0314079407ADF763E3261FBBE106E17C03EFBCD3FE0375EC04CDA9B3FC0C767C0FAF9AEBF9556BCBFBC52E540F25681C0894404BD867389BFE74634BFA5F3E53F939F1AC024CC62C01B25A0C05FFF29BF89ACA4406511E7BF0BEBD7C057C91CC0FBFE23C00DD5AA3FEDD99E3FBB768BBF12965EBDCC6B8BC020E9EEBFE25E42404B268CC06DA268BF3C5ABC3F9DC194BF5B2770BEDB4D0EBFA54560C001A9F9BFC2CC283FA72C1E40BD0EBB3F2AD89240645EDD3FBFA9F53E28D4864053BC064080DF08C0DF402B40B48E48C07878083F363695BFD99D15405677763C1C38ACBF4A645C3FCF075EC04F9BA440397D8C40E8200AC0FC3341409D3D1A3EC0060F3EADADC13F48A9C9BF50962EC0019065BE1595B4BF5849B9BF5ECD6240517F50C0EAA63ABF70598EC093FD3040FCE5FF3F83A32340184D2D40A8007040DC5B85408875D440F62950C0DCFE13409A4DFE3F5480EA3F6FD61F40D66341C0C7549AC021399240CD639D3F9D1989BF469A3C404C4CF13FD974D53FD181A6C0A082B73D29086D4072A72FBF504E6440E34301C09CE21F4031DB8FBF0CE100BFD2F9FCBEF1BB7B40EA577A3F7C8A69408C5A8EC007931ABF5CD73CC0E8F2F5C082FA1B40542A1AC01E769C400475D63FB22D82C021FB1940035711C04670BC3E557C6C3F2DB19E3FF545E9BF82D72CBEB200ED3F9D73A1C0842084C0E32FA9C0FD024CC058267BC088244640C08BD7BFC9F1E9BE6100AD3F0B9D8C40155BC93FC41CDA3E0F1398C0D16394405EF895C0617D28BF668E6940F4B7E4BF66152E400585B640E3854BBF4B710C3F3BA55340A992AE40956ECB3F5B2E0840BC37A6C08761664022153940592D1440D3047CC0548951C072FF8CBF8FC1D93F275CA23E2C5A43C0081B1F4091EB40BFC81BA1C01280423FE58B8F4056294FC078628FBF"> : tensor<20x20xcomplex<f32>>
    return %0, %1 : tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xDC7EC13F486F32C0FA5E8C40169ED2BF3D2BC33E333D4DC0721754C033F8483DBC3398BEF4EB403F23FEC540D136D4401BF7063F226C2540EC2F0F403D9A51409398C33F653A50C032B0A53E45FAECBE4E20AA403EC01CC06B6BA1409C711D3F162E13C0FD1264BCC7D9784008AF093FDF3C68402044C8402D68A73F8D18C13FB54F343E4F0E8AC00CC3F6BF37BF2ABFF2C33E40E57873C08245C03FC3C81F40D8753A40E07F8640FDDFBC3FB0A36F3F61B9893FB6A8DC3F3C93AB3ECCA7CFC080383FBEF9C508C01F039240F69129C0180A364002DC883EBC13A6BF9885D83FCBF5EA3FAF3F7B401B29F5BE3B1286C0F0D10540BCC1413F384B0140397A7CBFDC48793FC71D19C04E49D63E4435EABF945B9A408AB784C0CFFD81401D84F14060F42DBE9B612540F27B0940D9582C40FBBE3B400EC018BFEFEB1E3F5A9FA4C005318B4036D7EE3F28A886407B8CB3BE6C56943F5944C0C01AC14F3F8BE7A4BE2E220DC09D3C87C029666740A11093BFEF9B1840A0884AC033EDF2BE1234CFC0D160253F5B01E83E814467408D1C943F6552B1BF2848C4BF41CAB3406D8C1440A619E9BEE14D04405BAFEC3E8B4E43BF52612E3F006E9E3ED040E33FE5C0313E9CC0C5BF48B376C0E1E0943F034EA4BE2AFF983F220F9DBF0C46874085FDC9BF4B07853E982341408B75BF3FCA1A594083462B40BD58F0BF8D7C9B401DB35340D594893FE3D6C7C0B21C1EC018D46740EB840BC085255CBF9503D13F9B08AE40507E54BFE01F033E0DAF194066BE0BC05F104240D8AA18C01357D6BF7FE8FEBFA65D1E407A8D82BAEC219140FD777EBD85326DC00A3D37C0E361A9407C381CC0D2A5054198F3FDBF557CE53FD59E57C0A01A09BF0D8C79BD23D28E40820E2FC0B64221C0B54E5F406E08A2BD5E21703EA4AABD40D0BC7C3FCE6E153FCDAD66C0325B84BFE1A2AA3F2431F83F8771F7BF6071033F49CA25C001E6D940A898293E88549B3D9A5C50C015D2CA3FCE1003C02C2FCE3FD11DDB3E307679404FEC9B404D6889BE2B2B3BBF99988B3F2AFB68C025972840354CE3C02DF9004073102FBFBA8D7E3F599CA540A87FC0400CDB7C3F519E41C00F1B86C0BAB7C13EADF7DC3FFF671341C04615408103BF3FE8C506401A010A403EB1FA40B94EA13E4BAA8640DC5DFFBEBFE6E5C0F88F40BE5FAA04C0E3D39440104851BF2AAE2D4035294D3FDE1FBF3EBFAE804000EE5640F4E28A40644A85BFB1BA2B402CF2CF3FBDB283C0BB413E403627F8BEE56201BEFD18A1BF3C3F4F40A176823E3F1B86403DD63AC0A290B1404F74BF3E4F32BF3EB860903FD0F5ED3FEF0296409C4CB94047271CC0CB841CBF0EE19FC0D3DC413F944153BF89048CBF71263DBF370851BF5BB9E63FA10074BFA86AB4BF0A6F64400742843E986140409909AE3F041DB2402FFCAAC03BE5E1BF9C874FC068980BBFC73C27C08EF8CC3F84D6193EB78CC1402147DB3ECAC4F33F1B593D405F36C24059A7863F08BC45C01554A7C0A8928540DCCFD8C00F5AD93F4F7E99402F50F43F8C3FD14077E0DC3E4CDF59C03BF0A440E706B33FA19D31406DFD92C06111DB3FF00AFBBBA8439FBFC217AABFCF58393F57AD8240AB8518C03AD6B1BFF2F8A43FD25E1240CD8A9A405B7454404F8CE53FBCE5ADBF5F983740A8A9B2BF98D490BF490669400BC4603FBF835BC0976564C0018987400AC0A54080FC36C038C63840D5D5994004840B40D35E364032666D3FF0E68D3F26B8B340081ED23E5D720BC0DD321FC0B9410940B9FCD740CACC3B405BAD5E3EDCF0F13F7596DE3F90D63440650762BFBEE6F73E58636D4032FE8340A8AB2CC08C20BEBF203E08C185996A40F899CEBF71730040FDC70940B114EC3FD737BDC0A6112140160A623E01BF0C400EA8F7BF6F9907404638A9BF6846343FAB328DC026ACDA3F4B74D33FB50450409B2B40BF3C60803E35624A3FA4A01F3FDC5675C00A7796BDB761F4BF2EFEAD405C104B4081204ABE95B880BE512F3E4071380D3F490EAA4030A9293F69105CC0EC16333F30698340F1E80B403289D33F0CBB813F3450D53FB2C2A2BFE75556BEB55EA93F932206404C504D3FB557C13F97F7AD3FC4C7E23F6B70A0405654514004E9C93F81ABE6BF06B2CB3FBA70883F4313D93FFEF080405ECA9BC0697B07C0144A01C0F80A0640629C5B3F8A2DE63F8D0560BE996403C0E71A2A40FF80843FA3D59CC02C80C14017684CC0C987C3409278F240524709BEE8D93840F4EE0040EA3146406BACA6BF3594774073CE31C0E3A58AC025D5FB3FCF3C883E7B9E4940107A8340A147433FFE852940411ECEBFE98AC7C098EF24BEA857CD3E2DF310403270D8BF34738F4027A0A3BEB17192BE88EE8AC0A5988B404BFA263DCAD40D3F5E0E7D405F14CCBF3204454018806940DE12C2408733C53F65D91EC07EB10A3E33F1863E0D4C263F412D27C053BCC0BF2F6417BE3F39154045E1973F28444BBEE8D300400EE89A40F99A7DBFCAFB2E4084A9D23FB8C82B4012DB82BD05321B40EE3C724072AF924089DFBDC02E2508C003B9A3C0ACFB5940B27CB040F8E6483FA03A68BF55CCE040D7881D3D2C9B6C3F8B520CBFE847C6409D090A4037B3A6BFB670053E2742703F71DA81C0D00D004133F7C2C00812B740B3FC72404DAEB83F04BAC9BF350FAB3FA3B4DD3F88433EBF76DBBBBEA07B2ABF83037C3F0235814095540B405B0886BF4B6E11C0EEE2F9BD3F90D0BFEBBA6B3F63E90FC04F9F6740577D763DEB605A40B7D9673F7A8D70405FC30A3FBFBC0940FED379C0F10165BF3FF576C07D739940544B9BBFCDF491BFF622F2BF32541B3FB4779740CA547940E0325A407FB0AE3FAC9C06C06E25D3BFA400B9BD1CB386400BD31E400F6DE1BE018D0C3FD75503C07972063F60E52B3F0D1D4FBF2835413F68A23C407C991A40EC1392C04F63A44077A61440765F773F83CA624004DE594016B023C0B74ADB3F59BA0C40448C143FBA0F0D3EB4D4DD3FC4F9C4BFC7A2C640C242843FF1D7D240A6B1863FCEA70D402473A1BF222FC2403165063E5946F43DEB2DA640B90E483F1E04843F19A76C3E58E5D53F880D73BF93214740E49FB54073461FC00CBD1BBF2AFDC6BE9C60A540AEC294BF18123C4085AE453F554F71408112B1BFD9A8763F2A460B402E6F8B3ECB1A5CC0B75260402DF979C088E2DBBE3C5E0F402FFA60C046ADED3F8DFEBB40EE19ABC08C91AEC0121BD43FC6D4C23FAF969FC086612640639561BFA0E2F33FC8DF7640133209402F4643C0C728CF3FF6D81AC0F4D5B5BF8F06A640C9EEBB3F754E113FD521B23FBB8BBBBE29E32F3F59A30FC038FC8BBF8BF4A5404F0E583DFEFEB03EF3C5C3408C2C9A3E63D5554071FDD5C0C3898940F8998EC0528C18BF30F7444033664FBF5265F3BF683347BFDFE8F9BFF5E149405D8A08C0D99D8E401A9105C1094C26BF58D08B3F44EEFD3F61D1AC40ED46BE3EE630E9BE433C84400C3C5140C729204037D5363F6E2A394068E30540934E45BDFAD50DC0193810408AC529C09C303C3FC3BFA04040633F4072A584C07ADF763E3261FBBE106E17C03EFBCD3F3D24D23E6ADC81BFA64F963F8DE56DC0735FF7BEE69781BEB1B87FBF4E3EB43F867389BFE74634BFA5F3E53F939F1AC01FA440BF211F5FC03991F13FC0B1A740BF995540900C5FC00F27FABE6D5B3C3F30FB1D4068CAA33FBB768BBF12965EBDCC6B8BC020E9EEBFE25E42404B268CC007FDED3FA343713F9DC194BF5B2770BEDB4D0EBFA54560C001A9F9BFC2CC283FA72C1E40BD0EBB3F2AD89240645EDD3FBFA9F53E28D4864053BC064080DF08C0DF402B40B48E48C0BB58843F72B6BE3FD99D15405677763C4D2BC7BDCFE3BE402C15F53F0DB86E40397D8C40E8200AC0F82E67409759D03E2176784093CC173FFC0D993E74379D3FA04BC03FC3EF094089440D3FAFBB25BFC17CE9408006C8BF4B52A3407FDC3940FCE5FF3F83A32340184D2D40A8007040DC5B85408875D440B4FFB03E7DC068409A4DFE3F5480EA3F6FD61F40D66341C05AF1A0BF4B19CA3FCD639D3F9D1989BF6C3596406CEB8340D974D53FD181A6C0808F573F12DF09407ED1B7401559413FE34301C09CE21F409783C03FAF33C2BFD2F9FCBEF1BB7B40EA577A3F7C8A6940BFD04A404369BABC61DE1540474E81C082FA1B40542A1AC01E769C400475D63F1EC3AB3D64AC0FBCA10B2B3ECF260640557C6C3F2DB19E3F8192E3BEEAD4FC3DB200ED3F9D73A1C007C0F9BFC5D9F1BF1779933F2D6EEF3E88244640C08BD7BFC8857B3F966469C00B9D8C40155BC93F87455C406729C43DD16394405EF895C0617D28BF668E69401175B540A1F108400585B640E3854BBF99B3E93F2A4F2C40A992AE40956ECB3F5B2E0840BC37A6C08761664022153940592D1440D3047CC09E1D803FF852C6C08FC1D93F275CA23E2C5A43C0081B1F4091EB40BFC81BA1C01280423FE58B8F4061D2FB3FFFC71E40"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
