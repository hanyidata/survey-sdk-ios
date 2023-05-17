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
    @IBOutlet weak var sidInput: UITextField!
    @IBOutlet weak var channelInput: UITextField!
    @IBOutlet weak var euidInput: UITextField!
    @IBOutlet weak var versionText: UILabel!
    
    @IBAction func clickShow(_ sender: Any) {
        let sid = sidInput.text!
        let channel = channelInput.text!
        let euid = euidInput.text!

        print("click show me \(sid) \(channel)")

        if (_survey == nil) {
            self._survey = HYUISurveyView.makeSurveyController(surveyId: sid, channelId: channel, parameters: ["externalUserId": euid], options: ["delay": 1000, "debug": true], assets: "Assets")
            
            let newFrame = CGRectMake( 0, 300, self.view.frame.width, 0)
            self._survey?.frame = newFrame
            view.addSubview(self._survey!)
            let version: String = (_survey?.getVersion())!
            let build: Int = (_survey?.getBuild())!
            versionText.text = "v:\(version) (\(build))"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

