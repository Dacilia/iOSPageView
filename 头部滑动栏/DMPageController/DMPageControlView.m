    //
    //  DMPageControlView.m
    //  头部滑动栏
    //
    //  Created by 李达志 on 2018/2/11.
    //  Copyright © 2018年 LDZ. All rights reserved.
    //

#import "DMPageControlView.h"
#import "UIView+DMExtesion.h"

@interface DMPageControlView ()
/** 按照文字个数来确定按钮个数 */
@property (nonatomic, strong) NSMutableArray *buttonsItems;
/** 放置button的ScrollView */
@property (nonatomic, strong) UIScrollView *contentView;

/** 顶部的button的文字 */
@property (nonatomic, strong) NSArray *titlesItems;
/** 选中的button */
@property (nonatomic, strong) UIButton *selectedButton;

/** 指示view */
@property (nonatomic, strong) UIView *indicateView;
/** 指示杆高度*/
@property (nonatomic, assign) CGFloat indicateHeight;

@property (nonatomic, assign) CGSize size;
/**< 按钮title到边的间距*/
@property (nonatomic, assign) CGFloat buttonSpace;
/**< 最小Item之间的间距*/
@property (nonatomic, assign) CGFloat minItemSpace;
/** 字体大小 */
@property (nonatomic, strong) UIFont *font;
/* 默认的指示条宽度 */
@property (nonatomic, assign) CGFloat defaultIndicateViewFiexdWidth;

@end
@implementation DMPageControlView
+ (instancetype)dmPageControlViewWithFrame:(CGRect)frame dmTopSpace:(CGFloat)dmTopSpace titles:(NSArray*)titles dMPageControlViewStyle:(DMPageControlViewStyle)style{
  return   [[self alloc]initWithFrame:frame dmTopSpace:dmTopSpace titles:titles dMPageControlViewStyle:style];
}

- (instancetype)initWithFrame:(CGRect)frame dmTopSpace:(CGFloat)dmTopSpace titles:(NSArray *)titles dMPageControlViewStyle:(DMPageControlViewStyle)style{
    self = [super initWithFrame:frame];
    if (!titles.count || !self) {
        return nil;
    }

    self.titlesItems = titles;
    self.size = frame.size;
    self.style=style;
    self.dmTopSpace=dmTopSpace?:0.0;
    
    self.dmPageControlViewHeight=self.size.height-self.dmTopSpace;
    [self pageViewBasicSetting];
    [self  contentViewBasciSetting];
    return self;
}
/** 初始化某些参数 */
-(void)pageViewBasicSetting{
    _selectTitleColor=KSelectTitleColor;
    _normalTitleColor=KNormalTitleColor;
    _indicateViewColor=KIndicateViewColor;
    _minItemSpace=40.0;
    _font=[UIFont systemFontOfSize:16];
    //默认高度和父view一致

    _indicateHeight=2.0;
    _duration=0.25;

    _defaultIndicateViewFiexdWidth=20.0;
    _buttonSpace=[self calculateSpace];
}
- (CGFloat)calculateSpace {
    CGFloat space = 0;
    CGFloat totalWidth = 0;

    for (NSString *title in self.titlesItems) {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : self.font}];
        totalWidth += titleSize.width;
    }

    space = (_size.width - totalWidth) / self.titlesItems.count / 2;
    if (space > _minItemSpace / 2) {
        return space;
    } else {
        return _minItemSpace / 2;
    }
}
/** 初始装载view */
-(void)contentViewBasciSetting{
    CGFloat item_x = 0;
    for (int i = 0; i < self.titlesItems.count; i++) {
        NSString *title = self.titlesItems[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.font}];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(item_x, 0, self.buttonSpace * 2 + titleSize.width, self.dmPageControlViewHeight);
        [button setTag:i];
        [button.titleLabel setFont:_font];
        button.backgroundColor=[UIColor clearColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectTitleColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];


        [self.buttonsItems addObject:button];
        item_x += _buttonSpace * 2 + titleSize.width;

        if (i == 0) {
            button.selected = YES;
            self.selectedButton = button;
            //indicateView的frame
            CGRect rect;
            switch (self.style) {
                case DMPageControlViewStyle_Default:{
                    rect=CGRectMake(0, self.dmPageControlViewHeight - self.indicateHeight, titleSize.width+50+50, self.indicateHeight);
                }

                    break;
                case DMPageControlViewStyle_TitleWidth:{
                    rect=CGRectMake(_buttonSpace, self.dmPageControlViewHeight - self.indicateHeight, titleSize.width, self.indicateHeight);
                }

                    break;
                case DMPageControlViewStyle_FixedWidth:{
                    rect=CGRectMake(button.ng_centerX-self.defaultIndicateViewFiexdWidth/2, self.dmPageControlViewHeight - self.indicateHeight-self.dmTopSpace, self.defaultIndicateViewFiexdWidth, 50);
                }

                    break;
                case DMPageControlViewStyle_TitleBox:{
                    rect=CGRectMake(_buttonSpace, 0, titleSize.width, 40);
                }

                    break;
                default:
                    break;
            }
            // 添加指示杆
            self.indicateView.frame = rect;
            [self.contentView addSubview:self.indicateView];
        }
        [self.contentView addSubview:button];
    }
    self.contentView.contentSize = CGSizeMake(item_x, self.dmPageControlViewHeight);
    [self addSubview:self.contentView];
    
}
#pragma mark - 按钮点击
- (void)didClickButton:(UIButton *)button {

    if (button != self.selectedButton) {
        button.selected = YES;
        self.selectedButton.selected = NO;
        self.selectedButton = button;
        self.index=button.tag;
        [self scrollIndicateView];
        [self autoContentViewCenter];

    }

    !self.selectIndexBlock?:self.selectIndexBlock(button.tag,button);
}
/**
 根据选中的按钮滑动指示杆
 */
- (void)scrollIndicateView {
    CGSize titleSize = [_selectedButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _font}];
    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         switch (self.style) {
                             case DMPageControlViewStyle_Default:{
                                 self.indicateView.frame = CGRectMake(CGRectGetMinX(self.selectedButton.frame), CGRectGetMinY(self.indicateView.frame), [self buttonWidthAtIndex:self.index], self.indicateHeight);

                             }
                                 break;
                             case DMPageControlViewStyle_TitleWidth:{
                                 self.indicateView.frame = CGRectMake(CGRectGetMinX(self.selectedButton.frame) + _buttonSpace, CGRectGetMinY(self.indicateView.frame), titleSize.width, self.indicateHeight);
                             }

                                 break;
                             case DMPageControlViewStyle_FixedWidth:{
                                self.indicateView.frame=CGRectMake(_selectedButton.ng_centerX-self.defaultIndicateViewFiexdWidth/2, CGRectGetMinY(self.indicateView.frame), self.defaultIndicateViewFiexdWidth, self.indicateHeight);
                             }

                                 break;
                             case DMPageControlViewStyle_TitleBox:
                             {

                             self.indicateView.frame = CGRectMake(CGRectGetMinX(self.selectedButton.frame) + _buttonSpace, 0, titleSize.width, 50);
                             }

                                 break;
                             default:
                                 break;
                         }
                     }       completion:nil];
}

/**
 contenView居中
 */
- (void)autoContentViewCenter {
    CGFloat selectedWidth = self.selectedButton.frame.size.width;
    CGFloat offsetX = (self.size.width - selectedWidth) / 2;

    if (self.selectedButton.frame.origin.x <= self.size.width / 2) {//_contentView的左边到了最左
        [self.contentView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (CGRectGetMaxX(self.selectedButton.frame) >= (self.contentView.contentSize.width - self.size.width / 2)) {//_contentView的右边到了最左
        [self.contentView setContentOffset:CGPointMake(self.contentView.contentSize.width - self.size.width, 0) animated:YES];
    } else {
        [self.contentView setContentOffset:CGPointMake(CGRectGetMinX(self.selectedButton.frame) - offsetX, 0) animated:YES];
    }
}

/**
 指示条更随ScrollView的滑动而滑动

 @param offsetX scollview的contenoffsetx
 */
- (void)adjustOffsetXToFixIndicatePosition:(CGFloat)offsetX {
    BOOL isright;
    NSInteger currentIndex = [self index];//当前选中的button
                                          //    offsetX是父scorller的当前滚动到的位置
                                          // 当当前的偏移量大于被选中index的偏移量的时候，就是在右侧
    CGFloat offset; // 在同一侧的偏移量
    NSInteger buttonIndex = currentIndex;
    if (offsetX >= [self index] * self.size.width) {//向右侧移动
        offset = offsetX - [self index] * self.size.width;
        buttonIndex += 1;
        isright=YES;
    } else {//向左侧移动
        offset = [self index] * self.size.width - offsetX;
        buttonIndex -= 1;
        currentIndex -= 1;
        isright=NO;
    }

    //需要移动的距离
    CGFloat targetMovedWidth = [self buttonWidthAtIndex:currentIndex];

    //原始的位置
    CGFloat originMovedX;
    CGFloat targetButtonWidth;
    CGFloat originButtonWidth;
    // 移动的距离
    CGFloat moved;
    moved = offsetX - [self index] * _size.width;
    switch (self.style) {
        case DMPageControlViewStyle_Default:{
            originMovedX=(CGRectGetMinX(_selectedButton.frame) );
            targetButtonWidth=[self buttonWidthAtIndex:buttonIndex];
            originButtonWidth=[self buttonWidthAtIndex:[self index]];
                self.indicateView.frame = CGRectMake(originMovedX + targetMovedWidth / self.size.width * moved, _indicateView.frame.origin.y,  originButtonWidth + (targetButtonWidth - originButtonWidth) / self.size.width * offset, self.indicateView.frame.size.height);
        }
            break;
        case DMPageControlViewStyle_TitleWidth:{
            originMovedX=(CGRectGetMinX(_selectedButton.frame)+ self.buttonSpace);
            targetButtonWidth=[self buttonWidthAtIndex:buttonIndex] - 2 * self.buttonSpace;
            originButtonWidth=[self buttonWidthAtIndex:[self index]] - 2 * _buttonSpace;

                _indicateView.frame = CGRectMake(originMovedX + targetMovedWidth / _size.width * moved, _indicateView.frame.origin.y,  originButtonWidth + (targetButtonWidth - originButtonWidth) / _size.width * offset, _indicateView.frame.size.height);
        }
            break;
        case DMPageControlViewStyle_FixedWidth:{
            originMovedX=_selectedButton.ng_centerX-self.defaultIndicateViewFiexdWidth/2;

            targetMovedWidth=isright? ([self buttonWidthAtIndex:buttonIndex]+[self buttonWidthAtIndex:currentIndex])/2:([self buttonWidthAtIndex:buttonIndex]+[self buttonWidthAtIndex:currentIndex+1])/2;
             _indicateView.frame = CGRectMake(originMovedX + targetMovedWidth / _size.width * moved, _indicateView.frame.origin.y,  self.defaultIndicateViewFiexdWidth, _indicateView.frame.size.height);

        }
            break;
        case DMPageControlViewStyle_TitleBox:{
            originMovedX=(CGRectGetMinX(_selectedButton.frame)+ self.buttonSpace);
            targetButtonWidth=[self buttonWidthAtIndex:buttonIndex] - 2 * self.buttonSpace;
            originButtonWidth=[self buttonWidthAtIndex:[self index]] - 2 * _buttonSpace;
             _indicateView.frame = CGRectMake(originMovedX + targetMovedWidth / _size.width * moved, 0,  originButtonWidth + (targetButtonWidth - originButtonWidth) / _size.width * offset, _indicateView.frame.size.height);

        }

            break;
        default:
            break;
    }
}
/**
 获取button的宽度

 @param index button的tag
 @return width
 */
- (CGFloat)buttonWidthAtIndex:(NSUInteger)index {
    if (index > self.titlesItems.count - 1) {
        return 0;
    }
    UIButton *button = [self.buttonsItems objectAtIndex:index];
    return CGRectGetWidth(button.frame);
}
- (void)setSelectedAtIndex:(NSUInteger)index {
    
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == index) {
            UIButton *button = (UIButton *)view;
            [self didClickButton:button];
            break;
        }
    }
}

-(NSUInteger)index{
    return self.selectedButton.tag;
}
#pragma 自定义设置
-(void)setIndicateViewFiexdWidth:(CGFloat)indicateViewFiexdWidth{
    _indicateViewFiexdWidth=indicateViewFiexdWidth;
    self.defaultIndicateViewFiexdWidth=indicateViewFiexdWidth;
    UIButton*button=[self.buttonsItems objectAtIndex:0];
    if (self.style==DMPageControlViewStyle_FixedWidth) {
        self.indicateView.frame=CGRectMake(button.ng_centerX-self.defaultIndicateViewFiexdWidth/2, self.dmPageControlViewHeight - self.indicateHeight, self.defaultIndicateViewFiexdWidth, self.indicateHeight);
    }

}

-(void)setNormalTitleColor:(UIColor *)normalTitleColor{
    _normalTitleColor=normalTitleColor;
    for (UIButton*button in self.buttonsItems) {
        [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    }
}
-(void)setSelectTitleColor:(UIColor *)selectTitleColor{
    _selectTitleColor=selectTitleColor;
    for (UIButton*button in self.buttonsItems) {
        [button setTitleColor:selectTitleColor forState:UIControlStateSelected];
    }
}
-(void)setIndicateViewColor:(UIColor *)indicateViewColor{
    _indicateViewColor=indicateViewColor;
    self.indicateView.backgroundColor=indicateViewColor;
}

#pragma mark 懒加载
-(UIView *)indicateView{
    if (!_indicateView) {
        _indicateView=[[UIView alloc]init];
        _indicateView.backgroundColor=self.indicateViewColor;
    }
    return _indicateView;
}
-(UIScrollView *)contentView{
    if (!_contentView) {
        _contentView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.dmTopSpace, self.frame.size.width, self.dmPageControlViewHeight)];

        _contentView.backgroundColor=[UIColor whiteColor];
        _contentView.showsHorizontalScrollIndicator=NO;
        _contentView.scrollEnabled=YES;

    }
    return _contentView;
}
-(NSMutableArray *)buttonsItems{
    if (!_buttonsItems) {
        _buttonsItems=[NSMutableArray array];
    }
    return _buttonsItems;
}
- (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2
{
    CGFloat red1, green1, blue1, alpha1;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    CGFloat red2, green2, blue2, alpha2;
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    CGFloat p1 = percent;
    CGFloat p2 = 1.0 - percent;
    UIColor *mid = [UIColor colorWithRed:red1*p1+red2*p2 green:green1*p1+green2*p2 blue:blue1*p1+blue2*p2 alpha:1.0f];
    return mid;
}

@end
