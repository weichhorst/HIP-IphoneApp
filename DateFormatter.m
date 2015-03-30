//
//  DateFormatter.m
//  Blongo
//
//  Created by user on 3/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

static DateFormatter *dateFormatter = nil;

+ (id)sharedFormatter{
    
    if (!dateFormatter) {
        
        dateFormatter = [[DateFormatter alloc]init];
    }
    
    return dateFormatter;
}


- (NSString *)getStringFromDateWithHM:(NSDate *)date{
    
    return [[self myFormatter:@"dd:MM:yyyy hh:mm"] stringFromDate:date];
}


- (NSString *)getStringFromDate:(NSDate *)date{
    
    return [[self myFormatter:@"MM-dd-yyyy"] stringFromDate:date];
}


- (NSString *)getSyncStringFromDate:(NSDate *)date{
    
    return [[self myFormatter:@"LLL-dd-yyyy HH:mm"] stringFromDate:date];
}


- (NSDateFormatter *)myFormatter:(NSString *)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:format];
    
    return dateFormatter;
}


//2014-02-24 00:39:56.000 to be used for time stamps
- (NSString *)getFullStringFromDate:(NSDate *)date{
    
    return [[self myFormatter:@"yyyy-MM-dd hh:mm:ss.000"] stringFromDate:date];
}


- (NSString *)getDateStringForSubmit:(NSDate *)date{
    
    return [[self myFormatter:@"LLL-dd-yyyy"] stringFromDate:date];
}


- (NSDate *)getDateFromString:(NSString *)string{
    
    return [[self myFormatter:@"LLL-dd-yyyy"] dateFromString:string];
}


@end
