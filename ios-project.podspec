
Pod::Spec.new do |s|
s.name             = "ios-project"
s.version          = "1.0.0"
s.summary          = "A qmcp view used on iOS."
s.description      = <<-DESC
It is a marquee view used on iOS, which implement by Objective-C.
DESC
s.homepage         = "https://github.com/xymlhn/ios-project"
s.license          = 'MIT'
s.author           = { "xym" => "a5595877@163.com" }
s.source           = { :git => "git@github.com:xymlhn/ios-project.git", :tag => s.version.to_s }
s.platform     = :ios, '7.0'

s.requires_arc = true

s.source_files = 'WZMarqueeView*.h'

s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end