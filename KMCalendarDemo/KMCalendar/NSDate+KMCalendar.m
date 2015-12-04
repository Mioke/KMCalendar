//
//  NSDate+KMCalendar.m
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import "NSDate+KMCalendar.h"

@implementation NSDate (KMCalendar)

@dynamic year, day, month;

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:self];
    return comps.year;
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:self];
    return comps.day;
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:self];
    return comps.month;
}

- (int)km_returnWeekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return (int)[calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self];
}

- (int)km_weekOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekOfMonth fromDate:self];
    return (int32_t)comps.weekOfMonth;
}

- (NSDate *)km_offsetMonth:(NSInteger)offset
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:offset];
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)km_offsetWeekOfYear:(NSInteger)offset
{
    if (offset == 0) {
        return self;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setWeekOfYear:offset];
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)km_offsetDay:(NSInteger)offset
{
    if (offset == 0) {
        return self;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:offset];
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}

- (NSString *)km_formatInKMCalendar
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY年MM月";
    return [formatter stringFromDate:self];
}

- (NSInteger)km_numberOfDaysInMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

- (NSInteger)km_firstWeekDayInMonth
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                           fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    
    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:newDate];
}

- (BOOL)km_isMonthEqualToDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
    if (selfComps.year == dateComps.year && selfComps.month == dateComps.month) {
        return YES;
    }
    return NO;
}

- (BOOL)km_isDayEqualToDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                         fromDate:self];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                         fromDate:date];
    if (selfComps.year == dateComps.year && selfComps.month == dateComps.month && selfComps.day == dateComps.day) {
        return YES;
    }
    return NO;
}

- (BOOL)km_isWeekEqualToDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComps = [cal components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear
                                         fromDate:self];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear
                                         fromDate:date];
    if (selfComps.weekOfYear == dateComps.weekOfYear && dateComps.yearForWeekOfYear == selfComps.yearForWeekOfYear) {
        return YES;
    }
    return NO;
}

- (NSDate *)km_firstDayInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                          fromDate:self];
    [comps setHour:12];
    [comps setDay:1];
    
    return [calendar dateFromComponents:comps];
}

- (NSDate *)km_lastDayInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                          fromDate:self];
    [comps setHour:12];
    [comps setDay:[self km_numberOfDaysInMonth]];
    
    return [calendar dateFromComponents:comps];
}

- (NSTimeInterval)km_originTimeOfADay {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    return [[calendar dateFromComponents:comps] timeIntervalSince1970];
}


@end
