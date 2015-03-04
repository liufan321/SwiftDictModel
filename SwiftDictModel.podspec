Pod::Spec.new do |s|
  s.name         = "SwiftDictModel"
  s.version      = "0.1.4"
  s.summary      = "JSON and Model Conversion Tool in Swift"
  s.homepage     = "https://github.com/liufan321/SwiftDictModel"
  s.license      = "MIT"
  s.author             = { "Fan Liu" => "liufan321@gamil.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/liufan321/SwiftDictModel.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.requires_arc = true
end
