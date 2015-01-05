//
//  NSDate+SRGFekable.m
//  NSDate+SRGFekable
//
//  Created by nori0620 on 2015/01/01.
//  Copyright (c) 2015年 soragoto. All rights reserved.
//

#import "NSDate+SRGFekable.h"
#import <objc/runtime.h>

@interface NSDate (SRGFakable_Private)
+ (instancetype) p_swizzledDate ;
+(void) p_swizzleMethods ;
+(NSDate *) p_dateFromString:(NSString *)dateString
                    timeZone:(NSTimeZone *)timeZone;
@end

#pragma mark - Public methods

@implementation NSDate (SRGFakable)

static NSDate *fakedNow = nil;
static NSTimeInterval fakeDiff = 0;
static BOOL isSwizzledDateMehtods = NO;
static BOOL doFreeze = NO;

+ (instancetype)now {
    return [[self class] date];
}

+ (BOOL)doFaking{
    return  !!fakedNow;
}

+ (void)stopFaking {
    fakedNow = nil;
}


+ (void)fakeWithDate:(NSDate *)date {
    return[self fakeWithDate:date freeze:YES];
}

+ (void)fakeWithDate:(NSDate *)date
                  freeze:(BOOL)freeze
{
    fakedNow  = date;
    doFreeze  = freeze;
    [self p_swizzleMethods];
    fakeDiff  = [[[self class] p_swizzledDate] timeIntervalSinceDate:fakedNow];
}

+ (void)fakeWithString:(NSString *)dateString
                  timeZone:(NSTimeZone *)timeZone
                  freeze:(BOOL)freeze
{
    NSDate *date = [[self class] p_dateFromString:dateString
                                     timeZone:timeZone ];
    [self fakeWithDate:date
                freeze:freeze
     ];
}

+ (void)fakeWithString:(NSString *)dateString
                  freeze:(BOOL)freeze
{
    return [[self class] fakeWithString:dateString
                                   timeZone:[NSTimeZone systemTimeZone]
                                     freeze:freeze];
}

+ (void)fakeWithString:(NSString *)dateString {
    return [self fakeWithString:dateString freeze:YES];
}


+ (void)fakeWithDelta:(NSTimeInterval)delta {
    return [self fakeWithDelta:delta freeze:YES];
}

+ (void)fakeWithDelta:(NSTimeInterval)delta
               freeze:(BOOL)freeze {
    [self fakeWithDate:[[NSDate date] dateByAddingTimeInterval:delta]
                freeze:freeze];
}

@end


#pragma mark - Private methods

@implementation NSDate (SRGFakable_Private)

+ (NSDate *) p_reloadFakedNow {
    if( !fakedNow ){ return nil; }
    if( doFreeze ){ return fakedNow; }
   
    NSTimeInterval latestDiff = [[NSDate p_swizzledDate] timeIntervalSinceDate:fakedNow];
    return [fakedNow dateByAddingTimeInterval: latestDiff - fakeDiff ];
}

#pragma mark Swizzing Targets

+ (instancetype) p_swizzledDate {
    NSDate *faked = [[self class] p_reloadFakedNow];
    if( faked ){ return  faked; }
    return [self p_swizzledDate];
}

+ (instancetype) p_swizzledDateWithTimeIntervalSinceNow:(NSTimeInterval)secs{
    NSDate *faked = [[self class] p_reloadFakedNow];
    if( faked ){
        return [NSDate dateWithTimeInterval:secs sinceDate:faked];
    }
    return [self p_swizzledDateWithTimeIntervalSinceNow:secs];
}

- (NSTimeInterval) p_swizzledTimeIntervalSinceNow {
    NSDate *faked = [[self class] p_reloadFakedNow];
    if( faked ){
        return [ self timeIntervalSinceDate:faked];
    }
    return [self p_swizzledTimeIntervalSinceNow];
}

#pragma mark Execute Swizzing

+ (void)p_swizzleMethods {
    if( isSwizzledDateMehtods  ){ return; }
    
    /* sizzle class methods */ {
        [self p_swizzleClassMethodWithOriginal:@selector(date)
                                           new:@selector(p_swizzledDate)
        ];
        [self p_swizzleClassMethodWithOriginal:@selector(dateWithTimeIntervalSinceNow:)
                                           new:@selector(p_swizzledDateWithTimeIntervalSinceNow:)
        ];
    }
    
    /* sizzle instance methods */ {
        [self p_swizzleInstanceMethodWithOriginal:@selector(timeIntervalSinceNow)
                                           new:@selector(p_swizzledTimeIntervalSinceNow)
        ];
    }
    
    
    isSwizzledDateMehtods = YES;
}

+(void) p_swizzleClassMethodWithOriginal:(SEL)original
                                new:(SEL)new
{
    Method originalMethod = class_getClassMethod([self class], original);
    Method newMethod = class_getClassMethod([self class], new);
    method_exchangeImplementations(originalMethod, newMethod);
}

+(void) p_swizzleInstanceMethodWithOriginal:(SEL)original
                                new:(SEL)new
{
    return [self p_swizzleInstanceMethodWithOriginal:original
                                                 new:new
                                       originalClass:[self class] ];
}

+(void) p_swizzleInstanceMethodWithOriginal:(SEL)original
                                new:(SEL)new
                      originalClass:(Class)originalClass
{
    Method originalMethod = class_getInstanceMethod(originalClass, original);
    Method newMethod = class_getInstanceMethod([self class], new);
    method_exchangeImplementations(originalMethod, newMethod);
}

#pragma mark Utils

+ (NSDate *) p_dateFromString:(NSString *)dateString
                     timeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [formatter setTimeZone:timeZone];
    return [formatter dateFromString:dateString];
}

@end
