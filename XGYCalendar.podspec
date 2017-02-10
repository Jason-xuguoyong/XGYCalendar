
Pod::Spec.new do |s|

s.name         = "XGYCalendar"
s.version      = "1.0.1"
s.summary      = "一行代码搞定日期选择！支持翻页选择和滚动选择"
s.homepage     = "https://github.com/Jason-xuguoyong/XGYCalendar"
s.license      = "MIT"
s.author       = { "xuguoyong" => "346950787@qq.com" }
s.platform     = :ios
s.ios.deployment_target = "6.0"
s.source       = { :git => "https://github.com/Jason-xuguoyong/XGYCalendar.git", :tag => "#{s.version}" }
s.requires_arc = true
s.resources    = "calendar/XGYCalendar/imageResource/*.{png,xib,nib,bundle}"
s.source_files = "calendar/XGYCalendar/*.{h,m}"

end
