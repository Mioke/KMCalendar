//
//  NSDate+KMCalendar.h
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KMCalendar)

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;

- (NSDate *)km_offsetMonth:(NSInteger)offset;
- (NSDate *)km_offsetWeekOfYear:(NSInteger)offset;
- (NSDate *)km_offsetDay:(NSInteger)offset;

- (int)km_returnWeekday;
- (int)km_weekOfMonth;

- (NSString *)km_formatInKMCalendar;

- (NSInteger)km_numberOfDaysInMonth;
- (NSInteger)km_firstWeekDayInMonth;

- (BOOL)km_isMonthEqualToDate:(NSDate *)date;
- (BOOL)km_isDayEqualToDate:(NSDate *)date;
- (BOOL)km_isWeekEqualToDate:(NSDate *)date;

- (NSDate *)km_firstDayInMonth;
- (NSDate *)km_lastDayInMonth;

- (NSTimeInterval)km_originTimeOfADay;

@end
