
Pod::Spec.new do |s|

  s.name         = "NSDate+SRGFekable"
  s.version      = "0.0.2"
  s.summary      = "A category to fake current date for unit tests." 
  s.homepage     = "https://github.com/soragoto/NSDate-SRGFekable"
  s.license      = "MIT"
  s.author       = { "Norihiro Sakamoto" => "nori0620@gmail.com" }
  s.source       = { :git => "https://github.com/soragoto/NSDate-SRGFekable.git", :tag => "0.0.2" }
  s.platform     = :ios, '6.0'
  s.source_files = "Classes", "Classes/**/*.{h,m}"
  s.resources    = ['Classes/SRGFakableViewController.xib']
  s.requires_arc = true

end
