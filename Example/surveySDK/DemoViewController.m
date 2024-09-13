//
//  DemoViewController.m
//  surveySDK-example
//
//  Created by Winston on 2023/6/9.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoViewController.h"
#import "DemoDialogViewController.h"

#import "surveySDK-Swift.h"

@implementation DemoViewController


Boolean halfscreen = false;
Boolean showClose = false;
Boolean authRequired = false;

NSString* accessCode = @"";
//NSString* accessCode = @"1283860798057988096";
NSString* euid = @"";
NSString* orgCode = @"";
//NSString* orgCode = @"lynkco_cem";
NSString* sendId = @"";
NSString* language = @"zh-cn";

//
//NSString* surveyId = @"5623325575501824";
//NSString* channelId = @"5623326819536896";
//NSString* server = @"https://test.xmplus.cn/api/survey";
//NSString* surveyId = @"5697821736660992";
//NSString* channelId = @"5697830732525568";
//NSString* surveyId = @"6094902492655616";
//NSString* channelId = @"6094905475723264";

NSString* surveyId = @"6949244674686976";
NSString* channelId = @"6949245294067712";
//NSString* sendId = @"BddfddRImjktRzRk";
NSString* server = @"https://galaxy-h5-test.geely-test.com/api/survey";


//NSString* surveyId = @"6829192408645632";
//NSString* channelId = @"6880930353772544";
//NSString* server = @"https://www.xmplus.cn/api/survey";

NSDictionary* params;
NSDictionary *options;

+ (void)initialize {
    // 全局设置
    [HYGlobalConfig setupWithServer:server];
    
    if (authRequired) {
        [HYGlobalConfig setupWithServer:server orgCode:orgCode accessCode:accessCode authRequired:true];
    }
    
    if(!params)
        params = [[NSDictionary alloc] initWithObjectsAndKeys:
                  accessCode, @"accessCode",
                  euid, @"externalUserId",
                  nil];
    
//    if(!options)
//        options = [[NSDictionary alloc] initWithObjectsAndKeys:
//                   @"Assets", @"assets", @(0), @"showDelay",  language, @"language",  @(true),  @"clickDismiss",  @(true),  @"force", @(true), @"debug", server, @"server", @(halfscreen), @"halfscreen", nil];

    if(!options)
        options = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"Assets", @"assets", @(0), @"showDelay",  language, @"language",  @(true),  @"clickDismiss",  @(true),  @"force", @(true), @"debug", @(halfscreen), @"halfscreen", nil];

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
    if (sendId.length > 0) {
        [HYUISurveyView makeSurveyControllerAsyncWithSendId:sendId parameters:params options:options  onReady:^(HYUISurveyView* view) {
                NSLog(@"ready");
                _survey = view;
                [_stackview addArrangedSubview:_survey];
        }  onError:^(NSString* error) {
            NSLog(@"%@", error);
        }  onSubmit:^() {
            NSLog(@"提交");
        } onCancel:^() {
            NSLog(@"取消");
        } onSize:^(NSInteger height) {
            NSLog(@"Size %ld", (long)height);
        } onClose:^() {
            NSLog(@"关闭");
        }];

    } else {
        [HYUISurveyView makeSurveyControllerAsyncWithSurveyId:surveyId channelId:channelId parameters:params options:options  onReady:^(HYUISurveyView* view) {
                NSLog(@"ready");
                _survey = view;
                [_stackview addArrangedSubview:_survey];
        }  onError:^(NSString* error) {
            NSLog(@"%@", error);
        }  onSubmit:^() {
            NSLog(@"提交");
        } onCancel:^() {
            NSLog(@"取消");
        } onSize:^(NSInteger height) {
            NSLog(@"Size %ld", (long)height);
        } onClose:^() {
            NSLog(@"关闭");
        }];

    }

}

-(void) button2Clicked:(UIButton*)sender {
//    DemoDialogViewController *newViewController = [DemoDialogViewController setUpWithSurveyId:surveyId channelId:channelId server:server parameters:params options:options];
//    newViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//
//    [self presentViewController:newViewController animated:YES completion:^{
////        [newViewController showUp];
//    }];
    NSLog(@"you clicked on popup survey");
    if (sendId.length > 0) {
        [HYPopupDialog makeDialogBySendIdWithContext:self sendId:sendId parameters:params options:options onSubmit:^{
            NSLog(@"onSubmit");
        } onCancel:^{
            NSLog(@"cancel");
        } onError:^(NSString*  error) {
            NSLog(@"error: %@", error);
        }];

    } else {
        [HYPopupDialog makeDialogWithContext:self surveyId:surveyId channelId:channelId parameters:params options:options onSubmit:^{
            NSLog(@"onSubmit");
        } onCancel:^{
            NSLog(@"cancel");
        } onError:^(NSString*  error) {
            NSLog(@"error: %@", error);
        }];

    }
}


-(void) button3Clicked:(UIButton*)sender {
//    [HYTestDialog makeDialogWithContext:self surveyId:surveyId channelId:channelId parameters:params options:options onSubmit:^{
//        NSLog(@"onSubmit");
//    } onCancel:^{
//        NSLog(@"cancel");
//    } onError:^(NSString*  error) {
//    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor whiteColor]];

    [self.view setBackgroundColor:UIColor.grayColor];
    
    
    _button1 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setTitle:@"Nested Survey" forState:UIControlStateNormal];
    [_button1 setTitleColor: UIColor.blackColor forState: UIControlStateNormal];
    [_button1 setExclusiveTouch:YES];

    _button2 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 setTitle:@"Popup Demo" forState:UIControlStateNormal];
    [_button2 setTitleColor: UIColor.blackColor forState: UIControlStateNormal];
    [_button2 setExclusiveTouch:YES];
    
    _button3 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button3 addTarget:self action:@selector(button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_button3 setTitle:@"Popup TEST" forState:UIControlStateNormal];
    [_button3 setTitleColor: UIColor.blackColor forState: UIControlStateNormal];
    [_button3 setExclusiveTouch:YES];


    _label1 = [[UILabel alloc] init];
    _label1.text = @"item1";

    _label2 = [[UILabel alloc] init];
    _label2.text = @"item2";

    _stackview = [[UIStackView alloc] initWithFrame:self.view.bounds];

    self.view.translatesAutoresizingMaskIntoConstraints = false;
    _stackview.translatesAutoresizingMaskIntoConstraints = false;
    _stackview.alignment = UIStackViewAlignmentFill;
    _stackview.axis = UILayoutConstraintAxisVertical;
    _stackview.distribution = UIStackViewDistributionFill;
    
    
    [_stackview addArrangedSubview:_button1];
    [_stackview addArrangedSubview:_button2];
    [_stackview addArrangedSubview:_button3];

    [_stackview addArrangedSubview:_label1];
    [self.view addSubview:_stackview];
        
    [_stackview.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [_stackview.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [_stackview.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = true;
}

@end
