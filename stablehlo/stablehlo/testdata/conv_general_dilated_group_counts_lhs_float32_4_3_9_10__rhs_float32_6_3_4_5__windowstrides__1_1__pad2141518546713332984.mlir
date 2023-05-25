// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<4x3x9x10xf32>, tensor<6x3x4x5xf32>)
    %1 = call @expected() : () -> tensor<2x6x6x6xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 2 : i64, feature_group_count = 1 : i64} : (tensor<4x3x9x10xf32>, tensor<6x3x4x5xf32>) -> tensor<2x6x6x6xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x6x6x6xf32>, tensor<2x6x6x6xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x3x9x10xf32>, tensor<6x3x4x5xf32>) {
    %0 = stablehlo.constant dense<"0xDFCB9D3F89F2603FD9BD0DC04E45B040F0F18EBD4E3E63C08B3FB040908D764029C64F404D43A23FED43753F60A4A4C09DF3EAC0B75285BF46AC333ECA0B6940B48912C064D1A1408DB8864051D4303F3CA5B2BF3F3A05407A407240270983C02B08D9BED870994089E9104015C092C09CE5A6C0B9B6F43F5BF0213FF429C5BF796B2A3D3D05384083C76CC096FC733FCC22AB40A7FCB7BF2E199D40D4282740C50ACBBD474D66404ED0BFC037B184BEB83F5BBF445DC3BFF61545C0CD4F08C09B118FBE51BBFE3FA84691C08EFE68404495E3BF4486E9BE0AEB8440F30EC9BE5B68113F19466FC081D21EBFF7A313C0CD5E22BE8A1245C0709D6DC09359EABF402BD3BFDFF185BF86E352C088FAE9BFDAE12AC09646A540C501A8BFEB2147C0A2A2CABFA8BA02C0F5DD6340EC2B30C0A8B9E0C0D9FC453F8DD5F23E029A483E9B0E8CC0C6E1523F8BF2B3BF789D353FFF7174BDDD6847BFC4B705C08A1038C07428DFBEA27BD8BF2564C840251E6EC026481E40E3B022BE6BFF33C05E25E23FEE9D084008628FC082FEA93E2EA589BE4188FBBF250B523F964E1B401AB2463EF089E43F7F99E63F1B19D43F84E63A409C5371BEFA4AE93F8C14F23FB189D2BF79CDAA40B4F805BF100A67BE55A92D3F12DC3ABF9015B5BF338E6BC024CD26409D9B3A40495EAFBF60DD093FB9A639BFC5CD26C0E714963F6E58174041A3DABDE39EF63FFD9F5A406543C7BFBE93ABBF9F1976406AD39E3EBD37C6400C7775C00B26443F896CD0BEC6516540367A103F8D1536C05E3567C043292B3F1798B2BFA223B23EF35D1EBF42126FC0BB9F2740AD0B343F1C8E1BBF3D5627405B6181406684E940081CF83CD39427C00502A73F3D028D3CB66DCDBFEAC4F0BF463A4EBFCBE1C83FE46E4A3FCFC065BE0A6D8C3E4B2A404010C7804014D13340B4BAF43F66A56A4092BB92C06B991440FA25134035A45DBF7890AA3D032605C03720344085635B40866703C03B6FB23FF3BEA3BE8E600440EC69F840A7AAD03F5D2E393D401FF4C0393413C0A36C12408DD07440F98C26C0C3AFEF3F8A42814007595E407EA686C0127337C0F45471BD5C75C9BF6B363E3F563EFE3FFEE624C0EE42E0BF1A2DE63F8A102C3F3512803D170F744072102340C00E5040969C213F58BB74BF96E4E13FDB6FD7BFAE98D140292BB8BF114379C01446E23F3B1C43C0711AB5400501334007F0344040CFEDBF98C72D3F94653EC038DBF83F667C8840514289C0CB39B1407C2381C0ACD033C000A41C40D8B517C006BA9BC0751E6DC070F88CC04613BBBF128B7EC0954FDFC05D0EB4BF5B951E40BD8302C098188C3F775A85BFAF55CDBE7D8D2FBF4E9FA140DD5CDEC0953822C0DD31C2C0534C3DC0172E3A3F55C64D40240C6D404AF4B5BE93C10A4021739A40F30502BF99BEACBEBDA2BB3F20108BC03AAD57C0DF9C56BFE74F543FA11F35408C4785C0B2DC2440AF76EBBD3639A23F9DF46FC04C2370BE596B8440F3D1E34068FF143EE8111CC05FF633BF49AD9540E4F025C0DF36493E35C47DC074514EBFD1D0B93FC72564BE47CD893F926EAEBF6C1D753E23AED83EBA537A40F168FCBF87144CBF0B668B3F6A1593C0DB0236400C1CDBBF5D486FC0A627A84012DB09BE346D9F407BB40FC0BD32154079BC36BEC60FBA3EE1A61ABF9E4A564036098840537294BF3762BA3F302B403EBBA90F404875FBBFEA74B2BF593F0A40BDBF9340F4FE404078B94640057C93C01DBDEEBE958AFA40E33D75409C5A2C3FB88C304063A2B73F24F92740800F6A40A0878240F70BE53D185C03C0FC87ADBFF47D7A3F0C0EE8BF42547FBFBA6113BF973440C0E7A1FDC055D13DC02649F0BEFD2136C0C110374021818D3E40FB08BF0490AC3F766B95C085AAA140E69ABCC0D34EB23C2A9397C0055C493FB499E13F87DC173F62A813C04A8204C1203DC83EAF89BC4042BDAB3E7B34384009F018C08A0C1441BD947FBF6C894E3EBAB528400E9605407A7F234016FEB4BF6C7FB7BDBE4B3940D89DFC3FF3BAFB3EF5D5AC3FC2BDD23F46572FBE7FF88D40BFFAF13EF5825640638F873F0A4131C0EA69233FBED265BE682CE5BFDD4E1DBE1137CDBF387E99BEF7148B40B4E31440720A1CC057D0533F007891C0A80C8A3F499A4DBFDFF73EBFA4A4FC3B7A062E3FC7CFD7BF004880C035AF43BEABA5863FC1F3933FE9E4BA3F1A3040BFA9D8E13F9C2893BFC07446C0B94B963F2EB5BBBFC408A8BFDAC5F83F13F3EB3EA3F4183FC6349C3FD15A344045900A4131BF903F8DFAE6BFEF6A35C012988CBFECCA48C05F85CDBFC27762C02B64733C66B51CC0E09C21C0857FE6C035AB60BE2F142240EB4ADEBFBAA6DABEA3D2E0BFC9FD88BF192D2B3F4D259B3FC89286C0ECA3713D3AB734BF15F8143F2F7F8440AD51DDBDAA0DEEBF89C9933E79B22BBFF07E2140733DC93FCDF0543F9AB2E6BF7F0E45404ABBD9BF0B380A4087BE99BFC47E733F3E9971BFA78FFBBD108E60C03BB6814021C8D7C090200FBFD64D8C4083253A3ED080AABE52FC0C40CA6A9C3FC8A28840D1C484C0BA704BC06291E13F0B4F0CC0C0555940A72FA4BF33CDE8BF9C07213F34484B3F259A6640F4D57340A7284FBF5B69D73F11453940D25AE53F1FAD2EC00E085D3F818A56C020EA8FBFE129123F99F3EDBF45F1683F55A4BB3F4BF5DFBEDE3538407BCDBEC070B3E53F63EE0FC0D8AA80C0F57A2340025EF9BF1380AAC015B9ABC00B2193C0524B6F4068E1F240EE406FBFD6D09BC0CC4294C0577B40403FB5DBBFD62B6C3E664244C088706EC038266C400F408F40873B54BF88FC5740039BFEC0AD939540E5E27DBD6FF786BED568E44081928B407A842F40E5705CBDFDB3D9BF8A0A9B40F134BABF092A60C0239FE13F31A372C0D232FCBFEF2A5E40CE6CC03F4A5EBA3EB8AE543F4A1FD63F11F034407FBC3CBFE0E1483F44D518408BB47BBFC7DD8EC0F5883240E614F940773B39C0BA83A040C00ECDBFE369B640622CE33FDA53A13F0F09BA3F48C81F40ADDA573F8BDF39407E43B8C06A41F23F3649DCC0D0CF78C0A69D96BFCCC001BF2DE4613EBB6B623F33617F3FC67A8B40CC4B6040AE69CBBFA37740C05728C83FD4DCE83FB65849BF4B291F3F580A6ABF22D2E240FC6213C10C5881C08B8FAA3FCD0E18BF5042033F0E1171BFB26463BFFC1DCA401D77DCBED4F79440ACD602BF620C6EC09062F840ACBA7BC058758740E38BA2BE17A262BEC2777840B9B1FC3F2FAE9BBFE016A0C091CA05C0D1187FBF4021883F00C19EBE3BB9BA3E8F9222BEE8275F3F24558F3F323F733F56677FC0FCBEBDBEA414C1BD68D896405F8B83BF0EAC83C07721923EF800B9BF68997BBEDFCF3BBF712BD7BF00980FC0F6794F3FF830D73FE627F33E23A62CBF963C49C0D1C6FE3EB441F5BD6CA4B2BF62499840EF3345BD7FB55EC0038BFCBD62E727BE7D17853FF4F942BE5A7AE0C0851B9DBEB67A2CC0B0A8AFC0001C3340A58800BEB987B6BD40BDCD3D721215C039ABB53F4F7EB0BF5FF50AC0547D8B40BEB3683FACD1BAC04E4A78BF7AB7CE3D7AF58FBFC929673DAEA6D6BFDA6C7E404785464080EDAB4027E2ECBF916C33BFC1FB0FC006782E3FAA159E3FBEDD9ABF10004EC0FF361340184BBB3FC934D5C03E6103C07DEFB23F151B7EC0F17ACF3F6E87DB3EA7619EBFEDC8234040ADEC3FD50109409C0C53C0B87B3E400033F23F0072113EC557563DDB5D8A3F3F19164095C17DBF30D357C01D317CBFA55A553F6CC0394047D898C0406FE7BF0A7938C03E7C70BFFC40713F0F076DC07E86EEBD7F83F03F8B8B58BE8F776640EC468EBF57A7D1405CA5ACBFA69DAB405250D83F686738C092C156C09DE28E40AD333EC01F2D11400780D63FE669B3BF8610E4BF1DC0A7C0868C2D407435DFBF9CD648BFFA07C33FC10039C09BBC45BF6C3CB0BF0DDA39BF73AE5240615BCCBFC45903BDC3FA99C060A80F40B228833F1EDD67401BD14A3F902B0FBF5FA46A3FB7DB313FB46E29C000AE0A4027E6954068F2CC3F07E2A5BFFE4773402F3FD93FF9E80AC0E5C8BC3FC30E713F7E1CF3BE5981A83BC8E8CD3CF44B953F890ACF3F0E63A3406DFB9ABF7038E43F056E52403A011140C4EF8DBFA8F30240F4B7C0C0C434A13F2B746C3BA01FC4BF07D041C0F29B1E3E57FC14C06D59D7BF36A214C0201AEE3BD6A454C0E96334BECE142ABF095D4B3E3ECE5E40A55EEFBE584387C06000D13F46538F3F8A242B3FD5C1353F59C9A640BD342E40202EB6C0BEDE48C064C1ADBF5B90DBBF7E70B640C0400E400BB8C6BF11028BBFB78D9A3FF9D344C023F85440DCA6B2C09B1AFE3F4FA7B8BF0619063E67D86ABF172B7FC04BFCAEC06046ECBFE52BB73E91490C40114EC63F9C923440C86EB1BF7F0B66C0FC9DDDBF4144ACBFDA16DB40F809CE3F1E6791406DFCA4BF804F4F404DCABD403CB688C0CFDC6E3F95199A4034CF7240C1A3B2BF8558F3BF96391CBF07E72B3F18C3903FEEBEACBF87671CC04F058BC039C2BA40EDA71FC08B03114096F769C0AC615BBF21B82EC07E1B4FC08C2F0940F47F72C088F423C0E0DAC4BE8422C6BFA759364006D9A93F4A1196BF09ACB1BF8D5938BEA09AD1C0469C9E409208713E956703411650DDBF76C51FBF40CD11C0CA10844017C2E1BF46A7E3BE6D2C12C0BB9293400F4B93BF743BE83F1EBF24BEC7FCA0BF7CB6843FD05344C0EE4F4A401C13FF3F3F855A3E8B7F89BF10EB8FC0536F7F40BCAEFCBE8B4E304025AE60C0D76209C0142BB8BF1B24CEC0BE55AB40219F86BF39303640A06F0A40AFD51E40B4934EBF3EDA944027ECC940F19F09C0C699E7BFAFAFB3BC65653C3FC0B5C1BE94890A402554D3C0686466BF209729BF487964C0E07DAC409D6C18C0CAE0B9BF77CB42BE7389A1C0B90FBA3F5675C33FAC9D2C409456163FC2881C3E4FD8FF3FC3B376C04891BD3E699B8DBFC6AE91408D647B3F629E8A3E9EFB71C054ABC43F830887C0E0F1824091D30B4004259640D072DB3FDA5BB5BFCF7B64BFF401914078A68D3E8F5178403FCCE43F2D718B3F8830E8C0C618D1BE68E5EABEA53C7BBE8BE4FFBF484A793F583C69BF312501C117F031BF4A02824086C624C008F3F1BFE39FBE40B6D8B63E23B66E3F728B7B409FEEB33F1319653F1B45CDC0A3C2233E2F64EABFD72595404A9096C010F09BBF42647540C0D4B23E378127C0B70E0AC06354C4BE29A190BD8F8469C0285762403A49BE3D864A873F5D010EC0E6D14440046F3FBD30ECF43E3D5115C03D8431407CB608403998D63F8551CDBF913B1C400A65BDBFBC5C4B40C7515F3E701A25BF33EC0040F637AA3FCA0454BEB6D411C05FE793C0310FA6409F165740934D72400E31613F99BBEB3FA7B589C0AF3E29BF84BD4C40EE123C4026C42B404F05E93F531C84BF5591CEBD60D22B3F4329B6BF3A285840B3F09CBFF4582AC069176DC0601492C010DE85C0AF076C3F5AA182C0EEBA9EC063F161BF9D6D43C075632C3F4874CBC0B589AE3F377E2AC058A8004090BFCFBF943E80C03969C33E001C8EC0A84A8040922A6C402FEB07C061D608C07CD5FDBEF8F353C0CF6F3940931E24BF58A58D3FD14A18C0137E483EE5DCE63FE9CC803E54D7BF3EA99B6DBF0A32B4BF7A226BC0EF54A93F1A8DA1BFFFCADBBE22C9FABF5D827DBFB0E6DABE95AEFF3E6A2060BF5E1A3AC01EF2013FC48CC8403D63DFBFC9D1AEBFF971B03E346F014007FC05C0F2B424C0D2A53BC09655313F97336AC0CD683840CE1B84C0531A94C01BD445401BF6A440BA93E03F7611E2BF8A565B3C67405D3F35049E3F35459240247CB43FD4F5723F6E92C6BFA63EA2C0BEA1CF3F2588C3C05DA7F1BFAC1511BFEE94F6BFDA5190BFB1A351406E341640D441BD3F8209AD4027D127BF99B445C0E8DCC9BE64998A40C4E7CA40BDE5B1C00318AABE5326FD3FB1B006C097F00840C65F00C1674B983F50C1B8C058CE7740E2C1ACBF9A777440916CD83FED157DBEE0F5253FA0A402414B4258C020781140E07051BF7897BC400DBC26C059A0E63FD106EFBFE67CD34028B458403FA618BF"> : tensor<4x3x9x10xf32>
    %1 = stablehlo.constant dense<"0x29999D3E7B470A4030D42EC08B344EC0CBD077BE35F148BEF7CC8CC091A48FC0D3A7AA3FB201E9BFD599DB3FEB69BBBF90C898C0C13046C0055C2B4030EF943F06339FBF2A680FBF49C20F4019AE733FD3F38340380323C052B874C088A177BF7F70913F5A89A940776882C0F27CAF3F48A97C40EBC8803F2F29ADBF1CAF6AC0ABC3244074A09640C8350BBF764B9440AD87C9BF4AF622C0218D764047BD30406C8F23C07F32ADBF6AC127C0349284BFD9C403C0ED710EC0525FF73DCE47D8BFD254713E7A6797C0575BCE3F07F387BF8E1AF83FA2E99CBF6F561FC02DF45D40B046263FF63D1A3FCC393040E7F980BF459212C0FAA059BF17D5714046F232C0641C04C019302BC0129E49BFFB87BCC0DCA9B4BEEBC10640DF76ABBE4F4465C017CDB6C00FC03DC03E03C73E1D3C9DBE5CE04CBF4560A540269207C071CA98C05F8C1BC0E71CAF3FC0C560BF9B2A4940100D7AC0298450C02FD4534030D8EC3C19915FC0D8E187C08DB5BBBE52DF3DC01754DB3D1B9914C0ED5E3FC0ECE14DBF163664C027176240DD5407C00E12AB3ECCA23D405D878FBFC90468407B45D1BFC0C10DC03457C5407B0EE7BF5169EEBF5F3FFA40EF76B3406C8878C0F4B7E73F8907113F68E9254029BC29C0D555B6BF33761A40123CCC4058A12BC0B63C16C00FD146BC5611C2BFE9D9F63ED312B93FFCE329C0EC4094C0803B29407A77BCBFECE837C0B603A240851F0BC02CFC09C0CDC4BC3DD69A063F7BBE12C059BEDC3FEF8396BF38CC33C0452F93C01136903FBCCAB7C0067F7AC0A61702402A16FFBFD4624AC031F192408529F23F24D5A240DD828140DE5FCE3ECD85A2C0893D4340D9DB51408DF20C40A0701F407FC31E40352B5ABE1C28DBBF8F7563BFFFEAC53F31B1A23FF42891C0E3350E3F0A6343C04A1E6CC0EF0E03C1B104AEC0B4AAA1C0ACDE9DBE26E6D1BE7C0BD8BFB2E7643F9DC8CEBF61E8C6BFA89A02C1348580C074B197C0FFDC36C08FA32D40FB0AF4409E088440B657D93EA3D96040066769BFD478FEBFE2BDCB40B959AF40F435B6C0AEBC2F4053894640B83FA63F09D7554052F45540956B63C059C0DDBF2E9ABABFD84E344055E80540341EBAC00C69993FAFED94404BA231C051320D406EB4DB3F33AFD33F251E92BDC09153BF7944F5BFE690873F6CA8B93F1F3C05BF9430373FE951F23E6EE7F43E0CA5AC40E09B6E3F33BF8B40B0BB40400A0C1B4027B5143E2078B83F03243A3FC7172540EFC1F5BFE05C0DC0B94718C04C099ABC6217FB3F1B1287BF8FE373C0FDDBD63E6C6815BFDC1080C0C65A82C055CEBAC0C4BD7B4072B3A7C06234EDBE0258AABEB8AF96C0417C324035369E3FA88DF63F12E44640E5F5BEBD8247CABFA09A8E3F56831E3BC0CD49BF10831DC048014F3F0B6F4540B4CA6040424902C0B841DD402446F1403F1807C04CB10B40ED6BC6405FE68DBF041A413FA6F9B9BFC41583C0DF13764000A043C0615781C02C62C53D4478CEC0B9E909C08260943F94E05BBE3E9ACBBF6E17BDBE055EC8BEB97112BFFDC683C089901CC0F3C655BF8C5F13C09F1997BFF339F7BFD446374021AFE2BF671134BF4C4F0AC0012D974099A3C3BF771499BFF3CB20C0F08DE8BE18C159401C3487BF5CF23BC03A91683B6ABB25401A5565BE6A4839C04E49DC3EAB32FE3EEA433F402F4B834043A678BFE70D4D3FEF889CBF76672BC03ADE36408143DE3FA3F939406E0764C079166740C5F319C03B3B7DBEC9F1D63FD50FFFBE7B815C400F0B933FA3E6A1BF1AB6583F8FBF123FD135353E77562EBEA059EF3F256627BF5C59DB3D9961CEC0190A34C00FE3D53E7DED04BF8DA7923F8CE3833FD094803E467358C03166E1BFFD52CF3EEA1F1CC06E1B8DC0E561A0BFF0EA2DC078A030C0A34B25BF7AAD82BFA093F93FAB726B4067B0F83FDA0B8E3F19405E3FE34149BF380CD4BFE71E8F3DF30D603F1350A440EF21403F58B027BF52619B40434C4C406EB211408848E63FAC0CDABF64392B3D072DA5C0"> : tensor<6x3x4x5xf32>
    return %0, %1 : tensor<4x3x9x10xf32>, tensor<6x3x4x5xf32>
  }
  func.func private @expected() -> tensor<2x6x6x6xf32> {
    %0 = stablehlo.constant dense<"0x01D2A842DD6E1FC24CB3F842165A00C275AC7CC2E284A642F44B69C2EC1975C29426E54155BE1BC2E8C585C13B474BC2D0BC5841FDC5B8C2D40BC3C180C9D3C234DC42C1A8938142EC0A44C0D432204286DF52426C9017C3500A6940FAEADF415193BA42570F6FC1A6D69041F27310C1E57992428F5A7C42D7D4EE42395A6A42FDD9D7428C3AFD42C684154214C3564200B19A3F63A0FD421CAB0BC3192785C20E3CD9418AB58AC2BC0462414867EB41AD34C442F54C87C2292929C297F0C5C1F43E414270C3F73FBC35A4C15EC39A42C6054142B803EA405A078B42487670413FC6FEC296E49EC06CE6AF419E6252C25C7972C243BDA6C1922E9E421E4F5342408C13C34F8D3442569522C2C89DA0C1AE1E32C2DAF081C216B05442B0F73B40F2F0C8C22F1509438E785642DC94034308DB134117740CC3BA1985423AF97FC2609BFAC23A5DF8C2405715BFE48981C24A3BE0C230D8AD41341AA9427C3D1B4107136D42DC5E0441C0BF9E42F811CEC00D329FC2BB9F0943ABFC5342242F04430170FF429A0B4042B1F283425EF80EC121EE31429C16DC41211BDB42F628DC429C0DE64274A76A430E81234338DE0E43C052404394052DC162A5D3C1A444CCC15DD41BC2A4C6F3412D1D9EC25C5ACDC1B21D3AC20CFE61C1FA4EA5C1E0317EC23C7F72C32689F1423EFB4F42E4DBD9C0519D6F42223C57C1EA06ABC126857E42603EB742AED141C20A1CFE40506C0CC2D6D5E0C22C499241E06D38404B660AC2D5DE98C2DA2C4EC2928B15C235872FC210C28540112A06C2B60B0543D09403C00D1D61C2DC8B96C2EA1E6F4280BA0A3EC65A3442D04627C0EE53EB425825E241807BD940A68707427FDCCA418C9592C19F730EC2982C39C2F2BB23C3AC0D4A42EFA389C08EED0941F5C3ADC2ACD69CC1BADFA44212D38341A55FAB4255FF61C165706DC2785A9E42E4379BC1AE8682BF114A6FC2027A9CC17CE598C1043AF7420017283FCEF604C3B406C441952BEBC242058342B2B55AC2602B11C26294BBC240E035C29E354542923E47421620B141E269C54187609C42F215A141F6CE0042DB47A84131A41DC28C2C86C172AAB941483F07C2350541C220329AC230F94BC2A63F9AC1B0EF59C2E847E440FB6C1C42D68D5FC28EC0AF41DAFB034264C20B42F03112C1585FBD40E857AAC2E51EAE42DFD104C2585B3F41D246B8C1EB6E3AC2DCADD7C2E2EA1740E03244C23E2BDEC1A0ED5E3FAE0A6BC28055F941CC802BC248E8C54168B92EC2C8791CC036CBB1C2585E0541C99A5DC2D42E00426C9F45C2B2B579428C3B5FC2B0F4A4428CC7ECC1347B8840605BDFBFA86211C2FBDF16427CD5EFC1E45946417AE690C2D01A98C2B01BFAC0456A9542E8DC5342F7B6B7C1DC1043C15407C442E1643E4290D8A4BF00D83E42DB9A5DC286C5CF428FD01BC2A97A35C249C2A142B07BECC2CF8C0BC2D42973C1D059B3416A0E0542D0E05FC236FA2CC36E5E81C24B5913C3FD4475C21E78CCC29229C541BC76E8C1DB200C42D2268BC29C3B62C1CB51BEC114F366C2C0C908BF5F20AC42D8070943A0CE47C21C7BD6427CE39BC274A5AE42461A15C3404F0A43BEDEC9C2700B90427F88AC424E4007C20C1A91C1B2E069C2DE724CC3C2933DC1D8F453C264B61342C53C19C2A60E6C4270DF64C08FEC9BC2D2A5F3410A764342AEA40343721ADC410CFF1E438CE8E54243C408C266142DC3D260764298210543B0BA27C1FAEE1042D985C5420EB792C2FF0958C24C132BC258FECB41951425C32EB60EC394520B42EE1C73413D9FC442DDE6D7C28ECC0C42525D80419021DA40D090B0C2AA6534C2BAB83A42F0FFFA41406DAB3F38303C42F681DBC2D158C5429DDEB1429E410742E224FCC1DE640B42E88F1AC118CA6A4122D73A41FF35A0C163FC0441D8144142026886428AB9B3C07091DA409D0087428072B3C24D2B24C3681925C1A8AF1CC3860F9B423C32B7C256D748C26B769EC2D0620C424078E9C2EC8C84C26E34D5C240370FC240AC8FC2B60BAE42E8B8AAC29EA8CDC1C894C1C22A7EA84260F195401B3EA441AA71BF4158615FC2D5D48342B2C1934225453B41FFF4594268B033C23A172FC1AE8C9542A788BBC200705CBD394535C3CC9E1F42AF16FFC227C2A3C1E0BDA4BF7A3EB842704210C14A568A41121AE641F8D5DA41906C51428320F4C11C8F65417291C8C16ABAF741CE12E4412EAC5642C4AD0B42E031A5C1B8EB7E42A0FD41C07A3DC8419FC047C2C82950C25D2810C307BEDC41D024A3C2B607CC4152518F42ABAE87425046B2C22A3F6B42BA412EC2AA27B5418C028CC203576EC27FC6B9C23A4109C2C2F59AC120E97242DC1F1EC206E28D4206300DC242B67442D099CD42C821FFC0E626E1C1BCA595C0D49C19C222685D42AE9D9EC1CC43D142CF53D942"> : tensor<2x6x6x6xf32>
    return %0 : tensor<2x6x6x6xf32>
  }
}

