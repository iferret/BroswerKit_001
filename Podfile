# Uncomment the next line to define a global souce for your project
source 'https://github.com/CocoaPods/Specs.git'
# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
# Uncomment the next line to inhibit all warnings for your project
inhibit_all_warnings!


target 'BroswerKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for BroswerKit
  pod 'SnapKit', '~> 5.0.1'
  pod 'DTCoreText', '~> 1.6.25'
  pod 'Hero', '~> 1.5.0'
  
end

target 'BrowserKitDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BrowserKitDemo
  pod 'SnapKit', '~> 5.0.1'
  pod 'DTCoreText', '~> 1.6.25'
  pod 'Hero', '~> 1.5.0'
  pod 'RxSwift', '~> 6.0.0'
  pod 'RxCocoa', '~> 6.0.0'
  
end

#  IPHONEOS_DEPLOYMENT_TARGET => 11.0
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
