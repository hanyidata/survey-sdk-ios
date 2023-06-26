//
//  DemoViewController.m
//  surveySDK-example
//
//  Created by Winston on 2023/6/9.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoViewController.h"

#import "surveySDK-Swift.h"

@implementation DemoViewController

NSString* surveyId = @"4445329530320896";
NSString* channelId = @"4446931357162496";
NSDictionary* params;
NSDictionary *options;

+ (void)initialize {
    if(!params)
        params = [NSDictionary dictionary];
    if(!options)
        options = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"Assets", @"assets",
                   @"BOTTOM", @"embedVerticalAlign",
//                   @("40%"), @"embedHeight",
//                   @"FIX", @"embedHeightMode",
//                   @(20), @"cornerRadius",
//                   @(true), @"embedBackGround",
//                   @"BOTTOM", @"embedVerticalAlign",
                   @(true), @"debug", @"https://jltest.xmplus.cn/api/survey", @"server", @(true), @"autoheight", nil];
}


- (id)initWithText:(NSString *)details {
  self = [super init];
  return self;
}

- (void)loadView {
  [super loadView];
}

-(void) button1Clicked:(UIButton*)sender {
    NSLog(@"you clicked on nested survey");
    
    _survey = [HYUISurveyView makeSurveyControllerWithSurveyId:surveyId channelId:channelId parameters:params options:options onSubmit:^() {
        NSLog(@"提交");
    } onCancel:^() {
        NSLog(@"取消");
    } onSize:^(NSInteger height) {
        NSLog(@"Size %ld", (long)height);
    } onClose:^() {
        NSLog(@"关闭");
    }];
    
    
    _label2 = [[UILabel alloc] init];
    _label2.text = @"item2";

    [_stackview addArrangedSubview:_survey];
    [_stackview addArrangedSubview:_label2];

}

-(void) button2Clicked:(UIButton*)sender {
    NSLog(@"you clicked on popup survey");
    [HYPopupDialog makeDialogWithContext:self surveyId:surveyId channelId:channelId parameters:params options:options onSubmit:^{
        NSLog(@"onSubmit");
    } onCancel:^{
        NSLog(@"cancel");
    } onError:^(NSString*  error) {
        NSLog(@"error: %@", error);
    } assets:@"Assets"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    //  [self setTitle:@"My Child View"];
//    view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    [self.view setBackgroundColor:UIColor.lightGrayColor];
    
    _button1 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setTitle:@"Nested Survey" forState:UIControlStateNormal];
    [_button1 setTitleColor: UIColor.blackColor forState: UIControlStateNormal];
    [_button1 setExclusiveTouch:YES];

    _button2 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 setTitle:@"Popup Survey" forState:UIControlStateNormal];
    [_button2 setTitleColor: UIColor.blackColor forState: UIControlStateNormal];
    [_button2 setExclusiveTouch:YES];

    
    //    button.widthAnchor.constraint(equalToConstant: 80).isActive = true
    
    _label1 = [[UILabel alloc] init];
    _label1.text = @"item1";

    _label2 = [[UILabel alloc] init];
    _label2.text = @"item2";

    _survey = [HYUISurveyView makeSurveyControllerWithSurveyId:surveyId channelId:channelId parameters:params options:options onSubmit:^() {
        NSLog(@"提交");
    } onCancel:^() {
        NSLog(@"取消");
    } onSize:^(NSInteger height) {
    } onClose:^() {
        NSLog(@"关闭");
    }];
    
    _stackview = [[UIStackView alloc] initWithFrame:self.view.bounds];

    _stackview.translatesAutoresizingMaskIntoConstraints = false;
    _stackview.alignment = UIStackViewAlignmentFill;
    _stackview.axis = UILayoutConstraintAxisVertical;
    _stackview.distribution = UIStackViewDistributionFill;
    
    
    [_stackview addArrangedSubview:_button1];
    [_stackview addArrangedSubview:_button2];
    [_stackview addArrangedSubview:_label1];
    [self.view addSubview:_stackview];
        
    [_stackview.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [_stackview.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [_stackview.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = true;
}

@end
