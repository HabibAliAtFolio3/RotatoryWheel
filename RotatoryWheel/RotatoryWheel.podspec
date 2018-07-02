#
# Be sure to run `pod lib lint RotatoryWheel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RotatoryWheel'
  s.version          = '0.1.0'
  s.summary          = 'This pod allows you to rotatory wheel control'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = "This pod allows you to rotatory wheel control. It can be rendered as complete or semi circle. Selected Item can be extracted via delegate. Selected Item scale ratio can be controlled via scale variable"

  s.homepage         = 'https://github.com/HabibAliAtFolio3/RotatoryWheel.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Habib Ali' => 'habibali@folio3.com' }
  s.source           = { :git => 'https://github.com/HabibAliAtFolio3/RotatoryWheel.git', :tag => s.version.to_s }
  s.swift_version    = '4.1'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'RotatoryWheel/Classes/**/*'
end
