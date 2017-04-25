Pod::Spec.new do |s|
  s.name     = 'ZYBannerView'
  s.version  = '1.1.2'
  s.license  = 'MIT'
  s.summary  = 'A banner view used on iOS.'
  s.homepage = 'https://github.com/zzyspace/ZYBannerView'
  s.author   = { 'zy_zhang' => '551854173@qq.com' }

  s.source   = { :git => 'https://github.com/zzyspace/ZYBannerView.git', :tag => 'v1.1.2' }

  s.description = %{
    Easy, customizable banner view, which implement by Objective-C
  }
  
  s.platform = :ios, '7.0'
  s.source_files = 'ZYBannerView/*'

  s.frameworks = 'Foundation', 'UIKit'

  s.requires_arc = true
end
