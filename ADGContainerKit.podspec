#
# Be sure to run `pod lib lint ADGContainerKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ADGContainerKit"
  s.version          = "0.1.0"
  s.summary          = "Easily manage N child view controllers using Interface Builder"
  s.description      = <<-DESC
Easily manage N child view controllers using Interface Builder
                       DESC
  s.homepage         = "https://github.com/alejandrogarin/ADGContainerKit"
  s.screenshots     = "https://github.com/alejandrogarin/ADGContainerKit/example.png"
  s.license          = 'MIT'
  s.author           = { "Alejandro Garin" => "agarin@gmail.com" }
  s.source           = { :git => "https://github.com/alejandrogarin/ADGContainerKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alejandrogarin'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ADGContainerKit' => ['Pod/Assets/*.png']
  }
end
