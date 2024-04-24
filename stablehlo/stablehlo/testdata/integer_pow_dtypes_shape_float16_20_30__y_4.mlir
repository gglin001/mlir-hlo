// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf16>
    %1 = call @expected() : () -> tensor<20x30xf16>
    %2 = call @integer_pow(%0) : (tensor<20x30xf16>) -> tensor<20x30xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xf16>, tensor<20x30xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x93C6582C85B7B12AB23D5EAECA45393A4A440F44DB45A742183B0CB906AFD1427740C4C5B3391DB8B4BE94399D322BBC71C4C5C52FC3F3BB8AC0C3B906C1D693C343F6C2EF3778468E35DAC17BC07D45B3BB303D864083B7703A93BFB52C683CC7BC87B876C4E4BE25C1EF45B3BBEA34F8AEA941C84747C25543843EF7C23A4037C4D43FE3C41AC00DC518C08A35D535DE4498C1404088C65CB15D3741C34A3E4AC02B43CFC091BCD9C1313990C3A0C2D2479E46F23E5F32D6C155C4FF42C3330442C7C0B44098BCE9BC0F40AB3B2141FC3C28C1AABD0BABAABD44AABCB97D41413BEFBC9A406CBFAB41BEC1014583BB2741C4C29D3FD132ADC30DBA7DB98D3EFB305145E3BCFBB9E1C3C746AC42E542E540FFB5B445A4BA5345A6BD2FBADDB80DBCB14468BD4DBF404241407441BDC0564185C448412BC6BE41E1C183B6AEBE7FB8E73940401DC57BC085BD58C12D3D9F3CE1C4C53559BFFB4476C139C739B96D3F6FBDF0C4B9BCD14489C96FC23B4186C27EC143BC3944C93E7A3B08BCDC3CF0B1F4451A45AB4180BDDAB6E53DF9409DC118C72FC38A3C6E3907BC964075C1AA430041F3A074C0AFBDCAB953C1C7456FBCFA26EE43264069403DC41EC5903897431735D0BC46410F398B41E8C578B88C3DD632D4BC773C45C0653CC544DB403F457A405C4839BFFEBD11BC094148AC81C724BC72431FB8903E6CBCBAC4644230AD2C4034B1573F7D447FB53642FF381942D9399A3C943C0CC3F342D445824169C5D041B735084056A81EB4FBC16EC044BF0535723B0F42FDC058BD44BC1040803DF13900BB8C4407BF1A44A5406A389BB4663DF9C553C0D74493C0F93DC235A9B19531D1C6FD3857C44F4493C4F1C012C675BD503BD3B0A7404D43BF45A3AB3DB93BBE473AF0B48BBC94C11B4559413EBC72444645B63F814598433540D83EABBF9F40DF3D4FC0D0BFBC40C4C6923C274060C128B80A48884548BC033DE2C5E5BFC4BF09C303C793C5AD46E6434E4361448BC18F4348BA483528437544D0BD5343A0C506C101447D44C54545BE8B43A13C8C4084C54744873A5B43F93E1EC13A4192437E409346D840B3BA203692C2B2417A4059C36CC14DB61037A63433395A3E5A3E61B9DB4760461A38EDC36CC546BC6AB041C01FC49FC39AC02DBF81BD1CC0D32E3738BBC249C1F4B9DA402B3DACC54CC0AFC0A93F0CC4A440743BC7C40CB610BE17B83D44E7C664449444D4C133B01EC284C442C7693A0D44E6C2913437BCE5390EBD634102AD37C3C33F233986316A449E3909C286BF842E173B59BAB1C0A14280390240F3B968C79A3CDB4131C03CBF8EC7AD452AC7A1BDF84008456EBC263C7E366CBE7E39DAB318450B45B0C24EC3C141C5BBDE3E8EC3E54262C4B4C23340F83C113D99BDE2BF38C281C75E3842BB0C45EEC105B96CC1CDC1B147EC422E3CF4422C403BBB0A4408C085BC9AC6114249C46B2D2A4416C6743D97C09DB50CC405452DBD5DBCDA3D9FC0834712C55A3CEE3150BFFBC2E9C0CDC37ABAA54084388541983291C039BCAA3D80BBF33C0345C4C083BF6A3A764185A224C553AF9CC447413B3D82BB20BD63C55C3BDE41A83D304442C4FDBF33C480C28DB79EC0CA4538427140E741E94310403EBFB9C058339841DB325BBFACA76B344142A9437E3C74B8A1B704B519413B4434B4"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
  func.func private @expected() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x4C6764013E2A7D001C446B066264DB35495D3D5C9764A657F2381131C1083858364E52641E34792CE34790337A17B83C135E54643359CC3BA34E4D34FA500000175B9758BD2BD766712395544D4E1763DD3AA8418C4E392AB5366E4AEB01E53D1240912E315E67487951D864DD3A8E209B0802542A6B1156A5590C479858FC4CEE5C564B74606D4C1661644C5B2384246260A753194D1C677212BE2969591D46494D28592E50CC3E9154AD31635A85574E6B7D678C4870168854815DAD58171B1E551250A64FF63E8B403D4CC13A6951D240865106449A0006446000393417536939A140014FEE4908543F54E760393A81511858904A3818C75A3D3517333147CF103E6274400035865B1F68BC576A587C500E25226498374762F443B7355F30353C935FAD428D49F6551E4DE852E14F5552845E1452A6653F54AB540627C747632EBE34194D57614D4E414360529A41213F6D605424B249CF60F3525069D131F149D042A460C53F35605673B256D95114571D53273DF75C23481B3A203C5B40DB14E8644B61085426434E28B844C850C253F2683359A33ECB321C3CE94EEE52BE5AE2500000254E1444623447525A64093E0900B95BA04CEA4D0C5D5C61C52E7B5A3E2130400B521E315F53C0643B2E654343183F40363E324DD43D0B605850EA61484EA46D50490945453C06515001326A973C015A822C3E47F83DCD5F8456D402BC4CBA11AB49575E2023CF55DF3067559134013FDC3ED1588E5882643153B16275542A24204C16007E1C0055054E7149F620013A4455D75060422D3D414C2643DF34B038AD5EC3486D5C464FEF2D061FA242FA64774D4960D74EFA444B24021495133868D7308A5D625DD75EA9504D65EE4295393B10514F8D594364D500E231E2451136A420A83E90534F616352103D1B5E0B62E84A2C637E5AE64C4948C14A214FA444624D464BDB4F1868D23EA44C8552AB2C286C5063403DEF40AD64954B1B4BC958B8688C63C267995B8F59BE5D5F53605A1636142220592A5E75449F59D263FA50045C575E54640946535A2C3FAD4E3B633B5D1637B7599E485C51D4516A5A5E4E4C674E50DE377E2546571C54484EB259C0522726DC284C1FB5315C465C468B32716B72666D2CB55BC062373DEF0D1E4D825C975A014F2E492C43754C3C08EE2C03581952E834535092410A64544D854FBA4A315C3E4F083A126039254745602C0C5D7068CF5DDC5E8254DD0C77557F5E6C699936355C6D58CC1EEE3CB8341941945275024B59174B71314613EF5DC6333055414A0C07F0385736934F8B572633084CE634E069013F9754D24C5A495C6A0E642469D843C3500161053EA03CF126A6461D336D1B43610E61D0578F5947541F3B58485C5A6A58C35DE357DD4CC3402641AB438A4BD955326AB02D6C391161D454F630C0526D54D66A7C58C53C9158BC4C5739285C204C843E6C674B55445D5E03B35C5B65E842EF4EC223315CF6609A41A93D9544214F396A29619B3DD4149549A3588B503B5BDF36464F7F2E41536217CC4EF73C06442E3AB040EF600850394A9B36F352000074619F090E5F0F52D941353A64419462BA39A2540044CD5C225DF44BDD5CF956582A194F6264D955134EBE54A55B414C5F49C54FAF19A7535018B7490E00F31DFB55BA5A5E3E252E9D2AF2204651005DE11C"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
  func.func private @integer_pow(%arg0: tensor<20x30xf16>) -> tensor<20x30xf16> {
    %0 = stablehlo.multiply %arg0, %arg0 : tensor<20x30xf16>
    %1 = stablehlo.multiply %0, %0 : tensor<20x30xf16>
    return %1 : tensor<20x30xf16>
  }
}
