#
# Be sure to run `pod lib lint MTMacTemplatePod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MTViewControllerTreeWindowController"
  s.version          = "0.1.0"
  s.summary          = "MTViewControllerTreeWindowController is an experimental window class to manage Mac OS X window layouts in a nested tree of stack views, split views and regular view controllers."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  You probably don't want to use this at this point.
                       DESC

  s.homepage         = "https://github.com/mathieutozer/MTViewControllerTreeWindowController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Mathieu Tozer" => "mathieutozer@gmail.com" }
  s.source           = { :git => "https://github.com/mathieutozer/MTViewControllerTreeWindowController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :osx, '10.11'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MTViewControllerTreeWindowController' => ['Pod/Assets/*']
  }
  s.resources = 'Pod/Assets/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
