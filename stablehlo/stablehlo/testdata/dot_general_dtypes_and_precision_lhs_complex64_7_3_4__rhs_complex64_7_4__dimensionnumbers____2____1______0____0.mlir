// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<7x3x4xcomplex<f32>>, tensor<7x4xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<7x3xcomplex<f32>>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0], rhs_batching_dimensions = [0], lhs_contracting_dimensions = [2], rhs_contracting_dimensions = [1]>} : (tensor<7x3x4xcomplex<f32>>, tensor<7x4xcomplex<f32>>) -> tensor<7x3xcomplex<f32>>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<7x3xcomplex<f32>>, tensor<7x3xcomplex<f32>>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<7x3x4xcomplex<f32>>, tensor<7x4xcomplex<f32>>) {
    %0 = stablehlo.constant dense<[[[(-3.84035707,-3.90383267), (3.06119084,-3.59459877), (4.60025263,2.47663403), (-0.304422408,0.373871326)], [(1.83912992,0.108431868), (-2.39568663,5.68423176), (-2.45870638,-1.83465803), (0.0965518504,1.56482601)], [(-0.488670319,1.38202262), (0.256098717,3.545860e+00), (2.89401388,2.62080836), (0.218326673,2.53808713)]], [[(-1.27674663,4.85361576), (-2.04704738,-2.20137596), (-0.357429147,-0.769799471), (1.8493464,0.379334897)], [(-2.40833187,2.99841547), (-2.30164075,0.71570295), (1.28983033,0.889702082), (0.556421518,-0.915008962)], [(5.90219831,6.38380194), (0.908229291,-2.02848673), (-4.62092686,1.77413321), (-3.93122983,3.74480438)]], [[(-2.7007246,1.97147226), (-1.175250e+00,-4.43357563), (-3.68697548,0.740948796), (1.40545785,-2.71587062)], [(-0.490364164,3.33461905), (0.723777711,0.0187796075), (2.96147943,-1.59467387), (-2.10491467,-3.28925586)], [(1.79511213,3.53926182), (-1.2248137,0.113176435), (-2.30574703,-0.142826036), (7.48364734,1.24495387)]], [[(0.686234414,-0.48870346), (4.55279064,1.17234647), (-0.690186739,-0.222737044), (-3.80726671,-0.609188616)], [(0.324496299,4.083580e-02), (1.72417498,0.693657696), (-2.34786224,-1.0463841), (-0.919421195,-2.19010925)], [(-0.188088968,11.0797052), (1.66132355,-3.33341122), (4.56153822,-6.39184093), (1.61911368,-1.06775498)]], [[(-1.14398313,1.87192237), (5.47974396,2.16735601), (-4.12196159,1.44122398), (-4.68681049,1.87779808)], [(-0.030887669,-1.80758178), (0.142558381,0.657000124), (-0.948857605,1.13833368), (1.99782872,-0.76933813)], [(2.91862607,-6.18883133), (-1.77319121,1.21489906), (-2.02352929,5.4308238), (-1.47991979,1.49809468)]], [[(-0.0564146154,6.52858353), (-1.61566758,1.13341403), (4.74482965,5.6663084), (0.997977256,-0.12731643)], [(2.8041954,-1.54076576), (1.91767156,-0.131969854), (2.86145902,1.34527254), (1.97893727,2.82752347)], [(5.09832048,2.22923017), (1.84301615,0.952687621), (2.17576838,-2.3489058), (-0.235499859,5.94303798)]], [[(-2.89080644,-1.66954255), (2.67089057,2.18003631), (-0.718997299,-4.06275082), (1.76139414,-0.862277984)], [(-1.94684756,3.02045321), (3.18127489,3.66796231), (-1.7693485,-2.74181294), (1.56785667,-0.627871513)], [(-4.18271112,-0.536917448), (0.043692898,-1.89799523), (-1.8427707,-6.3454442), (-1.60001218,-4.26831102)]]]> : tensor<7x3x4xcomplex<f32>>
    %1 = stablehlo.constant dense<[[(-4.20059967,1.35713112), (-4.85108709,-3.37819028), (4.13157225,-0.644313514), (-2.88270664,0.699763238)], [(-1.43678308,-0.932170093), (2.97528863,1.36016881), (0.918086946,-0.703483641), (3.30895686,0.189052299)], [(-7.80921412,-4.50272751), (-5.4562583,-0.904727578), (-5.26155329,3.03180313), (4.42845106,0.863666176)], [(3.94316769,4.65901852), (-0.656266928,0.122121021), (2.68418145,-2.7184732), (-1.68548322,-0.946554899)], [(1.54940772,-4.14672232), (-3.01536441,-3.35452437), (4.72537899,-0.736492156), (-0.80649507,-1.15973377)], [(2.0162282,-1.8710525), (0.982750594,7.482630e-01), (-2.7995913,0.224452049), (1.33000493,-3.0105412)], [(2.35928512,3.45091939), (1.70024705,-4.58296156), (-3.66474986,2.93342519), (2.66190243,-0.501201391)]]> : tensor<7x4xcomplex<f32>>
    return %0, %1 : tensor<7x3x4xcomplex<f32>>, tensor<7x4xcomplex<f32>>
  }
  func.func private @expected() -> tensor<7x3xcomplex<f32>> {
    %0 = stablehlo.constant dense<[[(15.6544161,2.426060e+01), (10.2377415,-27.880373), (22.1533718,-22.7353153)], [(8.44049072,-13.9679775), (2.25798845,-6.0773778), (-13.7786331,-2.94623756)], [(58.0912437,-3.87098503), (-2.31582499,-23.6052361), (53.333786,-29.4936485)], [(5.23416424,6.965710e+00), (-9.79698562,9.56378173), (-61.917141,15.9131393)], [(-15.7218742,-3.50601196), (-11.9181452,-0.750506639), (-14.3502407,8.25421428)], [(-3.94568706,-4.79855633), (7.58589172,-12.3691072), (27.5632477,12.9483099)], [(32.2826233,-12.8471289), (25.5884895,-5.5348587), (2.32932043,-11.8393087)]]> : tensor<7x3xcomplex<f32>>
    return %0 : tensor<7x3xcomplex<f32>>
  }
}

