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
+(void) p_swizzleMethods ;
+(void) p_swizzleClassMethodWithOriginal:(SEL)original
                                     new:(SEL)new;
+(void) p_swizzleInstanceMethodWithOriginal:(SEL)original
                                        new:(SEL)new;
+(NSDate *) p_dateFromString:(NSString *)dateString
                    timeZone:(NSTimeZone *)timeZone;
+(id) p_forceRetain:(id)instance ;
@end

#pragma mark - Public methods

@implementation NSDate (SRGFakable)

static NSDate *fakedNow = nil;
static BOOL isSwizzledDateMehtods = NO;


+ (BOOL)srg_doFaking{
    return  !!fakedNow;
}

+ (void)srg_stopFaking {
    fakedNow = nil;
}

+ (void)srg_fakeWithDate:(NSDate *)date {
    fakedNow = date;
    [self p_swizzleMethods];
}

+ (void)srg_fakeWithString:(NSString *)dateString
                  timeZone:(NSTimeZone *)timeZone
{
    fakedNow = [[self class] p_dateFromString:dateString
                                     timeZone:timeZone ];
    [self p_swizzleMethods];
}

+ (void)srg_fakeWithString:(NSString *)dateString{
    return [[self class] srg_fakeWithString:dateString
                                   timeZone:[NSTimeZone systemTimeZone]];
}

@end


#pragma mark - Private methods

@implementation NSDate (SRGFakable_Private)

#pragma mark Swizzing Targets

+ (instancetype) p_swizzledDate {
    if( fakedNow ){ return  fakedNow; }
    return [self p_swizzledDate];
}

+ (instancetype) p_swizzledDateWithTimeIntervalSinceNow:(NSTimeInterval)secs{
    if( fakedNow ){
        return [NSDate dateWithTimeInterval:secs sinceDate:fakedNow];
    }
    return [self p_swizzledDateWithTimeIntervalSinceNow:secs];
}

- (instancetype) p_swizzledInit {
    if( fakedNow ){
        /* In init method, we return onother instance!  So we need to force retain this instance(fakedNow) */
        NSDate *instance = [self initWithTimeInterval:0 sinceDate:fakedNow];
        return [[self class] p_forceRetain:instance];
    }
    return [self p_swizzledInit];
}

- (instancetype) p_swizzledInitWithTimeIntervalSinceNow:(NSTimeInterval)secs {
    if( fakedNow ){
        /* In init method, we return onother instance!  So we need to force retain this instance(fakedNow) */
        NSDate *instance = [self initWithTimeInterval:secs sinceDate:fakedNow];
        return [[self class] p_forceRetain:instance];
    }
    return [self p_swizzledInitWithTimeIntervalSinceNow:secs];
}

- (NSTimeInterval) p_swizzledTimeIntervalSinceNow {
    if( fakedNow ){
        return [ self timeIntervalSinceDate:fakedNow];
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
        [self p_swizzleInstanceMethodWithOriginal:@selector(initWithTimeIntervalSinceNow:)
                                           new:@selector(p_swizzledInitWithTimeIntervalSinceNow:)
        ];
        /*  NSDate is ClassCluster. So we need to swizzle  __NSPlaceholderDate#init to swizzle real init implemetion
         * see alos: http://stackoverflow.com/questions/27152287/stub-nsdate-init/27152985#27152985 */
        [self p_swizzleInstanceMethodWithOriginal:@selector(init)
                                           new:@selector(p_swizzledInit)
                                    originalClass:NSClassFromString(@"__NSPlaceholderDate")
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
