//
//  DemoDialogViewController.m
//  surveySDK-example
//
//  Created by Winston on 2024/5/7.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DemoDialogViewController.h"

#import "surveySDK-Swift.h"

@implementation DemoDialogViewController

+ (DemoDialogViewController*)setUpWithSurveyId:(NSString *)surveyId channelId:(NSString*)channelId server:(NSString*)server parameters:(NSDictionary*)parameters options:(NSDictionary*)options {
    
    DemoDialogViewController* dialog = [[DemoDialogViewController alloc] init];
    dialog.surveyId = surveyId;
    dialog.channelId = channelId;
    dialog.server = server;
    dialog.options = options;
    dialog.parameters = parameters;

    return dialog;
}


- (id)initWithText:(NSString *)details {
  self = [super init];
  return self;
}

- (void)loadView {
  [super loadView];
}


-(void) button2Clicked:(UIButton*)sender {
    NSLog(@"you clicked on popup survey");
    [HYPopupDialog makeDialogWithContext:self surveyId:_surveyId channelId:_channelId parameters:_parameters options:_options onSubmit:^{
        NSLog(@"onSubmit");
    } onCancel:^{
        NSLog(@"cancel");
    } onError:^(NSString*  error) {
        NSLog(@"error: %@", error);
    }];

}

-(void) closeButtonClick:(UIButton*)sender {
    NSLog(@"you clicked on close");
    [HYPopupDialog close];
    [self dismissViewControllerAnimated:TRUE completion:^{
        NSLog(@"dismissed");
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor: [UIColor whiteColor]];
//    [self setTitle: @"Popup Demo Controller"];
    
    
    _closebutton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_closebutton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_closebutton setTitle:@"Close" forState:UIControlStateNormal];
    [_closebutton setTitleColor: UIColor.redColor forState: UIControlStateNormal];
    [_closebutton setExclusiveTouch:YES];
    
    _button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"Popup Survey 22" forState:UIControlStateNormal];
    [_button setTitleColor: UIColor.blackColor forState: UIControlStateNormal];
    [_button setExclusiveTouch:YES];

        
    _stackview = [[UIStackView alloc] initWithFrame:self.view.bounds];

    _stackview.translatesAutoresizingMaskIntoConstraints = false;
    _stackview.alignment = UIStackViewAlignmentCenter;
    _stackview.axis = UILayoutConstraintAxisVertical;
    _stackview.distribution = UIStackViewDistributionFill;

    // 创建一个spacer view
    UIView *spacerView = [[UIView alloc] init];
    spacerView.backgroundColor = [UIColor clearColor]; // 使 spacer view 不可见

    UIView *bottomSpacer = [[UIView alloc] init];
    bottomSpacer.backgroundColor = [UIColor clearColor]; // 使 spacer view 不可见

    // 设置 spacer view 的内容压缩抗力和内容拉伸抗力为最低
//    [spacerView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
//    [spacerView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    NSLayoutConstraint *bottomSpacerHeight = [NSLayoutConstraint constraintWithItem:bottomSpacer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]; // 你可以调整 constant 的值以调整空间大小
    [bottomSpacer addConstraint:bottomSpacerHeight];
    
    NSLayoutConstraint *topSpacerHeight = [NSLayoutConstraint constraintWithItem:spacerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]; // 你可以调整 constant 的值以调整空间大小
    [spacerView addConstraint:topSpacerHeight];


    
    
//    [_stackview addArrangedSubview:_button1];
    [_stackview addArrangedSubview:_closebutton];
    [_stackview addArrangedSubview:spacerView];
    [_stackview addArrangedSubview:_button];
    [_stackview addArrangedSubview:bottomSpacer];

    [self.view addSubview:_stackview];
        
//    [_stackview.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
//    [_stackview.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
//    [_stackview.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = true;
    
    [_stackview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_stackview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [_stackview.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_stackview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;


}

@end
