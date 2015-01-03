//
//  ViewController.m
//  NSDate+SRGFekable
//
//  Created by nori0620 on 2015/01/01.
//  Copyright (c) 2015年 soragoto. All rights reserved.
//

#import "ViewController.h"
#import "SRGFakableViewController.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UILabel *currentDateLabel;
@property NSTimer *timer;

@end

@implementation ViewController

- (NSString *)title {
    return @"NSDate+SRGFakable";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_updateDateLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(p_updateDateLabel)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (IBAction)didTapLaunchFaker:(id)sender {
    [SRGFakableViewController showOn:self];
}

- (void) p_updateDateLabel {
    self.currentDateLabel.text = [NSString stringWithFormat:@"now:%@",[NSDate date]];
}

@end
