#
# Be sure to run `pod lib lint surveySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HYSurveySDK'
  s.version          = '0.2.108'
  s.summary          = 'a tiny survey sdk for xmplus'

# This description is used to generate tags and improve search results3000.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
体验家(xmplus.cn) survey sdk for ios
                       DESC

  s.swift_versions   = '4.0'

  s.homepage         = 'https://gitee.com/hanyidata/survey-sdk-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangjun' => 'yangjun@surveyplus.cn' }
  s.source           = { :git => 'https://gitee.com/hanyidata/survey-sdk-ios.git', :tag => '0.2.108' }

  s.ios.deployment_target = '11.0'

  s.source_files = 'surveySDK/Classes/*'
  
#  s.resource_bundles = {
#    'surveySDK' => ['surveySDK/Assets/*']
#  }
  s.resources = ['surveySDK/Assets/*']
  
  s.frameworks = 'UIKit', 'WebKit', 'JavaScriptCore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
