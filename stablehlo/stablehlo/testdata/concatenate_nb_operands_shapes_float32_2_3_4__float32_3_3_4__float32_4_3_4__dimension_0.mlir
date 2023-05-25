// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:3 = call @inputs() : () -> (tensor<2x3x4xf32>, tensor<3x3x4xf32>, tensor<4x3x4xf32>)
    %1 = call @expected() : () -> tensor<9x3x4xf32>
    %2 = stablehlo.concatenate %0#0, %0#1, %0#2, dim = 0 : (tensor<2x3x4xf32>, tensor<3x3x4xf32>, tensor<4x3x4xf32>) -> tensor<9x3x4xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<9x3x4xf32>, tensor<9x3x4xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x4xf32>, tensor<3x3x4xf32>, tensor<4x3x4xf32>) {
    %0 = stablehlo.constant dense<[[[-2.26524949, 4.13549185, -3.93232751, 0.0129595874], [3.29843783, -0.05902173, 4.98384953, 1.08036947], [0.394151777, 1.64334786, 6.38778257, -2.62825537]], [[-1.37326288, 0.985913932, -3.15103865, 3.31258512], [0.842203319, -0.790435969, 4.45213795, 1.60510063], [-0.580112755, -0.269174188, -4.62132263, -1.00061679]]]> : tensor<2x3x4xf32>
    %1 = stablehlo.constant dense<[[[1.58971918, 1.73574615, 5.62964058, 3.64908957], [1.90634048, 1.44257617, 0.0283751264, 1.41224062], [1.15811622, 0.942835688, 2.81846881, -4.5966177]], [[0.64786303, 3.86002398, 2.57724786, -3.07303786], [-1.01332068, 6.3312459, 3.37795544, -2.49982738], [3.864810e-01, 3.37616706, 1.53272843, -0.753007889]], [[2.57361484, -3.55946159, -2.62887621, 4.565140e+00], [-1.30927706, 0.152888477, 1.52441061, -0.917696238], [1.94239938, 0.0318252891, -0.649473548, 4.5393815]]]> : tensor<3x3x4xf32>
    %2 = stablehlo.constant dense<[[[-5.16786766, 6.50578451, -1.86266422, -2.23986983], [-0.442623317, -0.257869422, -1.64277303, -0.933740437], [2.12045932, -0.979061543, -2.74745965, -2.23083448]], [[-1.16717243, 0.341617048, -1.968100e+00, 5.61058617], [-0.197793782, 3.80022573, 0.20694232, -1.37411666], [0.286780417, -2.91794276, -2.18207049, -2.57727861]], [[-5.7658081, 7.1025238, -1.63869941, -2.02040458], [3.86643529, -1.47237504, 2.48785663, 0.597370386], [-1.14864278, -1.27678704, -3.1078279, -4.2712636]], [[0.0763856322, 4.56232452, 1.71189439, 0.722239553], [-1.04227805, 3.34955835, -0.953805625, 4.14320707], [2.42109895, 3.77610946, 3.4244771, -0.280016184]]]> : tensor<4x3x4xf32>
    return %0, %1, %2 : tensor<2x3x4xf32>, tensor<3x3x4xf32>, tensor<4x3x4xf32>
  }
  func.func private @expected() -> tensor<9x3x4xf32> {
    %0 = stablehlo.constant dense<"0xD9F910C0F355844041AB7BC07354543C9B195340C5C071BDB27B9F408C498A3F43CEC93E3959D23FB768CC40563528C014C7AFBFDB647C3F9EAA49C065015440A39A573F035A4ABFEA778E40F073CD3F458214BF33D189BEE0E193C0361480BFEB7BCB3FEE2CDE3F0426B440AF8A6940F702F43F56A6B83FF472E83C4DC4B43F273D943FAE5D713FCB6134407E1793C05ADA253FA20A7740A1F12440A7AC44C07EB481BF9199CA406C3058402CFD1FC0D6E0C53E1F1358407230C43F20C540BF1BB6244038CE63C0823F28C0A01592406496A7BFCC8E1C3EE31FC33F24EE6ABF8BA0F83F3C5B023DE64326BF9D4291402C5FA5C0632FD040C86BEEBF075A0FC0869FE2BE760784BE6346D2BF9D096FBF9BB50740C7A37ABF61D62FC0FEC50EC0E86595BF6EE8AE3EB3EAFBBFEC89B340748A4ABEE6367340B0E8533E0EE3AFBFE2D4923E93BF3AC00BA70BC022F224C08081B8C0E047E340E7C0D1BF4F4E01C0AD737740C976BCBF0B391F4044ED183FBA0693BFC26DA3BFA7E646C031AE88C012709C3D90FE91405B1FDB3FB1E4383F5E6985BF2A5F56409B2C74BF2795844049F31A40C7AB7140A22A5B40485E8FBE"> : tensor<9x3x4xf32>
    return %0 : tensor<9x3x4xf32>
  }
}
