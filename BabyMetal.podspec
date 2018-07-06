Pod::Spec.new do |s|
  s.name             = 'BabyMetal'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BabyMetal.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/noppefoxwolf/BabyMetal'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'noppefoxwolf' => 'noppelabs@gmail.com' }
  s.source           = { :git => 'https://github.com/noppefoxwolf/BabyMetal.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/noppefoxwolf'

  s.ios.deployment_target = '10.0'

  s.source_files = 'BabyMetal/Classes/**/*' 
end
