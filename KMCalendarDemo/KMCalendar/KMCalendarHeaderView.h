//
//  KMCalendarHeaderView.h
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMCalendarHelper.h"

@interface KMCalendarHeaderView : UIView

@property (nonatomic, strong) NSDate                 *date;
@property (nonatomic        ) KMCalendarHeaderType    type;

- (instancetype)initWithType:(KMCalendarHeaderType)type
        onClickPreMonthBlock:(void (^)(void))preMonth
       onClickNextMonthBlock:(void (^)(void))nextMonth
     onClickBackToTodayBlock:(void (^)(void))backToToday;

@end
