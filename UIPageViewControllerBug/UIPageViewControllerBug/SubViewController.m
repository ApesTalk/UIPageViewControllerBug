//
//  SubViewController.m
//  UIPageViewControllerBug
//
//  Created by ApesTalk on 2019/2/17.
//  Copyright © 2019年 ApesTalk. All rights reserved.
//

#import "SubViewController.h"

@interface SubViewController ()

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scoll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200)];
    scoll.contentSize = CGSizeMake(1000, 200);
    scoll.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scoll];
    for(NSInteger i=0;i<10;i++){
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(100*i, 0, 90, 200)];
        v.backgroundColor = [UIColor redColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 200)];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.text = [NSString stringWithFormat:@"%ld", i];
        [v addSubview:label];
        [scoll addSubview:v];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 350, self.view.bounds.size.width, 20)];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%ld", _index];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
