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
  s.version          = "0.2.0"
  s.summary          = "A short description of touchin-analytics."
  s.description      = <<-DESC
                       An optional longer description of touchin-analytics

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/touchinstinct/touchin-trivia"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "alarin" => "me@alarin.ru" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/touchin-analytics.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

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
  s.dependency 'Crashlytics'
end
