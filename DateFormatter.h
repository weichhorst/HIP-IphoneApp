//
//  DateFormatter.h
//  Blongo
//
//  Created by user on 3/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatter : NSObject


+ (id)sharedFormatter;
- (NSString *)getStringFromDate:(NSDate *)date;
- (NSDateFormatter *)myFormatter:(NSString *)format;
- (NSString *)getStringFromDateWithHM:(NSDate *)date;
- (NSString *)getFullStringFromDate:(NSDate *)date;
- (NSString *)getDateStringForSubmit:(NSDate *)date;

- (NSString *)getSyncStringFromDate:(NSDate *)date;

- (NSDate *)getDateFromString:(NSString *)string;

@end
