//
//  ViewController.m
//  UITableViewSectionHeaderHeightBug
//
//  Created by Heath Borders on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface UITableView (LogHeaderFooterMetrics)

- (void) logHeaderFooterMetrics;

@end

@implementation UITableView (LogHeaderFooterMetrics)

- (void) logHeaderFooterMetrics {
    NSLog(@"sectionHeaderHeight: %f", self.sectionHeaderHeight);
    NSLog(@"sectionHeaderRect: %@", NSStringFromCGRect([self rectForHeaderInSection:0]));
    NSLog(@"sectionHeaderHeight matches sectionHeaderRectHeight? %d", 
          self.sectionHeaderHeight == CGRectGetHeight([self rectForHeaderInSection:0]));
    NSLog(@"sectionFooterHeight: %f", self.sectionFooterHeight);
    NSLog(@"sectionFooterRect: %@", NSStringFromCGRect([self rectForFooterInSection:0]));
    NSLog(@"sectionFooterHeight matches sectionFooterRectHeight? %d", 
          self.sectionFooterHeight == CGRectGetHeight([self rectForFooterInSection:0]));
}

@end

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *plainTableView;
@property (nonatomic, strong) UITableView *groupedTableView;

@end

@implementation ViewController

@synthesize plainTableView = _plainTableView;
@synthesize groupedTableView = _groupedTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect plainTableViewFrame;
    CGRect groupedTableViewFrame;
    
    CGRectDivide(self.view.bounds, 
                 &plainTableViewFrame, 
                 &groupedTableViewFrame, 
                 CGRectGetHeight(self.view.bounds) / 2, 
                 CGRectMinYEdge);
    
    self.plainTableView = [[UITableView alloc] initWithFrame:plainTableViewFrame
                                                       style:UITableViewStylePlain];
    self.plainTableView.dataSource = self;
    self.plainTableView.delegate = self;
    [self.view addSubview:self.plainTableView];
    
    self.groupedTableView = [[UITableView alloc] initWithFrame:groupedTableViewFrame
                                                       style:UITableViewStyleGrouped];
    self.groupedTableView.dataSource = self;
    self.groupedTableView.dataSource = self;
    [self.view addSubview:self.groupedTableView];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"Plain metrics:");
    [self.plainTableView logHeaderFooterMetrics];
    NSLog(@"");
    
    NSLog(@"Grouped metrics:");
    [self.groupedTableView logHeaderFooterMetrics];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    if (tableView == self.plainTableView) {
        identifier = @"plain";
    } else {
        identifier = @"grouped";
    }
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:identifier];
    }
    
    tableViewCell.textLabel.text = identifier;
    return tableViewCell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Header";
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Footer";
}

@end
