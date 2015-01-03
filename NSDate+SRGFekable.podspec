
Pod::Spec.new do |s|

  s.name         = "NSDate+SRGFekable"
  s.version      = "0.0.1"
  s.summary      = "NSDate+SRGFekable is a category to fake results of NSDate. You can test your app features that depend on date more easily." 
  s.homepage     = "https://github.com/soragoto/NSDate-SRGFekable"
  s.license      = "MIT"
  s.author       = { "Norihiro Sakamoto" => "nori0620@gmail.com" }
  s.source       = { :git => "https://github.com/soragoto/NSDate-SRGFekable.git", :tag => "0.0.1" }
  s.platform     = :ios, '6.0'
  s.source_files = "Classes", "Classes/**/*.{h,m}"
  s.requires_arc = true

end
