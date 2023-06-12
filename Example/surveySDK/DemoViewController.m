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

- (id)initWithText:(NSString *)details {
  self = [super init];
  return self;
}

- (void)loadView {
  [super loadView];
}

-(void) buttonClicked:(UIButton*)sender {
    NSLog(@"you clicked on show survey");
//    [_survey.heightAnchor constraintEqualToConstant:100].active = false;
//    [_survey.heightAnchor constraintEqualToConstant:300].active = false;
    NSLog(@"%lu", (unsigned long)_survey.constraints.count);
    _survey.constraints.lastObject.constant = 300;
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    [self.view layoutIfNeeded];
    [self.view sizeToFit];
    [self.view layoutSubviews];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //  [self setTitle:@"My Child View"];
    
    _button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"Show Survey" forState:UIControlStateNormal];
    [_button setTitleColor: UIColor.blackColor forState: UIControlStateNormal];
    [_button setExclusiveTouch:YES];

    //    button.widthAnchor.constraint(equalToConstant: 80).isActive = true
    
    _label1 = [[UILabel alloc] init];
    _label1.text = @"item1";

    _label2 = [[UILabel alloc] init];
    _label2.text = @"item2";

    NSString* surveyId = @"3512748182348800";
    NSString* channelId = @"3512750347396096";
    NSDictionary* params = [NSDictionary dictionary];
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
        @"test", @"server", @(true), @"autoheight", nil];

    _survey = [HYUISurveyView makeSurveyControllerWithSurveyId:surveyId channelId:channelId parameters:params options:options onSubmit:^() {
        NSLog(@"提交");
    } onCancel:^() {
        NSLog(@"取消");
    } onSize:^(NSInteger height) {
    } onClose:^() {
        NSLog(@"关闭");
    } assets:@"Assets"];
    
    _stackview = [[UIStackView alloc] initWithFrame:self.view.bounds];

    _stackview.translatesAutoresizingMaskIntoConstraints = false;
    _stackview.alignment = UIStackViewAlignmentFill;
    _stackview.axis = UILayoutConstraintAxisVertical;
    _stackview.distribution = UIStackViewDistributionFill;
    
    
    [_stackview addArrangedSubview:_button];
    [_stackview addArrangedSubview:_label1];
    [_stackview addArrangedSubview:_survey];
    [_stackview addArrangedSubview:_label2];
    [self.view addSubview:_stackview];
        
    [_stackview.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [_stackview.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [_stackview.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = true;
}

@end
