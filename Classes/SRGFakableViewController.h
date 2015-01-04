//
//  SRGFakableViewController.h
//  NSDate+SRGFekable
//
//  Created by nori0620 on 2015/01/02.
//  Copyright (c) 2015年 soragoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRGFakableViewController : UIViewController

+ (void) showOn:(UIViewController *)below
   freezeOnFake:(BOOL)freezeOnFake;

@end
