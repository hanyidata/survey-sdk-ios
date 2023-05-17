//
//  Test.swift
//  surveySDK-example
//
//  Created by Winston on 2023/5/17.
//  Copyright © 2023 CocoaPods. All rights reserved.
//
import SwiftUI
import UIKit

public class UIButton2: UIButton {
    deinit {
        print("deinit")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        print("willMove")
        let seconds = 3.0

        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
//            print("removeFromSuperview")
//            let view = self.superview
//            let pview = self.superview?.superview
//            self.frame.size.height = 0
//            self.superview?.frame.size.height = 0
//
//            self.superview?.superview?.setNeedsLayout()
//            self.superview?.superview?.setNeedsDisplay()
//            self.superview?.superview?.setNeedsUpdateConstraints()
//            self.removeFromSuperview()
//            pview?.layoutIfNeeded()
//            self.removeFromSuperview()
//            view?.setNeedsLayout()
//            view?.layoutIfNeeded()
//            view?.layoutSubviews()
//            self.superview?.layoutSubviews()
//            self.superview?.layoutIfNeeded()
//            self.superview?.superview?.layoutSubviews()
//            self.superview?.superview?.layoutIfNeeded()
//

//            self.performSelector(onMainThread: #selector(self.superview?.removeFromSuperview), with: nil, waitUntilDone: true)
//            [subView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];


        }

        if newSuperview == nil {
            print("removed from parent")
        }
    }
    
}

public struct PillButton: UIViewRepresentable {
    let title: String
    let action: () -> ()
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

//    var ntPillButton = UIButton()//NTPillButton(type: .filled, title: "Start Test")

    public func makeCoordinator() -> Coordinator { Coordinator(self) }

    public class Coordinator: NSObject {
        var parent: PillButton

        init(_ pillButton: PillButton) {
            self.parent = pillButton
            super.init()
        }

        @objc func doAction(_ sender: UIButton2) {
            let height = sender.superview?.frame.size.height
            sender.superview?.frame.size.height = 0
            sender.superview?.setNeedsLayout()
            sender.superview?.layoutIfNeeded()
            sender.superview?.layoutSubviews()

            self.parent.action()
        }
    }

    public func makeUIView(context: Context) -> UIButton {
        let button = UIButton2(type: .system)
        button.setTitle(self.title, for: .normal)
        button.addTarget(context.coordinator, action: #selector(Coordinator.doAction(_ :)), for: .touchDown)
        button.contentMode = .scaleAspectFill
        return button
    }

    public func updateUIView(_ uiView: UIButton, context: Context) {}
}

