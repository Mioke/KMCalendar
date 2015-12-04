//
//  KMCalendarView.h
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMCalendarItem.h"

@interface KMCalendarView : UIView

@property (nonatomic        ) NSInteger        selectedLine;
@property (nonatomic        ) NSInteger        currentLine;
@property (nonatomic, strong) NSDate           *selectedDay;
@property (nonatomic, strong) NSDate           *date;

@property (nonatomic        ) KMCalendarType    type;
@property (nonatomic, weak  ) NSArray          *recordDateArray;

- (instancetype)initWithDate:(NSDate *)date
             recordDateArray:(NSArray *)dateArray
                returnHeight:(void (^)(CGFloat height))block
              clickDateBlock:(void (^)(NSDate *date, BOOL outOfMonth))block2;

- (void)resetWithDate:(NSDate *)date returnHeight:(void (^)(CGFloat height))block;
- (void)resetWeekStyleWithDate:(NSDate *)date;

- (void)offsetYPoint:(CGFloat)offset;

- (void)setDateSelected:(NSDate *)date;
- (void)resetWeekStyleAsPrimaryView:(NSDate *)date
                          animation:(BOOL)yesOrNo
                       returnHeight:(void (^)(CGFloat height))block;

- (CGFloat)animationEndTopLine;
- (CGFloat)animationEndBottomLine;

- (void)clickDayOutOfMonth:(void (^)(int flag))block;

@end
