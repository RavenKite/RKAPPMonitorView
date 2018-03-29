//
//  RKViewController.m
//  RKAPPMonitorView
//
//  Created by RavenKite on 03/29/2018.
//  Copyright (c) 2018 RavenKite. All rights reserved.
//

#import "RKViewController.h"
#import <RKAPPMonitorView/RKAPPMonitorView.h>

@interface RKViewController ()

@end

@implementation RKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAppMonitorView];
}


- (void)createAppMonitorView {
    
#ifdef DEBUG
    RKAPPMonitorView *monitorView = [[RKAPPMonitorView alloc] initWithOrigin:CGPointMake(10, 100)];
//    [[UIApplication sharedApplication].keyWindow addSubview:monitorView];
    [self.view addSubview:monitorView];
#else
#endif
    
}


@end
