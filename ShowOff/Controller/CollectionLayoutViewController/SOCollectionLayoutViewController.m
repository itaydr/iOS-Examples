//
//  SOCollectionLayoutViewController.m
//  ShowOff
//
//  Created by Itay Dressler on 5/5/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOCollectionLayoutViewController.h"

@interface SOCollectionLayoutViewController ()

@end

@implementation SOCollectionLayoutViewController

static NSString * const reuseIdentifier = @"imageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor flatPurpleColorDark] : [UIColor flatOrangeColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
