//
//  ViewController.m
//  UIPageViewControllerBug
//
//  Created by ApesTalk on 2019/2/17.
//  Copyright © 2019年 ApesTalk. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController.h"

static NSString *cellIdentifier = @"cell";
@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIPageViewController *pageVc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.view addSubview:self.table];
    
    //1.这种方式：页面展示后往右拖第一个页面的scollview，是pageviewcontroller的scrollview响应了，不正常！
    UIScrollView *s = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    s.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2);
    [self.view addSubview:s];
    [s addSubview:self.contentView];
    
    //如果是UIScrollView，通过以下方式处理可以。如果是UITableView，通过以下方式处理不行。
//    UIGestureRecognizer *pan;
//    for(UIGestureRecognizer *ges in s.gestureRecognizers){
//        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]){
//            pan = (UIPanGestureRecognizer *)ges;
//        }
//    }
//
//    UIGestureRecognizer *otherPan;
//    for(UIGestureRecognizer *ges in self.pageVc.view.subviews[0].gestureRecognizers){
//        if([ges isKindOfClass:[UIPanGestureRecognizer class]]){
//            otherPan = (UIPanGestureRecognizer *)ges;
//        }
//    }
//
//    [pan requireGestureRecognizerToFail:otherPan];
    
    //2.这种方式：第一次拖动，响应的是scrollview，正常！
//    [self.view addSubview:self.contentView];
}

- (UITableView *)table{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

- (UIPageViewController *)pageVc{
    if(!_pageVc){
        _pageVc.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 500);
        _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        SubViewController *vc = [SubViewController new];
        vc.index = 0;
        [_pageVc setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        _pageVc.dataSource = self;
        _pageVc.delegate = self;
    }
    return _pageVc;
}

- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 500)];
        [self addChildViewController:self.pageVc];
        [_contentView addSubview:self.pageVc.view];
        [self.pageVc didMoveToParentViewController:self];
    }
    return _contentView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.contentView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 500;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    SubViewController *vc = (SubViewController *)viewController;
    if(vc.index <= 0){
        return nil;
    }
    
    SubViewController *preVc = [SubViewController new];
    preVc.index = vc.index-1;
    return preVc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    SubViewController *vc = (SubViewController *)viewController;
    if(vc.index >= 5){
        return nil;
    }
    
    SubViewController *nextVc = [SubViewController new];
    nextVc.index = vc.index+1;
    return nextVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
