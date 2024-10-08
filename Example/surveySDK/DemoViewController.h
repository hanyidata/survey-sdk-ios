//
//  ViewController.h
//  surveySDK
//
//  Created by Winston on 2023/6/9.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#ifndef DemoViewController_h
#define DemoViewController_h

#import "surveySDK-Swift.h"


@import UIKit;

@interface DemoViewController : UIViewController
@property(strong) HYUISurveyView *survey;
@property(strong) UITableView *table;
@property(strong) UIButton *button1;
@property(strong) UIButton *button2;
@property(strong) UIButton *button3;

@property(strong) UILabel *label1;
@property(strong) UILabel *label2;

@property(strong) UITextField *text1;
@property(strong) UIStackView *stackview;

@end

#endif /* DemoViewController_h */
