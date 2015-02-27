//
//  NSDate_SRGFekableTests.m
//  NSDate+SRGFekableTests
//
//  Created by nori0620 on 2015/01/01.
//  Copyright (c) 2015年 soragoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSDate+SRGFekable.h"

@interface NSDate_SRGFekableTests : XCTestCase

@end

@implementation NSDate_SRGFekableTests

- (void)setUp {
    [NSDate stopFaking];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDate {
    NSDate *realDate = [NSDate date];
    XCTAssertFalse([NSDate doFaking]);
    
    [NSDate fakeWithDate:[NSDate dateWithTimeIntervalSinceNow:100] ];
    NSDate *fakedDate = [NSDate date];
    XCTAssertTrue([NSDate doFaking]);
    
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    XCTAssertTrue([NSDate doFaking]);
    
    [NSDate stopFaking];
    NSDate *realDate2 = [NSDate date];
    XCTAssertFalse([NSDate doFaking]);
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
}

- (void)testInit{
    NSDate *realDate = [[NSDate alloc] init];
    
    [NSDate fakeWithDate:[NSDate dateWithTimeIntervalSinceNow:100]
                      freeze:YES
     ];
    NSDate *fakedDate =  [[NSDate alloc] init];
    
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    
    [NSDate stopFaking];
    NSDate *realDate2 = [[NSDate alloc] init];
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
}

- (void)testInitWithTimeIntervalSinceNow{
    
    NSDate *realDate = [NSDate new];
    NSDate *realDate60 = [[NSDate alloc] initWithTimeIntervalSinceNow:60];
    NSTimeInterval realDiff = [realDate60 timeIntervalSinceDate:realDate];
    
    [NSDate fakeWithString:@"2014/11/11 11:11:11"];
    
    NSDate *fakeDate = [NSDate date];
    NSDate *fakeDate60 = [[NSDate alloc] initWithTimeIntervalSinceNow:60];
    NSTimeInterval fakeDiff = [fakeDate60 timeIntervalSinceDate:fakeDate];
    
    XCTAssertEqual(
        (int)realDiff,
        (int)fakeDiff
    );
   
}

- (void)testNow {
    NSDate *realDate = [NSDate now];
    
    [NSDate fakeWithDate:[NSDate dateWithTimeIntervalSinceNow:100]
                      freeze:YES
     ];
    NSDate *fakedDate = [NSDate now];
    
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    
    [NSDate stopFaking];
    NSDate *realDate2 = [NSDate now];
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
}


- (void) testDateWithTimeIntervalSinceNow {
    
    NSDate *realDate = [NSDate dateWithTimeIntervalSinceNow:300];
    
    [NSDate fakeWithDate:
        [NSDate dateWithTimeIntervalSinceNow:100]
                      freeze:YES
    ];
    
    NSDate *fakedDate = [NSDate dateWithTimeIntervalSinceNow:300];
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    
    [NSDate stopFaking];
    NSDate *realDate2 = [NSDate dateWithTimeIntervalSinceNow:300];
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
    
}

- (void) testTimeIntervalSinceNow {
    
    NSDate *aDate = [NSDate date];
    
    NSTimeInterval realInterval = [aDate timeIntervalSinceNow];
    
    [NSDate fakeWithDate: [NSDate dateWithTimeIntervalSinceNow:-100]
                      freeze:YES
    ];
    
    NSTimeInterval fakeInterval = [aDate timeIntervalSinceNow];
    
    NSTimeInterval diff = fakeInterval - realInterval;
    BOOL expected =  diff >= 99.0 && diff <= 100.0;
    XCTAssertTrue( expected  );
    
    [NSDate stopFaking];
    NSTimeInterval realInterval2 = [aDate timeIntervalSinceNow];
    XCTAssertEqual( (int)realInterval2 - (int)realInterval,0);
    
}

- (void) testFakeWithStringAndTimeZone{
    
    [NSDate fakeWithString:@"2014/01/05 11:32:00"
                  timeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]
     ];
    NSTimeInterval intervalSince1970 = [[NSDate date] timeIntervalSince1970];
    XCTAssertEqual(intervalSince1970, 1388889120 );
    
}

- (void) testFakeWithStringTimeZoneAndFreeze{
    
    [NSDate fakeWithString:@"2014/01/05 11:32:00"
                      timeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]
                        freeze:YES
    ];
    NSTimeInterval intervalSince1970 = [[NSDate date] timeIntervalSince1970];
    XCTAssertEqual(intervalSince1970, 1388889120 );
    
}

- (void) testFakeWithDelta {
    NSDate *realDate = [NSDate date];
    
    [NSDate fakeWithDelta:60];
    
    NSDate *fakedDate = [NSDate date];
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],60);
    
    [NSDate fakeWithDelta:120];
    NSDate *fakedDate2 = [NSDate date];
    
    XCTAssertEqual((int)[fakedDate2 timeIntervalSinceDate:realDate],180);
    
    [NSDate fakeWithDelta:-60];
    NSDate *fakedDate3 = [NSDate date];
    XCTAssertEqual((int)[fakedDate3 timeIntervalSinceDate:realDate],120);
    
    [NSDate stopFaking];
    NSDate *realDate2 = [NSDate date];
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
    
}
 

@end
