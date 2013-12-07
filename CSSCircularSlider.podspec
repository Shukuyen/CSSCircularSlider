Pod::Spec.new do |s|

  s.name         = "CSSCircularSlider"
  s.version      = "0.1"
  s.summary      = "A round slider control that uses a masked background image as the slider track."

  s.description  = <<-DESC
                   CSSCircularSlider can be used to display a control similar to a UISlider. Instead of the normal linear slider track you will get a circular track with minimum and maximum value on the top position. The user can drag the slider clockwise.
                   In contrast to other circular sliders this will use a background image you specify as the slider track. The track is in fact a path that masks the background image, so only the active part of the slider will show the background.

                   ## How to use

                   You can alloc/init the slider with a frame or just place a UIView in your storyboard or XIB file and change the class to CSSCircularSlider.
                   Then you need to specify a `circleBackgroundImage` that will be used to display the slider track. It also makes sense to add your view controller as a target to the `UIControlEventValueChanged` control event. Have a look at the header file for other optional parameters.
                   DESC

  s.homepage     = "https://github.com/shukuyen/csscircularslider"
  s.license      = 'MIT'
  s.author       = { "Cornelius Schiffer" => "shukuyen@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/shukuyen/csscircularslider.git", :tag => '0.1' }
  s.source_files  = 'CSSCircularSlider/CircularSlider/*.{h,m}'
  s.requires_arc = true

end
