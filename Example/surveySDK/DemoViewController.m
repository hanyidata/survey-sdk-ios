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


Boolean halfscreen = true;
Boolean globalConfig = true;
//NSString* accessCode = @"";
NSString* accessCode = @"1233114638330048512";
NSString* euid = @"";
NSString* project = @"";

//
//NSString* surveyId = @"3937853687522304";
//NSString* channelId = @"5624361339637760";
//NSString* server = @"https://test.xmplus.cn/api/survey";

//NSString* surveyId = @"4831576886942720";
//NSString* channelId = @"4831596133686272";
////NSString* surveyId =  @"4475020361170944";
////NSString* channelId = @"4496490408345600";
//
//NSString* server = @"https://mktcs-uat.lynkco-test.com/api/survey";

//https://mktcslynkco-uat.geely-test.com/cem/touchs/surveyPublish/app?id=6138603223408640&cid=6138605818109952
//UAT
NSString* surveyId = @"4475002070663168";
NSString* channelId = @"4475389028433920";
//NSString* surveyId =  @"4475020361170944";
//NSString* channelId = @"4496490408345600";

NSString* server = @"https://mktcs-uat.lynkco-test.com/api/survey";

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
                   @"Assets", @"assets", @(true), @"force", @(true), @"debug", server, @"server", project, @"project", @(halfscreen), @"halfscreen", nil];
    }
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
    [HYUISurveyView makeSurveyControllerAsyncWithSurveyId:surveyId channelId:channelId parameters:params options:options  onReady:^(HYUISurveyView* view) {
        NSLog(@"ready");
        _survey = view;
//        CGRect frame = CGRectMake(0, 0, view.frame.size.width, 0);
        [_stackview addArrangedSubview:_survey];
//        [self.view addSubview:_survey];
        [_survey show];

        _label2 = [[UILabel alloc] init];
        _label2.text = @"item2";
        [_stackview addArrangedSubview:_label2];

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
    }
//    } onLoad:^(NSDictionary<NSString *,id> * _) {
//        NSLog(@"onLoad");
//    }
    ];
    
    
//    _label2 = [[UILabel alloc] init];
//    _label2.text = @"item2";
//
//    [_stackview addArrangedSubview:_survey];
//    [_stackview addArrangedSubview:_label2];

}

-(void) button2Clicked:(UIButton*)sender {
    
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
//    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    //  [self setTitle:@"My Child View"];
//    view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//    table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    table.delegate = self;
//    table.dataSource = self;
//
//    [self.view addSubview:tableView];
    
//    [HYG]
    if (globalConfig) {
        [HYGlobalConfig setupWithServer:server accessCode:accessCode authRequired:true];
    }
    [self.view setBackgroundColor:UIColor.grayColor];
    
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

  
    
    _stackview = [[UIStackView alloc] initWithFrame:self.view.bounds];

    _stackview.translatesAutoresizingMaskIntoConstraints = false;
    _stackview.alignment = UIStackViewAlignmentFill;
    _stackview.axis = UILayoutConstraintAxisVertical;
    _stackview.distribution = UIStackViewDistributionFill;
    
    
    [_stackview addArrangedSubview:_button1];
    [_stackview addArrangedSubview:_button2];
    [_stackview addArrangedSubview:_label1];
    [self.view addSubview:_stackview];
        
    CGFloat width = halfscreen ? self.view.frame.size.width / 2 : self.view.frame.size.width;
    [_stackview.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [_stackview.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [_stackview.widthAnchor constraintEqualToConstant:width].active = true;
}

@end
