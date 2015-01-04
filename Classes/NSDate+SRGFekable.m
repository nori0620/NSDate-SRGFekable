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
+ (NSDate *) p_reloadFakedNow ;
+(void) p_swizzleMethods ;
+(void) p_swizzleClassMethodWithOriginal:(SEL)original
                                     new:(SEL)new;
+(void) p_swizzleInstanceMethodWithOriginal:(SEL)original
                                        new:(SEL)new;
+(NSDate *) p_dateFromString:(NSString *)dateString
                    timeZone:(NSTimeZone *)timeZone;
@end

#pragma mark - Public methods

@implementation NSDate (SRGFakable)

static NSDate *fakedNow = nil;
static NSTimeInterval fakeDiff = 0;
static BOOL isSwizzledDateMehtods = NO;
static BOOL doFreeze = NO;


+ (BOOL)srg_doFaking{
    return  !!fakedNow;
}

+ (void)srg_stopFaking {
    fakedNow = nil;
}

+ (void)srg_fakeWithDate:(NSDate *)date
                  freeze:(BOOL)freeze
{
    fakedNow = date;
    doFreeze  = freeze;
    fakeDiff  = [[NSDate date] timeIntervalSinceDate:fakedNow];
    [self p_swizzleMethods];
}

+ (void)srg_fakeWithString:(NSString *)dateString
                  timeZone:(NSTimeZone *)timeZone
                  freeze:(BOOL)freeze
{
    NSDate *date = [[self class] p_dateFromString:dateString
                                     timeZone:timeZone ];
    [self srg_fakeWithDate:date
                    freeze:freeze
     ];
}

+ (void)srg_fakeWithString:(NSString *)dateString
                  freeze:(BOOL)freeze
{
    return [[self class] srg_fakeWithString:dateString
                                   timeZone:[NSTimeZone systemTimeZone]
                                     freeze:freeze
            ];
}


@end


#pragma mark - Private methods

@implementation NSDate (SRGFakable_Private)

#pragma mark _fakedNew getter/setter

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

+ (id) p_forceRetain:(id)instance {
    SEL selector = NSSelectorFromString(@"retain");
    IMP imp = [instance methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(instance, selector);
    return instance;
}

@end
