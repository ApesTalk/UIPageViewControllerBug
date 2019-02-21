# UIPageViewControllerBug
A bug description for UIPageViewController when add it on a UIScrollView. Any help would be appreciated. 


# Reproduce step


1.Create a UIPageViewController

```
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

```

2.In the SubViewController's view, add a horizontal UIScrollView

```
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
```


2.Create a full-screen UIScrollView in UIViewController and add UIPageViewController's view on the UIScrollView

```
UIScrollView *s = [[UIScrollView alloc]initWithFrame:self.view.bounds];
s.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2);
[self.view addSubview:s];
[s addSubview:self.contentView];
```

When i first drag the UIScrollView on SubViewController, it does't response, you can find that the UIScrollView on UIViewController responsed my drag action. When i drag it again, it works as expected.

中文解释：
如果横向滚动的UIPageViewController的子视图控制器中包含了一个可以横向滚动的UISCrollView，那么，当我把这个UIPageViewController加到另一个UISCrollView上时，手动横向拖动子视图控制器的UISCrollView时，第一次它没有响应，而是UIPageViewController响应了，第二次拖动的时候又正常了。


