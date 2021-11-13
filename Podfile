 source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'

# M1芯片，模拟器运行配置
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

target 'SwiftCase' do
  use_frameworks!

  # 网络库
  pod 'Moya/RxSwift'
  #pod 'ObjectMapper'
  pod 'HandyJSON'
  pod 'SwiftyJSON'
  
  # UI布局
  pod "SnapKit"
  pod "R.swift"
  
  # 图片库
  pod "Kingfisher"
  
  # gRPC库
  pod 'gRPC-Swift'
  pod 'gRPC-Swift-Plugins'
  pod 'Socket.IO-Client-Swift'

  pod 'Toast-Swift'
  pod 'Then'
  
  # 代码格式插件
  pod 'SwiftFormat/CLI'
  # 输入框随键盘移动
  pod 'IQKeyboardManagerSwift'

  # 高德地图,定位SDK/3D地图SDK
  pod 'AMapLocation'
  pod 'AMap3DMap'
  
  #pod 'PullToRefresher'
  #pod 'SwiftyUserDefaults'
  #pod 'Whisper'
  #pod 'Hue'
  #pod 'Dollar'

end