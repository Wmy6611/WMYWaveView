//
//  ViewController.m
//  WMYWaveView
//
//  Created by Wmy on 2016/12/19.
//  Copyright © 2016年 Wmy. All rights reserved.
//

#import "ViewController.h"
#import "WMYWaveView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) WMYWaveView *waveView;
@property (nonatomic, strong) WMYWaveView *waveView2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.waveView2 wave];
}

- (void)viewDidLayoutSubviews {
    
    self.waveView = [WMYWaveView addToView:self.tableView.tableHeaderView
                                 withFrame:CGRectMake(0, CGRectGetHeight(self.tableView.tableHeaderView.frame) - 16, CGRectGetWidth(self.tableView.frame), 16.5)];
    
    
    self.waveView2 = [WMYWaveView addToView:self.view
                                  withFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    _waveView2.waveTime = 0.0;
    _waveView2.waveColor1 = [[UIColor greenColor] colorWithAlphaComponent:0.18];
    _waveView2.waveColor2 = [[UIColor greenColor] colorWithAlphaComponent:0.26];
    _waveView2.waveDirectionType = WaveDirectionTypeDown;
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.waveView wave];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu - %lu", indexPath.section, indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

