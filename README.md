NSDate+SRGFekable
===========


[![CI Status](http://img.shields.io/travis/soragoto/NSDate-SRGFekable.svg?style=flat)](https://travis-ci.org/soragoto/NSDate-SRGFekable)
[![Version](https://img.shields.io/cocoapods/v/NSDate+SRGFekable.svg?style=flat)](https://github.com/soragoto/NSDate-SRGFekable)
[![License](https://img.shields.io/cocoapods/l/NSDate+SRGFekable.svg?style=flat)](https://github.com/soragoto/NSDate-SRGFekable)
[![Platform](https://img.shields.io/cocoapods/p/NSDate+SRGFekable.svg?style=flat)](https://github.com/soragoto/NSDate-SRGFekable)

NSDate+SRGFekable is a category to fake results of NSDate. You can test your app features that depend on date more easily.

## Installation

Add the following line to your podfile and run `pod update`.

```ruby
pod  'NSDate+SRGFekable'
```

## Usage

At first you need to include header file.

```objc
#import 'NSDate+SRGFekable'
```

You can fake NSDate simply


```objc
// You can fake result of NSDate.
[NSDate fakeWithString:@"2014/12/27 10:00:00"];

// On this process, NSDate behave as if  current-time is "2014/12/27 10:00:00"
 NSLog(@"now:%@",[NSDate date]); // -> now:2014/12/27 10:00:00
````

By using this category , you can write unit tests easily.

```objc
....
- (void)testIsXmas {
    SeasonalEvent *seasonalEvent = [SeasonalEvent new];

    [NSDate fakeWithString:@"2014/12/20 10:00:00"];
    XCTAssertFalse( seasonalEvent.isXmas );
    
    [NSDate fakeWithString:@"2014/12/25 10:00:00"];
    XCTAssertTrue( seasonalEvent.isXmas );
}
...
````

## All methods

### fakeWithDate

You can fake from another NSDate instance..


```objc
NSDate *aDate = [NSDate dateWithTimeIntervalSinceNow:100];
[NSDate fakeWithDate:aDate];

// NSDate behave as if current-time is  aDate
````

### fakeWithDelta 


```objc
// NSDate behave as if current-time is  60 seconds latter of real date.
[NSDate fakeWithDelta:100];

// NSDate behave as if current-time is  180(=120+60) seconds latter of real date.
[NSDate fakeWithDelta:120];

//// NSDate behave as if current-time is  150(=180-30) seconds latter of real date.
[NSDate fakeWithDelta:-30];
````

### Stop stopFaking

```objc
//  You can stop faking.
[NSDate stopFaking];

// You can get status of faking or not.
BOOL doFaking = [NSDate doFaking];
````

### freeze option

Each  `fakeXXX` methods have `freeze` option. (Default is `YES`)

* If `freeze` is `YES`、faked date is completely stop.
* If `freeze` is  `NO`, faked date go on.

This option may be useful when you fake date on Main Project(not Test Project) for manually test.


```objc
// YES is default.
[NSDate fakeWithString:@"2014/12/27 10:00:00" freeze:YES];
   //  -> [NSDate date] always return @"2014/12/27 10:00:00"

// freeze:NO
[NSDate fakeWithString:@"2014/12/27 10:00:00" freeze:NO];
   // ->  If elapsed 10 seconds after call above, [NSDate date] returns @"2014/12/27 10:00:10"
````

## LICENSE

NSDate+SRGFekable is released under the MIT license. See LICENSE for details.
