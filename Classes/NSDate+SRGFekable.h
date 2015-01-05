//
//  NSDate+SRGFekable.h
//  NSDate+SRGFekable
//
//  Created by nori0620 on 2015/01/01.
//  Copyright (c) 2015年 soragoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SRGFakable)

+ (instancetype) now;
+ (BOOL) doFaking;
+ (void) stopFaking;
+ (void) fakeWithDate:(NSDate *)date;
+ (void) fakeWithDate:(NSDate *)date
                   freeze:(BOOL)freeze
;
+ (void) fakeWithString:(NSString *)dateString
                     freeze:(BOOL)freeze
;
+ (void) fakeWithString:(NSString *)dateString
                   timeZone:(NSTimeZone *)timeZone
                     freeze:(BOOL)freeze
;
+ (void) fakeWithDelta:(NSTimeInterval)delta;
+ (void) fakeWithDelta:(NSTimeInterval)delta
                freeze:(BOOL)freeze
;

@end
