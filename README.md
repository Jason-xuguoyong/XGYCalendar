XGYCalendar

一款简单易用的日历控件，支持滚轮选择日期，一行代码搞定日期选择。

集成代码

1> 下载Demo，直接将XGYCalendar文件夹拖入工程

2> 采用cocopods集成 ，代码：pod 'XGYCalendar'

导入XGYCalendarTool.h 调用下面代码

[XGYCalendarTool showCalendarWithCalendarType:type defaultDate:nil completeBlock:^(NSInteger year, NSInteger month, NSInteger day) {
NSLog(@"%ld-%ld-%ld",year,month,day)；
}];
