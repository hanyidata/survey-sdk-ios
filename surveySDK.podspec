#
# Be sure to run `pod lib lint surveySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HYSurveySDK'
  s.version          = '0.3.1020'
  s.summary          = 'a tiny survey sdk for xmplus'

  s.swift_versions   = '4.0'

  s.homepage         = 'https://gitee.com/hanyidata/survey-sdk-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangjun' => 'yangjun@surveyplus.cn' }
  s.source           = { :git => 'https://gitee.com/hanyidata/survey-sdk-ios.git', :tag => s.version }

  s.ios.deployment_target = '11.0'

  s.source_files = 'surveySDK/Classes/*'
  
#  s.resource_bundles = {
#    'surveySDK' => ['surveySDK/Assets/*']
#  
  s.resources = ['surveySDK/Assets/*']
  
  s.frameworks = 'UIKit', 'WebKit', 'JavaScriptCore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
