#source 'https://cdn.cocoapods.org/'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.3'

# M1芯片，模拟器运行配置
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

target 'SwiftCase' do
  use_frameworks!

  # 网络库及Module解析
  pod 'Moya/RxSwift'
  # Parsing gigabytes of JSON per second
  pod 'ZippyJSON'
  pod 'BetterCodable'
  
  # 编程框架
  pod 'Then'
  # pod 'RxSwift'
  pod 'RxCocoa'
  
  # UI布局
  pod "SnapKit"
  pod "R.swift"
  # Flexbox 布局
  pod "YogaKit"
  
  # 图片库
  pod "Kingfisher"
  # 微信样式的图片、视频选择器
  pod 'ZLPhotoBrowser'
  
  # gRPC库
  pod 'gRPC-Swift'
  pod 'gRPC-Swift-Plugins'
  pod 'Socket.IO-Client-Swift'

  pod 'Toast-Swift'
  
  # 代码格式插件
  pod 'SwiftFormat/CLI'
  # 输入框随键盘移动
  pod 'IQKeyboardManagerSwift'

  # 高德地图,定位SDK/3D地图SDK
  pod 'AMapLocation'
  pod 'AMap3DMap'
  
  # 分类切换滚动视图
  pod 'JXSegmentedView'
  # 提供加密相关的方法
  pod 'CryptoSwift'
  
  # 基础工具库
  # pod 'SpeedySwift'

end
