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


Boolean halfscreen = true;
Boolean globalConfig = true;
NSString* accessCode = NULL;
//NSString* accessCode = @"1233114638330048512";
NSString* euid = @"";
NSString* project = @"";
NSString* sendId = @"";
NSString* language = @"zh-cn";

//
<<<<<<< HEAD
NSString* surveyId = @"6417370258754560";
NSString* channelId = @"6417382901173248";
NSString* server = @"https://test.xmplus.cn/api/survey";
=======
//NSString* surveyId = @"5623325575501824";
//NSString* channelId = @"5623326819536896";
//NSString* server = @"https://test.xmplus.cn/api/survey";
//NSString* surveyId = @"5697821736660992";
//NSString* channelId = @"5697830732525568";
//NSString* surveyId = @"6094902492655616";
//NSString* channelId = @"6094905475723264";

NSString* surveyId = @"6613886893283328";
NSString* channelId = @"6613888574806016";
//NSString* sendId = @"BddfddRImjktRzRk";


NSString* server = @"https://www.xmplus.cn/api/survey";

>>>>>>> develop

//NSString* surveyId = @"4831576886942720";
//NSString* channelId = @"4831596133686272";
////NSString* surveyId =  @"4475020361170944";
////NSString* channelId = @"4496490408345600";
//
//NSString* server = @"https://mktcs-uat.lynkco-test.com/api/survey";

//https://mktcslynkco-uat.geely-test.com/cem/touchs/surveyPublish/app?id=6138603223408640&cid=6138605818109952
//UAT
//NSString* surveyId = @"4475002070663168";
//NSString* channelId = @"4475389028433920";
//NSString* surveyId =  @"4475020361170944";
//NSString* channelId = @"4496490408345600";

//NSString* server = @"https://mktcs-uat.lynkco-test.com/api/survey";

NSDictionary* params;
NSDictionary *options;


+ (void)initialize {
    if(!params)
        params = [[NSDictionary alloc] initWithObjectsAndKeys:
                  accessCode, @"accessCode",
                  euid, @"externalUserId",
                  nil];
    
    if (globalConfig) {
        options = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"Assets", @"assets", @(true), @"force", @(true), @"debug", project, @"project", @(halfscreen), @"halfscreen", nil];
        
    } else {
        options = [[NSDictionary alloc] initWithObjectsAndKeys:
<<<<<<< HEAD
                   @"Assets", @"assets", @(true), @"force", @(true), @"debug", server, @"server", project, @"project", @(halfscreen), @"halfscreen", nil];
    }
=======
                   @"Assets", @"assets", @(0), @"showDelay", language, @"language",  @(true),  @"clickDismiss",  @(true),  @"force", @(true), @"debug", server, @"server", project, @"project", @(halfscreen), @"halfscreen", nil];
>>>>>>> develop
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

<<<<<<< HEAD
    }  onError:^(NSString* error) {
        NSLog(@"%@", error);
    }  onSubmit:^() {
        NSLog(@"提交");
    } onCancel:^() {
        NSLog(@"取消");
    } onSize:^(NSInteger height) {
        NSLog(@"Size %ld", (long)height);
        CGRect frameReact = _survey.frame;
//        frameReact.size.height = height;
//        frameReact.size.width = self.view.frame.size.width / 2;
        _survey.frame = frameReact;
    } onClose:^() {
        NSLog(@"关闭");
=======
>>>>>>> develop
    }

}

-(void) button2Clicked:(UIButton*)sender {
<<<<<<< HEAD
    
    NSLog(@"you clicked on popup survey");
    [HYPopupDialog makeDialogWithContext:self surveyId:surveyId channelId:channelId parameters:params options:options onSubmit:^{
        NSLog(@"onSubmit");
    } onCancel:^{
        NSLog(@"cancel");
    } onError:^(NSString*  error) {
        NSLog(@"error: %@", error);
    }];
//                                  onLoad:^(NSDictionary<NSString *,id> * _) {
//        NSLog(@"onLoad");
=======
//    DemoDialogViewController *newViewController = [DemoDialogViewController setUpWithSurveyId:surveyId channelId:channelId server:server parameters:params options:options];
//    newViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//
//    [self presentViewController:newViewController animated:YES completion:^{
////        [newViewController showUp];
>>>>>>> develop
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
<<<<<<< HEAD
    //  [self setTitle:@"My Child View"];
//    view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//    table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    table.delegate = self;
//    table.dataSource = self;
//
//    [self.view addSubview:tableView];
    
//    [HYG]
    if (globalConfig) {
        [HYGlobalConfig setupWithServer:server accessCode:accessCode authRequired:false];
    }
=======
    [self.view setBackgroundColor: [UIColor whiteColor]];

>>>>>>> develop
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
        
    CGFloat width = halfscreen ? self.view.frame.size.width / 2 : self.view.frame.size.width;
    [_stackview.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [_stackview.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [_stackview.widthAnchor constraintEqualToConstant:width].active = true;
}

@end
