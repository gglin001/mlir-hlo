// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.real %0#0 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %3 = stablehlo.real %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %4 = stablehlo.compare  EQ, %2, %3,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %5 = stablehlo.compare  LT, %2, %3,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %6 = stablehlo.imag %0#0 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %7 = stablehlo.imag %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %8 = stablehlo.compare  LT, %6, %7,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %9 = stablehlo.select %4, %8, %5 : tensor<20x20xi1>, tensor<20x20xi1>
    %10 = stablehlo.select %9, %0#0, %0#1 : tensor<20x20xi1>, tensor<20x20xcomplex<f32>>
    %11 = stablehlo.custom_call @check.eq(%10, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %11 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) {
    %0 = stablehlo.constant dense<"0xD1C6ADBED70B1340ED968CC0C1D380404E1681C01D238640A15187C0D8A27F406272DA404ABE37C05C6C773F2D009AC0245DE6400BD1B5407E2F1EC0369B213F9A520640938206402CD770BF97240E40B5426240F6D5CABFBC0627C09CFF12C00C7A8ABDD7611E40B20FD63FA1FC24C02AA69B40BF31D8BF72B9573F41C621C0C497FEBFA9D8073FEA23F5406B66B1409FE898C05B1AD9BF4060BD3F6644DABD39BC873E9D825140D84377407BE4AFBF016980BCB687A1BFA292B3BECE3CB63FEFD0FBBEB82B94BFB7714E40D16105405D1E32406FB50D408EF6143FC70980BF68B101C0B2135F40E0BCBE3FC36875BF947615C04CFB37BF567DB6BE7E07943F07391E409AC7CC3FF5C26240D6DF19C00C3ECFBD3D541A3FAFE7B840175E2B40437F7940017D0240F02994BFEC3BADBF5D0D73404AE4DF3FF7211A40B985DDBF9130BDC0A159D9BE4075DDBF1D870E40EC9F48BEC1154840C309E7BE6C26BCBEA715603F7932AF3F96C0A84004E6DABC7D2321407104C6C0BD9CE43F886818C1A9BA98BE96E59DBF7635324053ED953FF991B53F834F8B402B4B0AC0F26C014099EBD9BF02E05D3FFE74B1BF4FEF52BFEAFC8B4098CB12C0048CB03F9B747FC0EB4601C099494FC09EE75DC0D70CAFC092B4C03A89D4EB3E1E45AC40AB65CE3EE001303F4EFB81BF395D9140AA3E12C0D3C3C23F532D9D40F6639BC0B3E42FC0A05A09BFF74721C05505BDBFA46AD53FC17940BECCCA614047578240103F653F1B7B733EC3321240804494BF40BC453EE46CBB3FD7EB0E4083388340A61F40C08FFB4F40DFCD8DBFB7DA013E77D3F5BF9A00F3BFCE3920BDBDEEBEBFCC59A3405583CAC04CABAC3FAFCFCB3FD991044068191140D8D1423F857B45C0E43E2C40161491BF78159B40C71713BF00EC66C0351626C0FD740840A2841240004404409EF35F3FEEEC28C066DFD3C0B53585C0EA84743C08C86FBFA8A7C94084E45ABE8849253ECC1EC63F8E3D263FA16CE44016FB5FBFD5CF03BF9A71BABF2FC4BDBFC1001840C0C713400F6C51BE62A3CB3F762B5F3F957D3E403BB6A0BF6AE12840218A9D402B4B7C4035FDF6C0EAE24BC082D4DFBFE5DAB93FBFB9EFBFD1953C3FC5C58D40377E863F3976124178E424C04B7E29C0D02C93BFFFF892C0294E57BFF7F10D40B64F8140749B5AC071160640C567813F6627BB3F7C307C40C7E1DDBF44579BBF6E35C8BF0185B7403A8E4DC03B3035C056D8D7BF8F1DA53EFCB99D408B7FF2C03DB93BC09B3E4B40AFA929406FE7EBBF84CE91C0DB1C51C0FA58A9BE0815803F4A3CCFBFC14AD44004D00C4006B9B3C0CA20D2BE3AAE0F40C1401140CCD02D40CE8344BFE7B5C3BF4FA825BEF77B3A3F68AEFFBF55F5AE3F948503C06431F23F126E0340518C3540817D5B40FE95C3BFD102ADC05D0E5940E5BDD93FBC6647C0E1F218C16AA80CC1A405D3BF2928B6BF2DECA040B0110D3EF60522BFB6DA0640A2C874C03AF62FC0081BE73E61D0684031CC89C062EBA7405B7A494014C69240AF2AB2C082C22A3FBC0B0640D41A3A407CB9733FE01D8EC0757C38C0807CF1BFF52A503FE169343F6747B2BF34F493C0E19C4240EF204D3FD32DB1BF3D1D6E40B80F5DBF535588C021DEA6406B94E8BFE4AD6EC0CDC061BE87CB77BFBFBAA23F997F723E775F2EC0E444FABFF98483BF727B50C0D7C0D23F285D4D406323373FB62CE1BD5584CDBE1AD98DBF4DB7C3C0F1193C3EB484C1C0AB92944035220F40AB6117C0E72EA8C045EF9640310E69C0BC148F40F80616BECA9753C0E416954037CD904020D29FC0AD909DBF617E314081796EC08C1D5B405AC7D8BF56CF34BE4F913ABE0F51CB3F462A04C0E6FACC3F1AA4DFBEB06CFDC011DB1B408D2E944086CF093F62765C404B728ABFD4B5BEBFF6C08C40F201E6BE3492E6C06FE1B53F1E19B4BF3084AA3E1D3B48400A0B953E25A838C0B6918DBFA535A8BFEC354840D95BE03E29CA5DBF51F935BF5D6315C08261AEC0AFD3373EB70D3B408AE28EBF725D5E40DF2F41C082D5DCC080A2BC3F9890173F26A1C3BF67E19CBF73554840D2001D4095F7A63F0986213E472103C14CA924C0A3EC08407EE036C01E41D1BF43D48640678002C0B861AEC01AC3BDC00E5F15BFC4B1B1C0A28E243F584005C04D4CFAC00676434026EDD83EE8590FC0C52D7D40237E333F3AD189BDC6D4203E31F28F3FCEC4E9C000874540515498C01044A8BE84D21ABF28AED0401362313FEC5030BF808146400AEB46408F6F4E3D3AB0A7BF9039A1C0AE3AAD4027E89D408AA666BFF664F8BF13F4A43FD85C53403589F8BF831F00C030D082BFA2FC9B40B7750FBEF06B8F40EA86D23F057D23C01A3B3140D54EEBBF024347BF286AC140A5947C3F2EA8213FB15FF63F471708BFEDA5043EC0D72C409F3ACD40D9613F3FBAA0393E700261C0EB6866C0C5543BBF5EBF623F00CFD33F77B71DC0A06D16BF6CD8AF3FCF3C8FC01C4502C0AB2828BFA84913407A6B97BF383E87BF5B8BB0BF4C44BABFEB03FCBF5427D53FC2F87740CE6E42BF8D36D43F1B8FBE3FCBEE8BC0DEDD8FBE6570473EC70A9BBF97D64340166DD7C0282A12BFCA4C2CBFE3BA95BF83D0C33EB9B50FC099B285BF4769F5C09B3C8E4012FEC03C52696E3F0465173FD8021DC02BD338C0D20055C059053DC0F248384023380CBF01B6423E85669540EB4560BF315F3AC0C9A8C5400F71AAC0BC68854076302A3F8A2C3840D6F403C00CE932C0CABD883E02CB183E4243EEBFCF88733D22F9803F1C7CB73FA3ED74BF7AD5D4BE1E5A2AC072071FBFBE84EC3EE8A11F409A0804406D3693C0198706BF83597E3EF3A12ABF3E6B523FEA0EAEBFB14B2BBF2807B84039A6ED3FFC58FA3F954234BEA0E980BF5DDD8B40A929A7BF0BA37E40C616DA3E074E30409DEF19402AF3853F8B67C8BF1D5B25BF85C691409B600EC05B9E63C0B8FD603F182B8C40ABB33840964BFCC0413507C01457A73E9FFD2D404401A6BF7B8F1DC014FBFCBE56FBDA3F4DB8DF3FE80EA43CBF34B4C0A5E07640EF92FABE89CA1F40C2945FC0FF0FBBC09760CB3F6A1DDABFBD2B3AC0F5F57BBE25C885BF28A12C40697321C155BA3FC0033C9A3F1BBE1B3FBE18783F0B44863C1252F03F71EF9040BA4B0C407CA422C01D0FB4BEB8A1A5402C46124043918EC07954F73E35086D3FD4A3A0BFA3FCFDBF2625FEBF86033F400C3249C0BB32DC4081F98DC0AF76CABF7498B93E7848A940174DAABFD2801DC0191E1ABFA338553E07476AC099205EBF172D2540BF3600C0F7273AC06AF41D40869CF5BF5C6E6AC009A5393F5B3F5240B4D69C4068B2B9407FEC31C011578DC058B317C0FA271540311E5A408426EE3FC4FF58C061DF204012227FBF71AD8C40635626C0E8D33C40C1079B3FC6B0C1BF77C63EBFB36F90BD735AA3C0F73562401DCB43BF0F4D233F4E8F35C04A6654BF585978BF0B078140AB919BBF3C5D193F52549CBFDA220F3FF4C4CFBF886A3940EF8F84BECFC8E9BF833424C064F342C09E548CC0F9F51140D53C3BC0AA727A4056398F3E65CB0E400A868B3DE90FFDBF5B9C9540F3DE903F434882BF7794C7BD069935BFF5B9C03F2675BF3FD6A16D40685853BF0A2275C0281B6AC0FD47BC3F411B8E3EABE2094050344340B08528BF302965C0CC6C01C0B62851BF1FF831BF5999BA40E76680BFB248803FBEFABDC018B610BFCF71F1BFA6C692C0A4DDC0BF004A2140FE2A683FB79E46BFE7588F3F9E324840024AA0BF420B274045A898BF671AD4C08DAE1D3F532BD240626CC240695F6D3F49C553C01539C33F1CDA823FFA42C04097BA6A406795F5C0D10408C0019632C059502EC0DE1E1FC0431334402EE8833E6914C2BF08CD0F3FC6EBC0BEED248FBF2F5D11C0AAE2E1BFBBCC0A40A20F38C06CA81B408E956740F324B63F991375BF1B6AB5406F3D59BF751B97404822423DC824B9BF535BB0C03CC40F40335BC73F01CE2CBCA4903740A872593F5CFE0E407BEB6640BA3CA73FB64CA3C07534C43E571E80C025EA534016AF4EC034D2E9BFBAD226C0FBDF9D402DD809C0C23E353F46AE77404D56E4C04D0A36C0E16894BEED2AE5BF667A59C0C6AF80C0026E01C0AA6481C089F89BBF2CA83EC013C44840532B30BF8FB52CBF5FE907C037CED8BF376D18BE0BC03B3F7D8A89BF782167C0B825AA400B37004065D1BC3D433E7DBFA2CB2BC0163D243F780250C0440127C0265245BFB4A62540B12BBABE84FEBABEBE7F443F135128BF9BA31E3EDF03A43F3F9561BF348A213F3974083FBA4A114052DC51C02668F3BEDF91EC3FA7655840DCBD9EBF3B328240B328F6BCC65007BFCF01B440E794093F9D79E83FAA2A543FBF73BABF2F031740F40537C00D942A40E35A46C0C7D8CCBE14C3E63F2394BC3F08E8AAC05EA8BC3F392098C04EC046BF7D9E4BC0640A97BFC8C85FC00CAC0A4068376A40ADABA7C0C99F0DC1E96984C0F94F29C02B2442BF0594EA3B"> : tensor<20x20xcomplex<f32>>
    %1 = stablehlo.constant dense<"0x3A65FAC0FFEE573FA94967C02DED1C40ED6B7840AC4C85C030F18C404B5092BE6548D93DF4CF4A40E4618A40FC8F4DC0DC85613D80D803C010D0C24052D9A93F0DFEA93FB0BCC13FB89B23C0FBCEEFBF81647F40DA99883F3F2DB33EA67296403A76ED3F3FA5B93FC86C6B3E135A1B40B3F8BF4088159DC08F4910C08729FBBF63F81540761DEC3F8ADBCDBFEF4D00C094757FC0B8D0DB405FF7A63E25D2B8C0EA6C82C0DF2ACB3FEF8E19BF988004C0BB6D4540DDC70B41DB1DCF402C729FBE35C3CABF9EC3A440C74B79401330E8BE15B1BE3F104618BFE71B133FECDB89BF019193BFF6810740073C01C0C4B21E3FAC7551C02B2F3D3E23C97FBF4B0B2040321901C0809FBFC0E407093E7E415CBF5B18104086853D40DED821404B7229C02B090740FD7A8E3FD5A28240E3E281402C9BC53E637C2B401A275BC0C0499C3FB49EAA3F2C06C2C032E45F40B038BD3FD239D140AB529B3FE819793FAE6F89C0ACF9C43FEF0DFDC0D12494BC65FB783FCC8C603E17ECD8BD6DE9D7BE997AA140F201384026E36F40764FB140D4A77AC0223D2AC1A6D41DC0C6C99940F99977C0DD2A5740BA2DFE3F280B843F23492BC030DA96C05E4F14C1E86FD8C03361C73F22AD2EC0E718D6BF5836AD3F7F1FC33FA9FF2940C2F78A40BB617340431CF6BE580CCA3FCBA5CC3FE68EC5C06F14C9BFAEE197407FB9C0BB0DF2CD3D0E3106C01E60613EE96D0F40538317C080A421406E1BF3BF00D59B3E82E3AEBFCA8F9840ED354940CE59843FE89B5DBF73AD33C0C1C31640514DDFC0A195653F2FF0573FA3DA8E4007CF84C07F21CCBFF2D38AC0197BFCBF25EF84BB4A49E13F81F2CABF41B61D3E04BB5E3FFD33F1C0D6B36340094949C03D49CC3EC4ACC2BFBCC0B7C05E8F4640B03F96C0E83B903F1E12B13EFBB74B3DCA36EBBF40E7AE40D7FB3AC0FF8E0640FFAAE23F08BB96C0340D5CC059D99F4054499CBB3833CDC01AE49F3E34BF284041373EBF394A37C0E8B4BDBFA42AFEBD731BF33FA3ADC83F2C4947C0D1DBA6C06740C8BF1C5D214091627C3F00D59D3F423C1141827AA54033C8853F7722453FF74A77C0DD2D9340A24E3840221450BF617FEBBFCAABBDBF2157874003F08DC007C3B13FE0708D3F31A9153E5747FD3F67822EBFE37E71C046792FC055E763C0118A46404B170BC0DC20F73DB0E5A7BF843904C0A5121640A7D4ECBC38B1ED3F2D70153F646F33C0099D0BC0708D0DBF65BDC03F5A35393E42893240129A24C0ABE7D43FD3370440802BC8C0D32A69C00DCD63C09404D3C0FCC55CC0C4867EBF44F22C3F508369C0B91ADFC0CC2315C0759A0B3FBEBCDC3FF57CA140B18DCE403FD30E3E9159203F38A96E4075A6EEBE5CC401BFBAFCFEBFFE686C40DC0232C06191543F16A220BF9D7DE44006F1BBBF0EE5F8BF6BA8EA3C297D49C04F449F40DC977C40839F253F625D073E966A69C09ECE18C0C1F16CBF4CCE6340EAA706C0529F683F7135A2BEDE3613400C4C563E227D6A4043DD14403E7122C0214549C08C681340EF7CF0BF9EC03E3EDFA4A140A676DF3FC7CC31C027F6B9C02BACF4C0C6CF4B403E7045406EEC5D4003C98940E126A7BE5A6A7540859362C0671737408CDC883F52938EBF13E896401EA269BFBCF56740568ED2BE3D7E50C06E20083F0EC2043F027440409F09213FD0AC7BC082C60ABFB546993F074C08C07EFF3BBF134734C0006C3CC03F4430BF500DB33E29DB5EC0D4682C40EA2B21C0F5B69B3FAB72864066D6DD40E045C43F8B60D6C03C0E333F93D6EFBF1585C43F29632240E2A78DC02F9BC540C46C6FC0702300BE18B479402A879B4047466E406108064018261D3F407160BD41F7AABF4566863FB9DF6DC0C4F391BCC676CABFF3197E40508904407331DFC052C727C0D1AC0F4014C71040CBBF32404E99453F75F1753FDA7E81BFCD9BC23F3F31703F7DCFD4BDB8364940A7DEFBBE41DFA63FC89328C061FE3BC0E663D0BF856A6C40C6D41B40D993E3BFE714F63FC742413FF6091BC0E607BFC0F74D94BFD0C4E640FD93053FA4EBA940576BD63F0A2C6540D760D0C0D062313FFE2800404F8317BFE27FDABD783EED3F7CFEAF3F39FA0CBF8898F6BF1AFFB83F5A2FC6409D35A3C04BD9CB3FE4F484BEE12C32407B62D0C0CE3A49BEC2AC6BC09DA52CC0BAFBA23F1CAE68C0C155BAC037B512C019E803BFB0A7423FFF3C9B40A23F913F9E2D5FC0A7FA13C06CAD4ABF3319D9BF20585DC0DAE900C02BA6B3BF62F14C40B63E83409DD7D23FA88AA8BF02FD1640AEB9BC3E5036F43F57EE7EC08C1CB8BFFBB7A640D3C63C40997C023FAC3A8BBFBF509E4035AA2A40833E2540D03773C009B78EC0981F8E3FF4412F40F36E82401D95253FF06A1B405D86CBBF25F48EBF26BD0340F4CD1CC0E5CA0C3E98489C3F1FA226C0792F7440ACC1433FDB8193407CC5923FCA6045BF15B509C014A04C40F9C68140F2A5DD3FA94C124047B485C02EC33A3F7BC94B40805DEFBFC305403E4C1FA0409F51B1BE11009B3E30315240518FBC3F302F0940FA7F18C034B2693F3964013FFC7E73C05E00103F910C8CC0266FC4BE267CC0BF6E5FB6BF3C41AD405D0579C0E85F2CC0A58BECBF5DBBAEC0A9FE3DC0A3436DBFC50828C0E87B4CC0603B3FC0EB2A98C0637942407F6E32C0C420A43FA519D3BE5B5F0A4091080FC00B5F6ABEE3C673C0D4ED00BFDEB1EDBDC7FE8340AE8D21C05333ABBF857503402B178140F0DB28C0B4638FBE5A9BB53F46E6D43FCAD19440F3C7D53EBC99BDBF6D5D5AC08C96BABF52F0C5BF0EFF0F40E1ADA23F2C8FA73FD48426C008295D40BE6E17400615A0BF3BF196BF0D40C93FFECF0EBE4ACCFE3F51E6823F572673C09DE8B6BF14F2A43ECC8D0A40252733C00D35873FC21B77BF2321793F80F2E13F5D346CC0EFB62CBF37A9CFC0859C953FDDAF07C0BE29B23F3C0281BE4F1C853FD67336BFDA70BC3FF3109FC0C430A73F752A5C3DC92FBD4073E02E3F09C24BBF58111B3D0ADD7B403D76933F81CD7CC079848140202E173D722D4E406C2545C09EAAC3BF6030A5C08B3C503F3AA06A40C810F4BE33BD38BF651CA83FB03271C0FDAA01BF478F503FCBBF5D3FF4B7EABF22A62B40B0383CBF592FD13E9CC865C080D8A6C06CC8A8BFE8D0A9C07F2E64C0E01F72BFC2080C41121304400BDBA0C05914EE3F213E57C06B2BEF3E6A48E13F6A7726403E8338409E16263D6874F93B76DBBC3F3F99A94026B0F1C032DC65407B3230401D5356BE27D8E53D5C953940C7BC81BEA7CF8B407B3F97402083C3400CA090C05E06824090BDC8BF4721F2BEF83AA7BF0DF574402F95C54087299C3E849C58BF56596D40FC12E4BEA29FC5BD9CF58AC0DC7326BF401154C0DBE1A1BC4E84A1BF98C9C9BF2C7C9BC0321874C077D00DBF2594B340D69599C0A033E9C018699CC05CEBB5BF6085F63E161A41C03CC501C03B4DD63FA0D78BBF25AAAC3F8D3D18BDA9E5E53DE51EAEBF631607404A4BB9BF77F1DCBF03B53CBFE9B666C003599E3E7B66A03F638070C05C54F6BD30B24140993DFB3F2A5ACAC0066764C0B6A243BF1B312F405934FDBF24753FC029C74A404BA7A64073B5693EA4E53B3FC7E9B240218B6340E9F80EC04EFE08409F397640046AEBC0C5CB15BF20E350C0B4066BBF55B7DF3F53FA50402A9BB14077F601401167E4BF10056640EDBAE2C035BB33C0BC7920C04744C4C0C88D703F115804C08278A33F294FAFBF79D0874023C50C408A318A40FF96B9BF258BDD3EA251C740F9ABAFBF55557DBF1075C840A3143A40424C7E406E08CF3FDB290240282283BFAF8D383F6070B63F6770FBBFC8F34CC074277EBEAF8A62409383EDBF8917CD400CB8C3C03FE813C0A651C7405050C13F7177EB3E1A8B83402A97123FD9A9803F0F273AC0CFEF4ABFDCBC473DAD109ABE4677FCC008CE954038608ABF49121E3F98A672403F0835C031A44D3F62068040BB3091BF49F5D8BF201FFB3FE974B43E02B6A7BD2298E0BFB196A6BF61C8173F9E661F404D6C043FE0EBC2C043F52C40B04BEBBFA2C276C01FD6C3BF33EA8CC0EED98BC024B917BFDBC0AD3EBB700140F2FC4F409FE47340EDC68EBFC7573AC05AA72940DD4B40C018184A3D130B6E40C83D3CBF0378C5BFEDFB94C03CE651405A32A1BF1D876EC0CE10403FEEC7A3C064D810C0B376963ED43767C0EC861140C9DEB840E929BABF5896803F16ED0040CE8ED4BFE55DE13ED17183BF9E14BE40CC5B7B40CC1E744003649140EDE200C0D99597BFCBD5A4C048C6D13F745934403AFEAF400D389540A52545C08302554099230D40399A8EC0BC5F5B40BBCDE0BF0DD8F83FF8FF9940884F3DBF8EB008C0BBB342C0E3CE57C00B199E3F2475D83E7EBBDCBE06F6613F828A4CC084770940EC2D43C02942D4BF68752340FF292EC08BB34CBF57E6793EFBEC5ABF070A07BF83F76E40BE488DBF8E0B8AC07D35BABEA651EFC057A398BF615219C0EE99B9BF"> : tensor<20x20xcomplex<f32>>
    return %0, %1 : tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x3A65FAC0FFEE573FED968CC0C1D380404E1681C01D238640A15187C0D8A27F406548D93DF4CF4A405C6C773F2D009AC0DC85613D80D803C07E2F1EC0369B213F0DFEA93FB0BCC13FB89B23C0FBCEEFBFB5426240F6D5CABFBC0627C09CFF12C00C7A8ABDD7611E40C86C6B3E135A1B402AA69B40BF31D8BF8F4910C08729FBBFC497FEBFA9D8073F8ADBCDBFEF4D00C09FE898C05B1AD9BF5FF7A63E25D2B8C0EA6C82C0DF2ACB3FEF8E19BF988004C0016980BCB687A1BFA292B3BECE3CB63F35C3CABF9EC3A440B7714E40D161054015B1BE3F104618BFE71B133FECDB89BF68B101C0B2135F40073C01C0C4B21E3FAC7551C02B2F3D3E23C97FBF4B0B2040321901C0809FBFC0E407093E7E415CBF0C3ECFBD3D541A3FDED821404B7229C02B090740FD7A8E3FF02994BFEC3BADBF2C9BC53E637C2B401A275BC0C0499C3F9130BDC0A159D9BE4075DDBF1D870E40EC9F48BEC1154840C309E7BE6C26BCBEA715603F7932AF3FD12494BC65FB783FCC8C603E17ECD8BD6DE9D7BE997AA140A9BA98BE96E59DBF7635324053ED953F223D2AC1A6D41DC02B4B0AC0F26C014099EBD9BF02E05D3FFE74B1BF4FEF52BF30DA96C05E4F14C1E86FD8C03361C73F22AD2EC0E718D6BF9EE75DC0D70CAFC092B4C03A89D4EB3EBB617340431CF6BEE001303F4EFB81BFE68EC5C06F14C9BFD3C3C23F532D9D40F6639BC0B3E42FC0A05A09BFF74721C0538317C080A421406E1BF3BF00D59B3E82E3AEBFCA8F98401B7B733EC3321240804494BF40BC453EE46CBB3FD7EB0E40A195653F2FF0573F8FFB4F40DFCD8DBF7F21CCBFF2D38AC0197BFCBF25EF84BBBDEEBEBFCC59A3405583CAC04CABAC3FFD33F1C0D6B36340094949C03D49CC3E857B45C0E43E2C40161491BF78159B40C71713BF00EC66C0351626C0FD740840A2841240004404409EF35F3FEEEC28C066DFD3C0B53585C0EA84743C08C86FBF3833CDC01AE49F3E8849253ECC1EC63F394A37C0E8B4BDBF16FB5FBFD5CF03BF9A71BABF2FC4BDBFD1DBA6C06740C8BF0F6C51BE62A3CB3F762B5F3F957D3E403BB6A0BF6AE128407722453FF74A77C035FDF6C0EAE24BC082D4DFBFE5DAB93FBFB9EFBFD1953C3F03F08DC007C3B13FE0708D3F31A9153E4B7E29C0D02C93BFFFF892C0294E57BF55E763C0118A4640749B5AC071160640B0E5A7BF843904C0A5121640A7D4ECBC44579BBF6E35C8BF646F33C0099D0BC03B3035C056D8D7BF5A35393E428932408B7FF2C03DB93BC0D3370440802BC8C0D32A69C00DCD63C09404D3C0FCC55CC0C4867EBF44F22C3F508369C0B91ADFC006B9B3C0CA20D2BEBEBCDC3FF57CA140CCD02D40CE8344BFE7B5C3BF4FA825BE75A6EEBE5CC401BFBAFCFEBFFE686C40DC0232C06191543F16A220BF9D7DE440FE95C3BFD102ADC06BA8EA3C297D49C0BC6647C0E1F218C16AA80CC1A405D3BF966A69C09ECE18C0C1F16CBF4CCE6340EAA706C0529F683F3AF62FC0081BE73E0C4C563E227D6A4043DD14403E7122C0214549C08C681340EF7CF0BF9EC03E3ED41A3A407CB9733FE01D8EC0757C38C02BACF4C0C6CF4B40E169343F6747B2BF34F493C0E19C4240EF204D3FD32DB1BF671737408CDC883F535588C021DEA6406B94E8BFE4AD6EC0568ED2BE3D7E50C06E20083F0EC2043F775F2EC0E444FABFD0AC7BC082C60ABFB546993F074C08C07EFF3BBF134734C0006C3CC03F4430BF4DB7C3C0F1193C3EB484C1C0AB929440F5B69B3FAB728640E72EA8C045EF96408B60D6C03C0E333F93D6EFBF1585C43F29632240E2A78DC020D29FC0AD909DBF702300BE18B479408C1D5B405AC7D8BF56CF34BE4F913ABE407160BD41F7AABF4566863FB9DF6DC0B06CFDC011DB1B40F3197E40508904407331DFC052C727C0D4B5BEBFF6C08C40F201E6BE3492E6C075F1753FDA7E81BF3084AA3E1D3B48407DCFD4BDB8364940B6918DBFA535A8BFC89328C061FE3BC0E663D0BF856A6C405D6315C08261AEC0AFD3373EB70D3B40F6091BC0E607BFC0DF2F41C082D5DCC0FD93053FA4EBA94026A1C3BF67E19CBFD760D0C0D062313F95F7A63F0986213E472103C14CA924C07CFEAF3F39FA0CBF8898F6BF1AFFB83F678002C0B861AEC01AC3BDC00E5F15BFC4B1B1C0A28E243F584005C04D4CFAC09DA52CC0BAFBA23F1CAE68C0C155BAC037B512C019E803BFC6D4203E31F28F3FCEC4E9C000874540515498C01044A8BE3319D9BF20585DC0DAE900C02BA6B3BF808146400AEB46408F6F4E3D3AB0A7BF9039A1C0AE3AAD405036F43F57EE7EC0F664F8BF13F4A43FD3C63C40997C023F831F00C030D082BF35AA2A40833E2540D03773C009B78EC0057D23C01A3B3140D54EEBBF024347BFF06A1B405D86CBBF25F48EBF26BD0340F4CD1CC0E5CA0C3E98489C3F1FA226C0D9613F3FBAA0393E700261C0EB6866C0CA6045BF15B509C000CFD33F77B71DC0A06D16BF6CD8AF3FCF3C8FC01C4502C0AB2828BFA84913407A6B97BF383E87BF5B8BB0BF4C44BABFEB03FCBF5427D53F302F0940FA7F18C034B2693F3964013FCBEE8BC0DEDD8FBE910C8CC0266FC4BE267CC0BF6E5FB6BF282A12BFCA4C2CBFE85F2CC0A58BECBF5DBBAEC0A9FE3DC04769F5C09B3C8E40E87B4CC0603B3FC0EB2A98C0637942402BD338C0D20055C059053DC0F248384091080FC00B5F6ABEE3C673C0D4ED00BF315F3AC0C9A8C5400F71AAC0BC68854076302A3F8A2C3840F0DB28C0B4638FBECABD883E02CB183E4243EEBFCF88733DBC99BDBF6D5D5AC08C96BABF52F0C5BF1E5A2AC072071FBFBE84EC3EE8A11F409A0804406D3693C00615A0BF3BF196BFF3A12ABF3E6B523FEA0EAEBFB14B2BBF572673C09DE8B6BF14F2A43ECC8D0A40252733C00D35873FA929A7BF0BA37E40C616DA3E074E3040EFB62CBF37A9CFC08B67C8BF1D5B25BFBE29B23F3C0281BE5B9E63C0B8FD603FDA70BC3FF3109FC0964BFCC0413507C01457A73E9FFD2D404401A6BF7B8F1DC014FBFCBE56FBDA3F81CD7CC079848140BF34B4C0A5E076406C2545C09EAAC3BF6030A5C08B3C503F9760CB3F6A1DDABFBD2B3AC0F5F57BBEB03271C0FDAA01BF697321C155BA3FC0F4B7EABF22A62B40B0383CBF592FD13E9CC865C080D8A6C06CC8A8BFE8D0A9C07F2E64C0E01F72BF2C46124043918EC00BDBA0C05914EE3F213E57C06B2BEF3E2625FEBF86033F400C3249C0BB32DC4081F98DC0AF76CABF7498B93E7848A940174DAABFD2801DC0191E1ABFA338553E07476AC099205EBF172D2540BF3600C0F7273AC06AF41D40869CF5BF5C6E6AC04721F2BEF83AA7BF0DF574402F95C5407FEC31C011578DC058B317C0FA271540A29FC5BD9CF58AC0C4FF58C061DF204012227FBF71AD8C40635626C0E8D33C40321874C077D00DBF77C63EBFB36F90BDA033E9C018699CC05CEBB5BF6085F63E161A41C03CC501C0585978BF0B078140AB919BBF3C5D193F52549CBFDA220F3FF4C4CFBF886A394077F1DCBF03B53CBFE9B666C003599E3E9E548CC0F9F51140D53C3BC0AA727A4056398F3E65CB0E40066764C0B6A243BF1B312F405934FDBF24753FC029C74A40069935BFF5B9C03FA4E53B3FC7E9B240685853BF0A2275C0281B6AC0FD47BC3F046AEBC0C5CB15BF20E350C0B4066BBF302965C0CC6C01C0B62851BF1FF831BF1167E4BF10056640EDBAE2C035BB33C0BC7920C04744C4C0A6C692C0A4DDC0BF8278A33F294FAFBFB79E46BFE7588F3F9E324840024AA0BF258BDD3EA251C740671AD4C08DAE1D3F1075C840A3143A40695F6D3F49C553C01539C33F1CDA823FAF8D383F6070B63F6795F5C0D10408C0019632C059502EC0DE1E1FC0431334400CB8C3C03FE813C008CD0F3FC6EBC0BEED248FBF2F5D11C0AAE2E1BFBBCC0A400F273AC0CFEF4ABFDCBC473DAD109ABE4677FCC008CE954038608ABF49121E3F4822423DC824B9BF535BB0C03CC40F40BB3091BF49F5D8BF201FFB3FE974B43E02B6A7BD2298E0BFB196A6BF61C8173F7534C43E571E80C0E0EBC2C043F52C40B04BEBBFA2C276C01FD6C3BF33EA8CC0EED98BC024B917BF4D56E4C04D0A36C0E16894BEED2AE5BF667A59C0C6AF80C0026E01C0AA6481C089F89BBF2CA83EC0C83D3CBF0378C5BFEDFB94C03CE6514037CED8BF376D18BE0BC03B3F7D8A89BF782167C0B825AA40D43767C0EC861140433E7DBFA2CB2BC0163D243F780250C0440127C0265245BFD17183BF9E14BE4084FEBABEBE7F443F135128BF9BA31E3ED99597BFCBD5A4C0348A213F3974083FBA4A114052DC51C0A52545C08302554099230D40399A8EC0BC5F5B40BBCDE0BFC65007BFCF01B440884F3DBF8EB008C0BBB342C0E3CE57C00B199E3F2475D83E7EBBDCBE06F6613F828A4CC084770940EC2D43C02942D4BF5EA8BC3F392098C08BB34CBF57E6793E640A97BFC8C85FC00CAC0A4068376A40ADABA7C0C99F0DC1A651EFC057A398BF615219C0EE99B9BF"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
