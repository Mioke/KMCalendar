//
//  KMCalendarItem.h
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMCalendarHelper.h"

#define ITEM_HEIGHT 30.f
#define ITEM_WIDTH ([UIScreen mainScreen].bounds.size.width - 30.f) / 7.f

@interface KMCalendarItem : UIButton

@property BOOL outOfMonth;
@property BOOL isRecord;

- (id)initWithOrigin:(CGPoint)origin
           withTitle:(NSString *)title
              record:(BOOL)yesOrNo
          isSelected:(BOOL)isSelected
          outOfMonth:(BOOL)outOfMonth
             isToday:(BOOL)isToday
        onClickBlock:(void (^)(KMCalendarItem *item))block;

- (id)initWithOrigin:(CGPoint)origin
           withTitle:(NSString *)title
              record:(BOOL)yesOrNo
          isSelected:(BOOL)isSelected
          outOfMonth:(BOOL)outOfMonth
             isToday:(BOOL)isToday;

- (void)setDay:(NSString *)day outOfMonth:(BOOL)yesOrNO isToday:(BOOL)isToday isRecord:(BOOL)isRecord;
- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)yesOrNo;

@end
