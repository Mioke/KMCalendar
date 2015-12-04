//
//  KMCalendarHelper.m
//  KMCalendarDemo
//
//  Created by Klein Mioke on 15/12/4.
//  Copyright © 2015年 KleinMioke. All rights reserved.
//

#import "KMCalendarHelper.h"

@implementation KMCalendarHelper

+ (NSDate *)getPreviousMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    [components setDay:1];
    [components setHour:12];
    [components setMonth:components.month - 1];
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *)getNextMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    [components setDay:1];
    [components setHour:12];
    [components setMonth:components.month + 1];
    
    return [calendar dateFromComponents:components];
}

+ (BOOL)checkSameDay:(NSDate *)date1 another:(NSDate *)date2
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-DD";
    NSString *string1 = [formatter stringFromDate:date1];
    NSString *string2 = [formatter stringFromDate:date2];
    
    return [string1 isEqualToString:string2];
}

@end
