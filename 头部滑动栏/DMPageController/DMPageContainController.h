//
//  DMPageContainController.h
//  头部滑动栏
//
//  Created by 李达志 on 2018/2/11.
//  Copyright © 2018年 LDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMPageControlView.h"

@interface DMPageContainController : UIViewController<UIScrollViewDelegate>
/** 页面数组 */
@property (nonatomic, strong) NSArray *viewControllers;
/** 头部UIScrollView */
@property (nonatomic, strong) DMPageControlView *dmPageControlView;
/** 当前显示的Controller */
@property (nonatomic, strong) UIViewController *currentViewController;
/** 放置字view */
@property (nonatomic, strong) UIScrollView *containerView;
/** 当前页面index */
@property (nonatomic, assign) NSUInteger index;
/** 固定的指示条宽度 默认为20 */
@property (nonatomic,assign) CGFloat    indicateViewFiexdWidth;

/** DMPageControlView 的高度 默认40.0 */
@property (nonatomic,assign)  CGFloat dmPageControlViewHeight;
/** button顶部与DMPageControlView顶部的距离默认为0
 button的宽度默认和dmPageControlViewHeight一样*/
@property (nonatomic,assign)  CGFloat dmTopSpace;


/**
 类方法初始化

 @param frame dmPageContainController的frame
 @param titles 顶部文字按钮
 @param style DMPageControlView的style风格
 @return self
 */
+ ( instancetype)dmPageContainControllerWithFrame:(CGRect)frame dmPageControlViewHeight:(CGFloat)dmPageControlViewHeight dmTopSpace:(CGFloat)dmTopSpace titles:(NSArray *)titles dmPageControlViewStyle:(DMPageControlViewStyle)style;
/**
 实例方法初始化

 @param frame dmPageContainController的frame
 @param titles 顶部文字按钮
 @param style DMPageControlView的style风格
 @return self
 */
- ( instancetype)initWithFrame:(CGRect)frame dmPageControlViewHeight:(CGFloat)dmPageControlViewHeight dmTopSpace:(CGFloat)dmTopSpace titles:(NSArray *)titles dmPageControlViewStyle:(DMPageControlViewStyle)style;
- (void)setSelectedAtIndex:(NSUInteger)index;
@end

@interface UIViewController (DMPage)
@property (nonatomic, strong, readonly) DMPageContainController *dmPageContainController;
- (void)addSegmentController:(DMPageContainController *)segment;
@end
