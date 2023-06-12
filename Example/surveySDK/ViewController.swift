//
//  ViewController.swift
//  surveySDK
//
//  Created by boyd4y on 05/05/2023.
//  Copyright (c) 2023 boyd4y. All rights reserved.
//

import UIKit
import surveySDK

class ViewController: UIViewController {
    var _survey:HYUISurveyView? = nil
    
    let stackView = UIStackView()
    let a = UIView()
    let b = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func clickShow(_ sender: Any) {

        print("click show me")

        if (_survey == nil) {
            self._survey = HYUISurveyView.makeSurveyController(surveyId: "4332348965224448", channelId: "4333597795516416", parameters: ["externalUserId": "winston"], options: ["server": "test", "delay": 1000], assets: "Assets")
            
            let newFrame = CGRectMake( 0, 300, self.view.frame.width, 0)
            self._survey?.frame = newFrame
            view.addSubview(self._survey!)
        } else {
            print("show again")
            if (_survey?.superview == nil) {
                let newFrame = CGRectMake( 0, 300, self.view.frame.width, 0)
                self._survey?.frame = newFrame
                view.addSubview(self._survey!)
            }
            _survey!.show()
        }
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

