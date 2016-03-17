#
# Be sure to run `pod lib lint touchin-analytics.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "touchin-trivia"
  s.version          = "0.3.2"
  s.license          = 'MIT'
  s.author           = { "alarin" => "me@alarin.ru" }
  s.source           = { :git => "https://github.com/wayd-labs/touchin-trivia.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.public_header_files = 'Pod/Classes/*.h'
  s.source_files = 'Pod/Classes'
#  s.resources = 'Pod/Assets'
  s.resource_bundles = {
    'TITrivia' => ['Pod/Assets/*.xib', 'Pod/Assets/*.lproj']
  }

  s.frameworks = 'UIKit'
  s.dependency 'Aspects', '~> 1.4'
  s.dependency 'Fabric'
  s.dependency 'Crashlytics'
  s.pod_target_xcconfig = {
     'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/Crashlytics',
     'OTHER_LDFLAGS'          => '$(inherited) -undefined dynamic_lookup'
  }  
end
