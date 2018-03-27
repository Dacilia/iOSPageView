//
//  DMPageControlView.h
//  头部滑动栏
//
//  Created by 李达志 on 2018/2/11.
//  Copyright © 2018年 LDZ. All rights reserved.
//  顶部文字滑动view

#import <UIKit/UIKit.h>
#define RGBAColor(r,g,b,a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a])
/** 默认选中字体颜色 */
#define KSelectTitleColor RGBAColor(80, 80, 80, 1)
/** 默认非选中字体颜色 */
#define KNormalTitleColor RGBAColor(150, 150, 150, 1)
/** 进度条默认颜色 */
#define KIndicateViewColor RGBAColor(80, 80, 80, 1)
typedef NS_ENUM(NSInteger,DMPageControlViewStyle) {
    DMPageControlViewStyle_Default,//默认样式指示条宽度和button宽度一致
    DMPageControlViewStyle_FixedWidth,//固定的指示条宽度
    DMPageControlViewStyle_TitleWidth,//指示条宽度和文字宽度一致
    DMPageControlViewStyle_TitleBox//盒子样式盒子宽度和文字宽度一样

};

@interface DMPageControlView : UIView

@property (nonatomic,assign) DMPageControlViewStyle style;
/** 滑动时间 默认0.5s*/
@property (nonatomic, assign, readwrite) NSTimeInterval duration;
/** 当前的选中位置 */
@property (nonatomic, assign) NSUInteger index;
/** 选中字体颜色 */
@property (nonatomic,strong) UIColor *   selectTitleColor;
/** 非选中字体颜色 */
@property (nonatomic,strong) UIColor *  normalTitleColor;
/** 指示条颜色 */
@property (nonatomic,strong) UIColor *  indicateViewColor;
/** 固定的指示条宽度 默认为20 */
@property (nonatomic,assign) CGFloat    indicateViewFiexdWidth;
/** DMPageControlView 的高度 通过初始化方法设置 默认放置button的ScrollView
 的高度和DMPageControlView的高度一致 dmPageControlViewHeight=self.size.height-self.dmTopSpace*/
@property (nonatomic,assign)  CGFloat dmPageControlViewHeight;
/** button顶部与DMPageControlView顶部的距离默认为0
 button的高度默认和dmPageControlViewHeight一样
 通过设置该属性可以设置放置button的ScrollView
 的高度*/
@property (nonatomic,assign)  CGFloat dmTopSpace;

@property (nonatomic,copy)  void (^selectIndexBlock)(NSUInteger index,UIButton*button);

/**
 类方法初始化

 @param frame DMPageControlView的frame
 @param dmTopSpace contentView距离顶部的距离
 @param titles 文字数组
 @param style 风格样式
 @return self
 */
+ ( instancetype)dmPageControlViewWithFrame:(CGRect)frame dmTopSpace:(CGFloat)dmTopSpace titles:(NSArray *)titles dMPageControlViewStyle:(DMPageControlViewStyle)style;
- ( instancetype)initWithFrame:(CGRect)frame dmTopSpace:(CGFloat)dmTopSpace titles:(NSArray *)titles dMPageControlViewStyle:(DMPageControlViewStyle)style;
/**
 设置选中的button

 @param index button标记
 */
- (void)setSelectedAtIndex:(NSUInteger)index;

/**
 调整indicateView的位置

 @param offsetX 容器ScollerView的contentoffset
 */
- (void)adjustOffsetXToFixIndicatePosition:(CGFloat)offsetX;
@end
