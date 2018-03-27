//
//  DMPageContainController.m
//  头部滑动栏
//
//  Created by 李达志 on 2018/2/11.
//  Copyright © 2018年 LDZ. All rights reserved.
//

#import "DMPageContainController.h"
#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width   // 屏幕宽
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height  // 屏幕高
@interface DMPageContainController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *titleItemss;
@property (nonatomic, assign) CGSize size;
@property (nonatomic,assign) DMPageControlViewStyle style;
@end

@implementation DMPageContainController
+ (instancetype)dmPageContainControllerWithFrame:(CGRect)frame dmPageControlViewHeight:(CGFloat)dmPageControlViewHeight dmTopSpace:(CGFloat)dmTopSpace titles:(NSArray*)titles dmPageControlViewStyle:(DMPageControlViewStyle)style{
    
   return  [[self alloc]initWithFrame:frame dmPageControlViewHeight:dmPageControlViewHeight dmTopSpace:dmTopSpace titles:titles dmPageControlViewStyle:style];
}

- (instancetype)initWithFrame:(CGRect)frame dmPageControlViewHeight:(CGFloat)dmPageControlViewHeight dmTopSpace:(CGFloat)dmTopSpace titles:(NSArray *)titles dmPageControlViewStyle:(DMPageControlViewStyle)style{
    self = [super init];
    if (!self || titles.count == 0) {
        return nil;
    }
    self.dmPageControlViewHeight=dmPageControlViewHeight?:40.0;
    self.dmTopSpace=dmTopSpace?:0.0;
    self.style=style;
    self.titleItemss = titles;
    self.size = frame.size;
    self.view.frame = frame;
    [self initUi];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)initUi{
    [self.view addSubview:self.dmPageControlView];
    [self.view addSubview:self.containerView];
}
- (void)setSelectedAtIndex:(NSUInteger)index{
    [self.dmPageControlView setSelectedAtIndex:index];
}
- (NSUInteger)index {
    return self.dmPageControlView.index;
}

- (UIViewController *)currentViewController {
    return self.viewControllers[self.index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (scrollView == _containerView) {
//        round：如果参数是小数，则求本身的四舍五入。
//        ceil：如果参数是小数，则求最大的整数但不大于本身.
//        floor：如果参数是小数，则求最小的整数但不小于本身.
        NSInteger index = round(scrollView.contentOffset.x / _size.width);
        // 移除不足一页的操作
        if (index != self.index) {
            [self setSelectedAtIndex:index];
        }
    }
}
//滑动过程中调整dmPageControlView进度条的位置位置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x<=0) {
        return;
    }
    if (scrollView == _containerView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        [self.dmPageControlView adjustOffsetXToFixIndicatePosition:offsetX];
    }
}
- (void)moveToViewControllerAtIndex:(NSUInteger)index {
    [self scrollContainerViewToIndex:index];

    UIViewController *targetViewController = self.viewControllers[index];
    if ([self.childViewControllers containsObject:targetViewController] || !targetViewController) {
        return;
    }

    [self updateFrameChildViewController:targetViewController atIndex:index];
}
- (void)updateFrameChildViewController:(UIViewController *)childViewController atIndex:(NSUInteger)index {
    childViewController.view.frame = CGRectOffset(CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height), index * _size.width, 0);

    [_containerView addSubview:childViewController.view];
    [self addChildViewController:childViewController];
}

#pragma mark ---- scroll

- (void)scrollContainerViewToIndex:(NSUInteger)index {
    [UIView animateWithDuration:self.dmPageControlView.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_containerView setContentOffset:CGPointMake(index * _size.width, 0)];
    } completion:^(BOOL finished) {

    }];
}
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    _containerView.contentSize = CGSizeMake(viewControllers.count * self.size.width, self.size.height - 60);
}
#pragma 懒加载
-(UIScrollView *)containerView{
    if (!_containerView) {
        _containerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.dmPageControlViewHeight, kScreenWidth, self.size.height-self.dmPageControlViewHeight)];
        _containerView.delegate=self;
        _containerView.pagingEnabled=YES;
        _containerView.showsHorizontalScrollIndicator=NO;
        _containerView.bounces=NO;
        _containerView.backgroundColor=[UIColor whiteColor];
    }
    return _containerView;
}
-(DMPageControlView *)dmPageControlView{
    if (!_dmPageControlView) {
        _dmPageControlView=[DMPageControlView dmPageControlViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.dmPageControlViewHeight) dmTopSpace:self.dmTopSpace titles:self.titleItemss  dMPageControlViewStyle:self.style];
        _dmPageControlView.indicateViewFiexdWidth=self.indicateViewFiexdWidth?:20.0;
        _dmPageControlView.dmTopSpace=self.dmTopSpace;
        _dmPageControlView.backgroundColor=[UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _dmPageControlView.selectIndexBlock = ^(NSUInteger index, UIButton *button) {
            [weakSelf moveToViewControllerAtIndex:index];
        };
    }
    return _dmPageControlView;
}
@end
#import <objc/runtime.h>

@implementation UIViewController(DMPage)
@dynamic dmPageContainController;
-(DMPageContainController *)dmPageContainController{
    if ([self.parentViewController isKindOfClass:[DMPageContainController class]] && self.parentViewController) {
        return (DMPageContainController *)self.parentViewController;
    }
    return nil;
}


- (void)addSegmentController:(DMPageContainController *)segment {
    if (self == segment) {
        return;
    }

    [self.view addSubview:segment.view];
    [self addChildViewController:segment];

        // 默认加入第一个控制器
    UIViewController *firstViewController = segment.viewControllers.firstObject;
    [segment performSelector:@selector(updateFrameChildViewController:atIndex:) withObject:firstViewController withObject:0];
}
@end
