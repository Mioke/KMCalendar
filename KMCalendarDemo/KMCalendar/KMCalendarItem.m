//
//  KMCalendarItem.m
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import "KMCalendarItem.h"

@implementation KMCalendarItem
{
    UIImageView *_dot;
    UIView *_selectedView;
    
    void (^_clickBlock)(KMCalendarItem *item);
}

- (id)initWithOrigin:(CGPoint)origin
           withTitle:(NSString *)title
              record:(BOOL)yesOrNo
          isSelected:(BOOL)isSelected
          outOfMonth:(BOOL)outOfMonth
             isToday:(BOOL)isToday
        onClickBlock:(void (^)(KMCalendarItem *item))block
{
    self = [self initWithOrigin:origin withTitle:title record:yesOrNo isSelected:isSelected outOfMonth:outOfMonth isToday:isToday];
    _clickBlock = block;
    return self;
}

- (id)initWithOrigin:(CGPoint)origin
           withTitle:(NSString *)title
              record:(BOOL)yesOrNo
          isSelected:(BOOL)isSelected
          outOfMonth:(BOOL)outOfMonth
             isToday:(BOOL)isToday
{
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, ITEM_WIDTH, ITEM_HEIGHT)]) {
        self.outOfMonth = outOfMonth;
        _dot = [[UIImageView alloc] initWithFrame:CGRectMake((ITEM_WIDTH - 4.f) / 2, 24.5f, 4.f, 4.f)];
        [_dot setImage:[UIImage imageNamed:@"dotGreen"]];
        _dot.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake((ITEM_WIDTH - 18.f) / 2, 6.f, 18.f, 18.)];
        _selectedView.backgroundColor = DEFAULT_TINT_COLOR;
        _selectedView.layer.cornerRadius = _selectedView.frame.size.height / 2;
        _selectedView.layer.masksToBounds = YES;
//        [_selectedView setImage:[UIImage imageNamed:@"circleGreen"]];
        
        [self setDay:title outOfMonth:yesOrNo isToday:isToday isRecord:yesOrNo];
        [self.titleLabel setFont:DEFAULT_FONT];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (isSelected) {
            [self setSelected:isSelected];
        }
    }
    return self;
}

- (void)setDay:(NSString *)day outOfMonth:(BOOL)yesOrNO isToday:(BOOL)isToday isRecord:(BOOL)isRecord
{
    [self setTitle:day forState:UIControlStateNormal];
    self.outOfMonth = yesOrNO;
    self.isRecord = isRecord;
    
    if (isRecord) {
        [self addSubview:_dot];
    } else {
        [_dot removeFromSuperview];
    }
    if (isToday) {
        [self setTitleColor:DEFAULT_TINT_COLOR forState:UIControlStateNormal];
        return;
    }
    if (yesOrNO) {
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)yesOrNo
{
    if (yesOrNo) {
        if (hidden) {
            [UIView animateWithDuration:0.25f animations:^{
                self.alpha = 0.f;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        } else {
            [UIView animateWithDuration:0.25f animations:^{
                self.alpha = 1.f;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        }
    } else {
        if (hidden) {
            self.alpha = 0.f;
        } else {
            self.alpha = 1.f;
        }
        [super setHidden:hidden];
    }
}

#pragma mark - other functions

- (void)pressButton:(UIButton *)button
{
    _clickBlock(self);
    if (!self.isSelected) {
        [self setSelected:!self.isSelected];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self insertSubview:_selectedView belowSubview:self.titleLabel];
    } else {
        [_selectedView removeFromSuperview];
    }
}

@end
