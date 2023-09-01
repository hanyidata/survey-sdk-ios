//
//  HyPopupViewController.swift
//  surveySDK
//
//  Created by Winston on 2023/6/24.
//

import Foundation
import UIKit

///**
//  问卷弹窗
// */
public class HYPopupDialog: UIViewController {
    var survey : Optional<HYUISurveyView>;
    var popupView : UIScrollView;
    var config: Optional<Dictionary<String, Any>>;
    var _constraint: NSLayoutConstraint? = nil;
    var options : Dictionary<String, Any>?;
    var animation: Bool = true;
    var animationDuration: Double = 0.5;

    public override func viewDidLoad() {
        super.viewDidLoad()
//        setupViews()
    }
    
    /**
        构建popupview
     */
    @objc public static func makeDialog(context: UIViewController, surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
                                         onSubmit: Optional<() -> Void> = nil,
                                         onCancel: Optional<() -> Void> = nil,
                                         onError: Optional<(_: String) -> Void> = nil
                                         ) -> Void {
        
        let server = options.index(forKey: "server") != nil ? options["server"] as! String : "https://www.xmplus.cn/api/survey"
        let accessCode = parameters.index(forKey: "accessCode") != nil ? parameters["accessCode"] as! String : ""

        var mOptions : Dictionary<String, Any> = options;
        mOptions.updateValue(true, forKey: "isDialogMode")
        NSLog("surveySDK->makeDialog will download config for survey %@", surveyId)
        HYSurveyService.donwloadConfig(server: server, surveyId: surveyId, channelId: channelId, accessCode: accessCode, onCallback: { config, error in
            if (config != nil && error == nil) {
                DispatchQueue.main.async {
                    let dialog: HYPopupDialog = HYPopupDialog(surveyId: surveyId, channelId: channelId, parameters: parameters, options: mOptions, config: config!, onSubmit: onSubmit, onCancel: onCancel);
                    NSLog("surveySDK->makeDialog will show up")
                    
                    let style  = options.index(forKey: "style") != nil ? options["style"] as? String : nil
                    if (style == "overFullScreen") {
                        dialog.modalPresentationStyle = .overFullScreen
                    } else if (style == "fullScreen") {
                        dialog.modalPresentationStyle = .fullScreen
                    }
                    context.view.window?.rootViewController?.present(dialog, animated: true)
                }
            } else if (onError != nil) {
                NSLog("surveySDK->makeDialog failed to load config %@", error!)
                onError!(error!);
            }
            
        });
    }
    
    /**
     初始化view
     */
    private init(surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
               config: Dictionary<String, Any>,
            onSubmit: Optional<() -> Void> = nil,
            onCancel: Optional<() -> Void> = nil) {
        let window = UIApplication.shared.windows.first;
        self.options = options;
        self.config = config;

        
        popupView = UIScrollView();
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.isScrollEnabled = true;
        
        super.init(nibName: nil, bundle: nil);
        
        let parentWidth = Int(self.view.frame.height);
        self.animation = options.index(forKey: "animation") != nil ? options["animation"] as! Bool : false
        self.animationDuration = options.index(forKey: "animationDuration") != nil ? options["animationDuration"] as! Double : 0.5
        
        let embedHeightMode: String = Util.optString(config: config, key: "embedHeightMode", fallback: "AUTO")
        let embedHeight: Int = Util.parsePx(value: config["embedHeight"] as! String, max: Int(view.frame.height));
        let appBorderRadius = Util.parsePx(value: Util.optString(config: config, key: "appBorderRadius", fallback: "0px"), max: parentWidth);
        let appPaddingWidth: Int = Util.parsePx(value: Util.optString(config: config, key: "appPaddingWidth", fallback: "0px")
, max: Int(view.frame.width));
        let embedVerticalAlign = Util.optString(config: config, key: "embedVerticalAlign", fallback: "CENTER");
        let embedBackGround = Util.optBool(config: config, key: "embedBackGround", fallback: true);
        
        if (embedBackGround) {
            self.view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor;
        }
        

        if (appBorderRadius > 0) {
            if #available(iOS 11.0, *) {
                popupView.clipsToBounds = true
                popupView.layer.cornerRadius = CGFloat(appBorderRadius);
                switch (embedVerticalAlign) {
                    case "CENTER":
                        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                        break
                    case "TOP":
                        popupView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                        break;
                    case "BOTTOM":
                        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        break
                    default:
                        break
                }
            }
        }
        
        survey = HYUISurveyView.makeSurveyController(surveyId: surveyId, channelId: channelId, parameters: parameters, options: options,
                                                     onSubmit:  onSubmit, onCancel: onCancel, onSize: self.onSize, onClose: self.onClose);
        popupView.addSubview(survey!);
        survey!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            survey!.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            survey!.topAnchor.constraint(equalTo: popupView.topAnchor),
            survey!.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: CGFloat(1))
        ])

        modalPresentationStyle = .overCurrentContext;
        modalTransitionStyle = .crossDissolve;
        
        
        view.addSubview(popupView)

        
        
        if (embedVerticalAlign == "CENTER") {
            NSLayoutConstraint.activate([
                popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                popupView.widthAnchor.constraint(equalToConstant: CGFloat(view.frame.width - 2 * CGFloat(appPaddingWidth))),
            ])
        } else if (embedVerticalAlign == "TOP") {
            //window.safeAreaInsets.top
            var top : CGFloat = CGFloat(0);
            if #available(iOS 11.0, *) {
                top = (window?.safeAreaInsets.top)!
            } else {
            };
            
            NSLayoutConstraint.activate([
                popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                popupView.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
                popupView.widthAnchor.constraint(equalToConstant: CGFloat(view.frame.width - 2 * CGFloat(appPaddingWidth))),
            ])
        } else {
            // bottom or default
            NSLayoutConstraint.activate([
                popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                popupView.widthAnchor.constraint(equalToConstant: CGFloat(view.frame.width - 2 * CGFloat(appPaddingWidth))),
            ])
        }

        if (embedHeightMode == "FIX") {
            self._constraint = popupView.heightAnchor.constraint(equalToConstant: CGFloat(embedHeight));
        } else {
            // AUTO or default
            self._constraint = popupView.heightAnchor.constraint(equalToConstant: CGFloat(1));
        }
        self._constraint?.isActive = true;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
        响应onSize
     */
    func onSize(height: Int) {
        self.popupView.contentSize = CGSizeMake(self.popupView.contentSize.width, CGFloat(height));
        let embedHeightMode = Util.optString(config: config!, key: "embedHeightMode", fallback: "AUTO");

        if (embedHeightMode != "FIX" && _constraint != nil) {
            _constraint?.constant = CGFloat(height);
        }
        
        view.layoutIfNeeded()
        
        if (animation) {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /**
        响应Close
     */
    func onClose() {
        self.dismissView();
    }
    
    /**
        popup消失
     */
    @objc func dismissView(){
        self.dismiss(animated: animation, completion: nil)
    }

}


