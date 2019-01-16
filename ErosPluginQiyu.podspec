# coding: utf-8

Pod::Spec.new do |s|
  s.name         = "ErosPluginQiyu"
  s.version      = "0.0.4"
  s.summary      = "Eros QiYu Plugin"
  s.static_framework = true

  s.description  = <<-DESC
                   Weexplugin Source Description
                   DESC

  s.homepage     = "https://github.com"
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
            copyright
    LICENSE
  }
  s.authors      = {
                     "dmlzj" =>"284832506@qq.com"
                   }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"

  s.source       = { :git => 'https://github.com/dmlzj/eros-plugin-ios-qiyu.git', :tag => s.version }
  s.source_files  = "Sources/*.{h,m,mm}"
  
  s.requires_arc = true
  s.dependency "QIYU_iOS_SDK"
  s.xcconfig = {
    'VALID_ARCHS' =>  'arm64 x86_64',
  }
end

