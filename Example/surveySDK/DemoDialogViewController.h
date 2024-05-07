//
//  DemoDialogViewController.h
//  surveySDK
//
//  Created by Winston on 2024/5/7.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#ifndef DemoDialogViewController_h
#define DemoDialogViewController_h

#import "surveySDK-Swift.h"


@import UIKit;

@interface DemoDialogViewController : UIViewController
@property(strong) UIButton *closebutton;

@property(strong) UIButton *button;
@property(strong) UIStackView *stackview;

@property(strong) NSString* surveyId;
@property(strong) NSString* channelId;
@property(strong) NSString* server;
@property(strong) NSDictionary* options;
@property(strong) NSDictionary* parameters;



+ (DemoDialogViewController*) setUpWithSurveyId:(NSString *)surveyId channelId:(NSString*)channelId server:(NSString*)server parameters:(NSDictionary*)parameters options:(NSDictionary*)options;
@end


#endif /* DemoDialogViewController_h */
