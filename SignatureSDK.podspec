#
# Be sure to run `pod lib lint SignatureSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SignatureSDK'
  s.version          = '1.0.5'
  s.summary          = 'To add Digital Signature'

  s.description      = 'Pod to use signature view in your iOS apps'

  s.homepage         = 'https://github.com/SharadGoyal/SignatureView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sharad goyal' => 'sharad.n.goyal@gmail.com' }
  s.source           = { :git => 'https://github.com/SharadGoyal/SignatureView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sign/**/*.h'
  
  # s.resource_bundles = {
  #   'SignatureSDK' => ['SignatureSDK/Assets/*.png']
  # }

  #s.public_header_files = 'Pod/Classes/**/*.h'
  #s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
