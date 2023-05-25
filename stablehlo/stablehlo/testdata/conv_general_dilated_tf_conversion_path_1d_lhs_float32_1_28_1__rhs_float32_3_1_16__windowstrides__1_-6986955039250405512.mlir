// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x28x1xf32>, tensor<3x1x16xf32>)
    %1 = call @expected() : () -> tensor<1x24x16xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, 0, f]x[0, i, o]->[b, 0, f], window = {rhs_dilate = [2]} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<1x28x1xf32>, tensor<3x1x16xf32>) -> tensor<1x24x16xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<1x24x16xf32>, tensor<1x24x16xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x28x1xf32>, tensor<3x1x16xf32>) {
    %0 = stablehlo.constant dense<[[[-2.70618963], [-1.87663591], [-2.06809068], [3.13180709], [-5.647770e-01], [-6.40476512], [-3.12457585], [4.29680347], [-4.77720356], [-2.14421678], [-4.62567759], [-4.25790119], [-0.796836376], [2.05816221], [1.44689882], [3.84717488], [-3.75239062], [1.88363218], [4.10074186], [-1.20101893], [5.12631035], [-1.34320879], [7.59781837], [6.43065262], [-0.807578682], [-2.5147438], [-1.34953046], [-0.217908949]]]> : tensor<1x28x1xf32>
    %1 = stablehlo.constant dense<[[[5.97360468, 0.565488756, 1.90250754, 1.16698813, -1.0267024, 0.539800227, 1.02096438, 7.50488281, 3.29065299, 2.80925131, -1.00724733, 2.50891948, 1.9983573, -3.58216739, -1.08878911, -0.526236176]], [[1.58082891, -2.48857307, -0.902140557, 2.64325571, 4.98374081, 1.6286974, -0.793671488, 2.73143911, -0.955305993, 4.765710e-02, 2.02940774, 1.60887933, 2.17747688, 3.31030536, -0.812408626, -3.16653347]], [[-2.33335423, -0.416958928, 1.38901448, 0.764225184, -2.18225026, -2.79969263, -1.53878593, -6.03682947, 1.99186349, 4.33513737, -5.87947845, 0.59931469, 1.81237674, -4.62853718, 1.41328144, 0.307831258]]]> : tensor<3x1x16xf32>
    return %0, %1 : tensor<1x28x1xf32>, tensor<3x1x16xf32>
  }
  func.func private @expected() -> tensor<1x24x16xf32> {
    %0 = stablehlo.constant dense<"0xFBEF90C14D8376407F2782C033E610C1F277C9C07EDD4FC0734381BE6D64B4C1F3DE00C1956322C10DB9EC3F514927C1B5F42EC18EC9AE40C3047540BB90F94066F60A41CBE6C5C0DAAB74C1B5C3983FE217FC412E27B041D386AE401F8A04429A65AFC18B8D03C24B9C3742AF8460C01A9E08C1FBEF3A4232D818C1856A2EC1CB97BEC046F8C43FF47BF8C0D169C9C02B12C440CCC5D64049454940EF48E63F3FD547C1AE0E9BC15C769A41B609FFC05F6830C1CC01A0414349DABFB819F53FEFA7B8BFB1B07E4109A38D41D4DA1FC11C0C32C2322AA6C1EC9DD53F846F9FC1DFDCC741D4F5D84151A925C2642B033EDA1ECC3DB33B51C249B6FB40EAA49F41E55B3540112C174174859CC0A01A49C1362692C01863FF40DF11144125878041BD3906C11090B3C1BB85B241DBE914C129B984C120A95C418B4866C005880B41E1B5D3C11CBB56C1795198C18AA70F4038AD02426AB4184123CBD4C01C17BBC1E59CEBC198AAD8C16539DE41980E27C1BD86EAC0735D3C425D93E73E6B542EC1FAC676C1B9CD404191F500C15E789EC15D1828C1E7EC5E402305F7403C2E09C127E96EC17877E8C1F230A541426192C1E83CC8C19C4F8641ACE33E3F698F754111DA0042C6A81841CC3B8640AE127AC05ECAB9C09AF72B413F404A41B2605042C39BF640DCADCFC0A4D6824150EB9840A12873C0BD0C32C05C430FC1D7F14D40FEF507C22A46124117B8C0C0384993C1AF4683C1A036FCC02C73A43CFDB42EC2C5364EC1FCC288C1C118E03D1F3E9FC11881A8C1FFA1AF4032A9FA40FD538741B3BCC2C108680841CBB8274010F242C1F214BCC10BAC5DC1EC09FDBF999620C2303F8E3FDB882C404FA894C132F22FC13A381DC16D0B7FC1843D0B415DEA7341301201C2E3379EBFE54BC2C04EC1CCC02C4A18C0500FFBC05A22CAC0648136C2854039C13D53D8C095E0AEC03A5340C152B405C16586E740D950F740CFE3AC401244F9C1072412C118A393C0FB545A406478C740A7791BC10F693EC1703B46C2CC0705C13B119A40D97562C1731AA2C02C803C40A74888409D6A064133E845C0180EC94076261FC0E28800C1A7CDDC3CEDBD814158E9464172FB7340F7FEA44151A837C1567E93C19168CE4150C8F5BFBAC2A7C0E618C841E38DB3C06828AAC0F7B25F41CB2013C179ED4340C02A6041BF314F414A9C06400F7076C0B4556941562EDB40C218624149E4AAC077B747417E767E41C0C556C0ED122DC097F74AC1EE6DDBC0B6240741B1573D417213A3C02415E9C1857D86C1FB68EDBF372BC1C1C21C8441244EAD4120BB04C2E86F4F3DEBC60940125712C27298E840C1204641C417E64143B800C067E97C4096CF0841D7EF0041E71C084194FD884067122542F57C0741961BB6407349E04073683F416DCE19419D51FEBF4E53EDC0B8BD05C15F27DFC1256E67C1B5F16DC02A0C2641C9A45141262E1BC17A956FC1C1A03FC261BDC1C058093E41944E90C133C7823E198B2B414F805240D6F7FF4055EB16C16BCD47415FA69340BE493340223000C0FB9F9FC0888F3440142F9E409BB797418B729540CEB016BFB7036440DD89FE3FAE88A4BF3D3290C0B24D3EC08F7E19402FF26D4136B359C136B05B410B23C1416C3E98401B572BC1482C39C183628BBF8FD8BD41C0CE3242DB9719C25BB7B84156820442F58B03C243EF0640FA6980C11B6CC2C1F4E091BCA07DFB40AED019BD8DF49BC1FFB7A6C172E320C13A034EC2873D2241AE84C341E14C1DC2C600A9BF7E8ECA400245EFC1A0CB374131ADDB40321232420AC17AC15C6EE33FCE95CB4175750942BC388B415781E43E7C338042850800410E3234415C0F7041D4CFC441DB98CA414969284151534EC13A0AD8C1F1270041416D7BC1EA983DC1E62258418EA91B42F04F864131C126C0B952B541262879C137E665C18B82E9413302AF40D857D84055F41642C01BEAC0F270A3C1DD083D4203CEDB406AF154412A6BB64051160EC1870ED24057982741DAD87B4277AEB841E348774176BAADBF40A2874139A92F412C26BDC1AF6018C125A0EDBFFDC90B4262C41F4196346341B9DB303FFF4695C1D41B6CBCBB580E41E5D42A42E908B941A7018841C8CA24C1D0513F41415CDF402AD0F2C1EB87A8C07B619040"> : tensor<1x24x16xf32>
    return %0 : tensor<1x24x16xf32>
  }
}

