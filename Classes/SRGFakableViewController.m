//
//  SRGFakableViewController.m
//  NSDate+SRGFekable
//
//  Created by nori0620 on 2015/01/02.
//  Copyright (c) 2015年 soragoto. All rights reserved.
//

#import "SRGFakableViewController.h"
#import "NSDate+SRGFekable.h"

@interface SRGFakableViewController ()

@property NSTimer *timer;
@property (nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *dateResultLabel;
@property (nonatomic) IBOutlet UIButton *startFakingButton;
@property (nonatomic) IBOutlet UIButton *stopFakingButton;
@property (nonatomic) IBOutlet UIButton *doFakeButton;
@property (nonatomic) IBOutlet NSLayoutConstraint *pickerHeight;
@property (nonatomic) BOOL doSelectiongDate;

@end

@implementation SRGFakableViewController

+ (void)showOn:(UIViewController *)below{
    SRGFakableViewController *controller = [[[self class] alloc] initWithNibName:NSStringFromClass([self class])
                                            
                                                                          bundle:nil];
    UINavigationController *navigationController = [UINavigationController new];
    [navigationController pushViewController:controller animated:NO];
    [below presentViewController:navigationController
                             animated:YES
                      completion:nil];
    
}

# pragma  mark - Life cycle events

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"Fake NSDate";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self showDoneToNavigation];
    [self updateVisibility];
    [self updateLabels];
    [self updateButtonEnability];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateLabels)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.pickerHeight.constant = _doSelectiongDate ? 100 : 0 ;
}

#pragma mark - Tap Handlers


- (IBAction)didTapStartFakingDate:(id)sender {
    self.datePicker.date = [NSDate date];
    self.doSelectiongDate = YES;
}

- (IBAction)didTapStopFakingDate:(id)sender {
    [NSDate stopFaking];
    [self updateLabels];
    [self updateButtonEnability];
}

- (IBAction)didTapDoFake:(id)sender {
    [NSDate fakeWithDate: _datePicker.date
                      freeze:NO
     ];
    [self updateLabels];
    [self updateButtonEnability];
    self.doSelectiongDate = NO;
}

- (void) didTapDone {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Status Updater

- (void) updateVisibility {
    self.dateResultLabel.alpha = !_doSelectiongDate;
    self.startFakingButton.alpha = !_doSelectiongDate;
    self.stopFakingButton.alpha = !_doSelectiongDate;
    self.datePicker.alpha =  _doSelectiongDate;
    self.doFakeButton.alpha = _doSelectiongDate;
}

- (void) updateLabels{
    self.dateResultLabel.text = [self stringFromDate:[NSDate date]];
    self.titleLabel.text = [NSDate doFaking]
        ? @"Result of NSDate.date(!Faking!)"
        : @"Result of NSDate.date(original)";
    self.titleLabel.textColor = [NSDate doFaking]
        ? [UIColor redColor]
        : [UIColor colorWithRed:83.0f/255.0f
                          green:181.0f/255.0f
                           blue:26.0f/255.0f
                          alpha:1.0f];   
}

- (void) updateButtonEnability {
    self.stopFakingButton.enabled  = [NSDate doFaking];
    self.startFakingButton.enabled = ![NSDate doFaking];
}


- (void)setDoSelectiongDate:(BOOL)doSelectiongDate {
    _doSelectiongDate = doSelectiongDate;
    __weak typeof(self) wSlef = self;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            [wSlef updateVisibility];
            [wSlef.view setNeedsUpdateConstraints];
            [wSlef.view layoutIfNeeded];
        }
        completion:nil
    ];
}

# pragma mark - Utils

- (void) showDoneToNavigation {
    UIBarButtonItem *done = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                             target:self
                             action:@selector(didTapDone)];
    self.navigationItem.leftBarButtonItem = done;
}

- (NSString *) stringFromDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return  [df stringFromDate:date];
}

@end
