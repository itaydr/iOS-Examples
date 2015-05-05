//
//  SOMainViewController.m
//  ShowOff
//
//  Created by Itay Dressler on 5/5/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOMainViewController.h"
#import "SOMainTableViewCell.h"

static NSString * const kCellIdentifier = @"exampleCell";

@interface SOMainViewController ()

@property (nonatomic, strong)   NSArray     *items;

@end

@implementation SOMainViewController

#pragma mark LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self configureTitleView];
}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SOMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                              forIndexPath:indexPath];
    
    cell.textLabel.text = [self.items[indexPath.row] firstObject];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [self viewControllerForRowAtIndexPath:indexPath];
    viewController.title = [self titleForRowAtIndexPath:indexPath];
    viewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark Private 

- (void)setupTableView {
    self.items = @[@[@"Collection Layout", [UIViewController class]]
                   ];
    [self.tableView registerClass:[SOMainTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50.f;
}

- (void)configureTitleView
{
    UILabel *headlinelabel = [UILabel new];
    headlinelabel.font = [UIFont fontWithName:@"Avenir-Light" size:28];
    headlinelabel.textAlignment = NSTextAlignmentCenter;
    //headlinelabel.textColor = [UIColor customGrayColor];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor greenColor]
                             range:NSMakeRange(1, 1)];
    
    headlinelabel.attributedText = attributedString;
    [headlinelabel sizeToFit];
    
    [self.navigationItem setTitleView:headlinelabel];
}

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items[indexPath.row] firstObject];
}

- (UIViewController *)viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.items[indexPath.row] lastObject] new];
}

@end
