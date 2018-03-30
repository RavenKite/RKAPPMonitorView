
Pod::Spec.new do |s|
    s.name             = 'RKAPPMonitorView'
    
    s.version          = '0.0.1'
    
    s.summary          = '一个实时监控APP的FPS、CPU使用率和内存占用的小工具'
    
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    
    s.author           = { '李沛倬' => 'lipeizhuo0528@outlook.com' }
    
    s.homepage         = 'https://github.com/RavenKite/RKAPPMonitorView'
    
    s.source           = { :git => 'https://github.com/RavenKite/RKAPPMonitorView.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '7.0'
    
    s.source_files = 'RKAPPMonitorView/Classes/**/*'
        
    s.frameworks = 'UIKit', 'Foundation'
    
    s.requires_arc = true
    
end








