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
    [NSDate srg_stopFaking];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDate {
    NSDate *realDate = [NSDate date];
    XCTAssertFalse([NSDate srg_doFaking]);
    
    [NSDate srg_fakeWithDate:[NSDate dateWithTimeIntervalSinceNow:100]];
    NSDate *fakedDate = [NSDate date];
    XCTAssertTrue([NSDate srg_doFaking]);
    
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    XCTAssertTrue([NSDate srg_doFaking]);
    
    [NSDate srg_stopFaking];
    NSDate *realDate2 = [NSDate date];
    XCTAssertFalse([NSDate srg_doFaking]);
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
}

- (void)testInit {
    NSDate *realDate = [[NSDate alloc] init];
    
    [NSDate srg_fakeWithDate:[NSDate dateWithTimeIntervalSinceNow:100]];
    
    NSDate *fakedDate = [[NSDate alloc] init];
    
 
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    
    [NSDate srg_stopFaking];
    NSDate *realDate2 = [[NSDate alloc] init];
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
}

- (void)testNew {
    NSDate *realDate = [NSDate new];
    
    [NSDate srg_fakeWithDate:[NSDate dateWithTimeIntervalSinceNow:100]];
    
    NSDate *fakedDate = [NSDate new];
    
 
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    
    [NSDate srg_stopFaking];
    NSDate *realDate2 = [NSDate new];
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
}



- (void) testDateWithTimeIntervalSinceNow {
    
    NSDate *realDate = [NSDate dateWithTimeIntervalSinceNow:300];
    
    [NSDate srg_fakeWithDate:
        [NSDate dateWithTimeIntervalSinceNow:100]
    ];
    
    NSDate *fakedDate = [NSDate dateWithTimeIntervalSinceNow:300];
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    
    [NSDate srg_stopFaking];
    NSDate *realDate2 = [NSDate dateWithTimeIntervalSinceNow:300];
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
    
}

- (void) testInitWithTimeIntervalSinceNow {
    NSDate *realDate = [[NSDate alloc] initWithTimeIntervalSinceNow:300];
    
    [NSDate srg_fakeWithDate:
        [NSDate dateWithTimeIntervalSinceNow:100]
    ];
    
    NSDate *fakedDate = [[NSDate alloc] initWithTimeIntervalSinceNow:300];
    XCTAssertEqual((int)[fakedDate timeIntervalSinceDate:realDate],100);
    
    [NSDate srg_stopFaking];
    NSDate *realDate2 = [[NSDate alloc] initWithTimeIntervalSinceNow:300];
    XCTAssertEqual((int)[realDate2 timeIntervalSinceDate:realDate],0);
    
}

- (void) testTimeIntervalSinceNow {
    
    NSDate *aDate = [NSDate date];
    
    NSTimeInterval realInterval = [aDate timeIntervalSinceNow];
    
    [NSDate srg_fakeWithDate:
        [NSDate dateWithTimeIntervalSinceNow:-100]
    ];
    
    NSTimeInterval fakeInterval = [aDate timeIntervalSinceNow];
    
    NSTimeInterval diff = fakeInterval - realInterval;
    BOOL expected =  diff >= 99.0 && diff <= 100.0;
    XCTAssertTrue( expected  );
    
    [NSDate srg_stopFaking];
    NSTimeInterval realInterval2 = [aDate timeIntervalSinceNow];
    XCTAssertEqual( (int)realInterval2 - (int)realInterval,0);
    
}

- (void) testFakeWithString{
    
    [NSDate srg_fakeWithString:@"2014/01/05 11:32:00"
                      timeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]
    ];
    NSTimeInterval intervalSince1970 = [[NSDate date] timeIntervalSince1970];
    XCTAssertEqual(intervalSince1970, 1388889120 );
    
}
 

@end
