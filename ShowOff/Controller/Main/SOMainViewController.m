//
//  SOMainViewController.m
//  ShowOff
//
//  Created by Itay Dressler on 5/5/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOMainViewController.h"
#import "SOMainTableViewCell.h"
#import "SOCollectionLayoutViewController.h"
#import "SOSlidingMenuCollectionViewController.h"
#import "SOImageAnimationViewController.h"

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
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self.items[indexPath.row] firstObject]];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:self.items[indexPath.row][1]
                             range:NSMakeRange(1, 1)];
    
    cell.textLabel.attributedText = attributedString;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class vcClass               = [self.items[indexPath.row] lastObject];
    NSString *segueIdentifier   = NSStringFromClass(vcClass);
    [self performSegueWithIdentifier:segueIdentifier
                              sender:nil];
}

#pragma mark Private 

- (void)setupTableView {
    self.items = @[@[@"Collection Layout",[UIColor flatPinkColor] ,[SOCollectionLayoutViewController class]],
                   @[@"Sliding Menu", [UIColor flatSkyBlueColor] ,[SOSlidingMenuCollectionViewController class]],
                   @[@"Image + POP", [UIColor flatYellowColor] ,[SOImageAnimationViewController class]]
                   ];
    [self.tableView registerClass:[SOMainTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight        = 50.f;
}

- (void)configureTitleView
{
    UILabel *headlinelabel      = [UILabel new];
    headlinelabel.font          = [UIFont fontWithName:@"Avenir-Light" size:28];
    headlinelabel.textAlignment = NSTextAlignmentCenter;
    headlinelabel.textColor     = [UIColor lightGrayColor];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor flatYellowColorDark]
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
