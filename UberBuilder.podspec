Pod::Spec.new do |s|
  s.name = "UberBuilder"
  s.version = "1.0.0"
  s.summary = "UberBuilder is a small set of macros provided to make building flexible, immutable objects a simple task."
  s.license = { :type => "Copyrighted", :file => "LICENSE.md" }
  s.homepage = "https://github.com/uber-common/UberBuilder"
  s.authors = { "Uber iOS Team" => "mobile-ios-eng@uber.com" }
  s.source = { :git => "https://github.com/uber-common/UberBuilder.git", :tag => "v#{s.version.to_s}" }
  s.requires_arc = true

  s.ios.deployment_target = "7.0"
  
  s.frameworks  = "Foundation"

  s.subspec 'Core' do |ss|
    ss.source_files = 'UberBuilder/Source/UBBuilder.{h,m}'
  end

  s.subspec 'TestsSupport' do |ss|
    ss.source_files = 'UberBuilder/Source/UBBuilderTestFixture.{h,m}'
  end
end
