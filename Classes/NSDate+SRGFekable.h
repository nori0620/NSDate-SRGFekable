//
//  NSDate+SRGFekable.h
//  NSDate+SRGFekable
//
//  Created by nori0620 on 2015/01/01.
//  Copyright (c) 2015年 soragoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SRGFakable)

+ (BOOL) srg_doFaking;
+ (void) srg_stopFaking;
+ (void) srg_fakeWithDate:(NSDate *)date;
+ (void) srg_fakeWithString:(NSString *)dateString;
+ (void) srg_fakeWithString:(NSString *)dateString
                   timeZone:(NSTimeZone *)timeZone;
;

@end
