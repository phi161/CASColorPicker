Pod::Spec.new do |s|
  s.name                = "CASColorPicker"
  s.version             = "0.0.1"
  s.summary             = "A configurable RGB & HSB color picker for iOS"

  s.description  = <<-DESC
                   CASColorPicker provides an easy way to select any color by changing the RGB or HSB values.
                   It is inspired by the color picker in OSX and uses a block based API.
                   The picker is presented modally in a similar fashion to the UIAlertView instances and does not need a UIViewController.
                   DESC

  s.homepage            = "http://www.carminestudios.se"
  s.license             = 'MIT'
  s.authors             = { "phi" => "phi@carminestudios.se" }
  s.platform            = :ios, '7.0'
  s.source              = { :git => "https://github.com/phi161/CASColorPicker.git", :tag => s.version.to_s }
  s.source_files        = 'Classes'
  s.framework           = 'QuartzCore'
  s.requires_arc        = true
end
