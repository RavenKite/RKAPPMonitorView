# RKAppMonitorView

<!--[![CI Status](http://img.shields.io/travis/RavenKite/RKAPPMonitorView.svg?style=flat)](https://travis-ci.org/RavenKite/RKAPPMonitorView)-->
[![Version](https://img.shields.io/cocoapods/v/RKAPPMonitorView.svg?style=flat)](http://cocoapods.org/pods/RKAPPMonitorView)
[![License](https://img.shields.io/cocoapods/l/RKAPPMonitorView.svg?style=flat)](http://cocoapods.org/pods/RKAPPMonitorView)
[![Platform](https://img.shields.io/cocoapods/p/RKAPPMonitorView.svg?style=flat)](http://cocoapods.org/pods/RKAPPMonitorView)

## 介绍

一个实时监控App的FPS、CPU使用率和内存占用的小工具。

![AppMonitorViewDemo](https://github.com/RavenKite/RKImageHost/raw/master/AppMonitorViewDemo.gif)
<!--![AppMonitorViewDemo](https://github.com/RavenKite/RKImageHost/raw/master/AppMonitorViewDemo.png)-->


## 系统要求

此项目最低支持 `iOS 7.0`。


## 安装

此项目支持 [CocoaPods](http://cocoapods.org)安装。

1. 在Podfile中添加 `pod 'RKAPPMonitorView' `
2. 在终端中执行 `pod install` 或 `pod update`
3. 在项目中 `#import <RKAPPMonitorView/RKAPPMonitorView.h>`


## 使用方法

### Main Interface 为 Main.stroyboard

在 `keyWindow.rootViewController` 的 `- (void)viewDidAppear:(BOOL)animated` 中添加如下代码：

```
#ifdef DEBUG
    RKAPPMonitorView *monitorView = [[RKAPPMonitorView alloc] initWithOrigin:CGPointMake(10, 100)];
    [[UIApplication sharedApplication].keyWindow addSubview:monitorView];
#else
#endif

```

### Main Interface 为空 

即在AppDelegate中手动创建window。
在AppDelegate中添加如下代码：

```
#ifdef DEBUG
    RkAPPMonitorView *monitorView = [[RKAPPMonitorView alloc] initWithOrigin:CGPointMake(10, 100)];
    [self.window addSubview:monitorView];
#else
    
#endif
```


## 参考

此项目参考了[YYFPSLabel](https://github.com/ibireme/YYText/tree/master/Demo/YYTextDemo/YYFPSLabel.m)的实现。










