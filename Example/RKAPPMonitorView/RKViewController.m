//
//  RKViewController.m
//  RKAPPMonitorView
//
//  Created by RavenKite on 03/29/2018.
//  Copyright (c) 2018 RavenKite. All rights reserved.
//

#import "RKViewController.h"
#import <RKAPPMonitorView/RKAPPMonitorView.h>

@interface RKViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation RKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self createAppMonitorView];
}


- (void)createAppMonitorView {
    
#ifdef DEBUG
    RKAPPMonitorView *monitorView = [[RKAPPMonitorView alloc] initWithOrigin:CGPointMake(10, 100)];
    [[UIApplication sharedApplication].keyWindow addSubview:monitorView];
#else
#endif
    
}


// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Section: %ld  Row: %ld", indexPath.section, indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"Header"];
    }
    
    header.textLabel.text = [NSString stringWithFormat:@"Section: %ld", section];
    
    return header;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end




















