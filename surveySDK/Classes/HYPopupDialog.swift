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
    var config: Optional<Dictionary<String, Any>>;
    var _constraint: NSLayoutConstraint? = nil;
    var options : Dictionary<String, Any>?;
    var animation: Bool = true;
    var animationDuration: Double = 0.5;
    var onLoadCallback: Optional<(_ config: Dictionary<String, Any>) -> Void> = nil;
    
    static var lastInstance: HYPopupDialog? = nil;
    static var observation: NSKeyValueObservation?
    static var parentViewController: UIViewController?
    static var _context: UIViewController? = nil;
    static var _close: Bool = false;

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let clickDismiss = self.options?.index(forKey: "clickDismiss") != nil ? self.options?["clickDismiss"] as! Bool : false
        if (clickDismiss) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleClick(_:)))
            self.view.addGestureRecognizer(tapGesture)
        }
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardFrame.cgRectValue.height;
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset your view's Y position back to 0
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    
    static func setupObservation(for parent: UIViewController) {
        HYPopupDialog.parentViewController = parent
        // 开始观察
        HYPopupDialog.observation = parent.observe(\.view.window, options: [.new]) { _, change in
            print("any change")
            if change.newValue == nil {
                print("Parent view controller is no longer in the window")
            }
        }
    }
    
    @objc func handleClick(_ sender: UITapGestureRecognizer) {
        NSLog("dismiss survey")
        self.dismissView()
    }
    
    static func checkContextStatus() -> Bool{
        if (HYPopupDialog._context != nil && HYPopupDialog._context!.isViewLoaded && HYPopupDialog._context!.view.window != nil) {
            return true;
        }
        NSLog("context already dismissed, will skip the popup")
        return false;
    }
    
    @objc public static func makeDialog(context: UIViewController, surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
                                         onSubmit: Optional<() -> Void> = nil,
                                         onCancel: Optional<() -> Void> = nil,
                                         onError: Optional<(_: String) -> Void> = nil
    ) -> Void {
        makeDialog(context: context, surveyId: surveyId, channelId: channelId, parameters: parameters, options: options, onSubmit: onSubmit, onCancel: onCancel, onError: onError, onLoad: nil)
    }
    
    /**
            主动关闭弹窗
     */
    @objc public static func close() -> Void {
        NSLog("close survey dialog")
        HYPopupDialog._close = true;
        if (HYPopupDialog.lastInstance != nil) {
            HYPopupDialog.lastInstance?.dismissView()
        }
    }
    
    /**
        构建popupview
     */
    @objc public static func makeDialog(context: UIViewController, surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
                                         onSubmit: Optional<() -> Void> = nil,
                                         onCancel: Optional<() -> Void> = nil,
                                         onError: Optional<(_: String) -> Void> = nil,
                                         onLoad: Optional<(_ config: Dictionary<String, Any>) -> Void> = nil
                                         ) -> Void {
        
        HYPopupDialog._context = context;
        HYPopupDialog._close = false;
        let server = options.index(forKey: "server") != nil ? options["server"] as! String : "https://www.xmplus.cn/api/survey"
        let accessCode = parameters.index(forKey: "accessCode") != nil ? parameters["accessCode"] as! String : ""
        let externalUserId = parameters.index(forKey: "externalUserId") != nil ? parameters["externalUserId"] as! String : ""
        let showDelay = options.index(forKey: "showDelay") != nil ? options["showDelay"] as! Int : 0

        var mOptions : Dictionary<String, Any> = options;
        mOptions.updateValue(true, forKey: "isDialogMode")
        mOptions.updateValue("dialog", forKey: "showType")
        NSLog("surveySDK->makeDialog will download config for survey %@", surveyId)
                
        HYSurveyService.donwloadConfig(server: server, surveyId: surveyId, channelId: channelId, accessCode: accessCode, externalUserId: externalUserId, onCallback: { config, error in
            if (config != nil && error == nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(showDelay)) {
                    let canPop = HYPopupDialog.checkContextStatus()
                    if (!canPop || HYPopupDialog._close) {
                        NSLog("skip the popup");
                        return;
                    }
                    HYPopupDialog.lastInstance = HYPopupDialog(surveyId: surveyId, channelId: channelId, parameters: parameters, options: mOptions, config: config!, onSubmit: onSubmit, onCancel: onCancel, onLoad: onLoad);
                    NSLog("surveySDK->makeDialog will show up")
                    HYPopupDialog.lastInstance!.modalPresentationStyle = .overFullScreen
                    context.present(HYPopupDialog.lastInstance!, animated: true) {
                        NSLog("Modal present!")
                    }
                }
            } else if (onError != nil) {
                NSLog("surveySDK->makeDialog failed to load config %@", error!)
                onError!(error!);
            }
            
        });
    }
    
    /**
        构建popupview
     */
    @objc public static func makeDialogBySendId(context: UIViewController, sendId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
                                         onSubmit: Optional<() -> Void> = nil,
                                         onCancel: Optional<() -> Void> = nil,
                                         onError: Optional<(_: String) -> Void> = nil
                                         ) -> Void {
        
        HYPopupDialog._context = context;
        HYPopupDialog._close = false;
        let server = options.index(forKey: "server") != nil ? options["server"] as! String : "https://www.xmplus.cn/api/survey"
        let accessCode = parameters.index(forKey: "accessCode") != nil ? parameters["accessCode"] as! String : ""
        let externalUserId = parameters.index(forKey: "externalUserId") != nil ? parameters["externalUserId"] as! String : ""
        let showDelay = options.index(forKey: "showDelay") != nil ? options["showDelay"] as! Int : 0

        var mOptions : Dictionary<String, Any> = options;
        mOptions.updateValue(true, forKey: "isDialogMode")
        mOptions.updateValue("dialog", forKey: "showType")
        NSLog("surveySDK->makeDialog will download config for survey sendId %@", sendId)
                
        HYSurveyService.downloadBySendId(server: server, sendId: sendId, accessCode: accessCode, externalUserId: externalUserId, onCallback: { sid, cid, config, error in
            if (config != nil && error == nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(showDelay)) {
                    let canPop = HYPopupDialog.checkContextStatus()
                    if (!canPop || HYPopupDialog._close) {
                        NSLog("skip the popup");
                        return;
                    }
                    HYPopupDialog.lastInstance = HYPopupDialog(surveyId: sid!, channelId: cid!, parameters: parameters, options: mOptions, config: config!, onSubmit: onSubmit, onCancel: onCancel, onLoad: nil);
                    NSLog("surveySDK->makeDialog will show up")
                    HYPopupDialog.lastInstance!.modalPresentationStyle = .overFullScreen
                    context.present(HYPopupDialog.lastInstance!, animated: true) {
                        NSLog("Modal present!")
                    }
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
            onCancel: Optional<() -> Void> = nil,
            onLoad: Optional<(_ config: Dictionary<String, Any>) -> Void> = nil
    ) {
        self.options = options;
        self.config = config;
        self.onLoadCallback = onLoad;
        
        survey = HYUISurveyView.makeSurveyController(surveyId: surveyId, channelId: channelId, parameters: parameters, options: options,
                                                     onSubmit:  onSubmit, onCancel: onCancel)
                
        super.init(nibName: nil, bundle: nil);
        
        survey?.setOnSize(callback: self.onSize);
        survey?.setOnClose(callback: self.onClose);
        survey?.setOnLoad(callback: self.onLoad);

        let parentWidth = Int(self.view.frame.height);
        self.animation = options.index(forKey: "animation") != nil ? options["animation"] as! Bool : false
        self.animationDuration = options.index(forKey: "animationDuration") != nil ? options["animationDuration"] as! Double : 0.5
        
        let embedHeightMode: String = Util.optString(config: config, key: "embedHeightMode", fallback: "AUTO")
        let embedHeight: Int = Util.parsePx(value: config["embedHeight"] as! String, max: Int(view.frame.height));
        let appBorderRadius = Util.parsePx(value: Util.optString(config: config, key: "appBorderRadius", fallback: "0px"), max: parentWidth);
        let appPaddingWidth: Int = Util.parsePx(value: Util.optString(config: config, key: "appPaddingWidth", fallback: "0px")
, max: Int(view.frame.width));
        let embedVerticalAlign = Util.optString(config: config, key: "embedVerticalAlign", fallback: "CENTER");

        if (appBorderRadius > 0) {
            if #available(iOS 11.0, *) {
                survey!.clipsToBounds = true
                survey!.layer.cornerRadius = CGFloat(appBorderRadius);
                switch (embedVerticalAlign) {
                    case "CENTER":
                    survey!.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                        break
                    case "TOP":
                    survey!.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                        break;
                    case "BOTTOM":
                    survey!.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        break
                    default:
                        break
                }
            }
        }
        
        
//        popupView.addSubview(survey!);
        survey!.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            survey!.centerXAnchor.constraint(equalTo: survey!.centerXAnchor),
//            survey!.topAnchor.constraint(equalTo: survey!.topAnchor),
//            survey!.widthAnchor.constraint(equalTo: survey!.widthAnchor, multiplier: CGFloat(1))
//        ])

        modalTransitionStyle = .crossDissolve;
        
        view.addSubview(survey!)
        
        view.bringSubview(toFront: survey!)
        
        if (embedVerticalAlign == "CENTER") {
            NSLayoutConstraint.activate([
                survey!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                survey!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                survey!.widthAnchor.constraint(equalToConstant: CGFloat(view.frame.width - 2 * CGFloat(appPaddingWidth))),
            ])
        } else if (embedVerticalAlign == "TOP") {
            NSLayoutConstraint.activate([
                survey!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                survey!.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                survey!.widthAnchor.constraint(equalToConstant: CGFloat(view.frame.width - 2 * CGFloat(appPaddingWidth))),
            ])
        } else {
            // bottom or default
            NSLayoutConstraint.activate([
                survey!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                survey!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                survey!.widthAnchor.constraint(equalToConstant: CGFloat(view.frame.width - 2 * CGFloat(appPaddingWidth))),
            ])
        }

        if (self._constraint != nil) {
            self._constraint?.isActive = false
        }
        if (embedHeightMode == "FIX") {
            self._constraint = survey!.heightAnchor.constraint(equalToConstant: CGFloat(embedHeight));
        } else {
            // AUTO or default
            let initHeight = options.index(forKey: "height") != nil ? options["height"] as! Int : 1
            self._constraint = survey!.heightAnchor.constraint(equalToConstant: CGFloat(initHeight));
        }
        self._constraint?.priority = UILayoutPriority(1000)
        self._constraint?.isActive = true;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
        响应onSize
     */
    func onSize(height: Int) {
//        self.popupView.contentSize = CGSizeMake(self.popupView.contentSize.width, CGFloat(height));
        let embedHeightMode = Util.optString(config: config!, key: "embedHeightMode", fallback: "AUTO");

        if (embedHeightMode != "FIX" && _constraint != nil) {
            let embedHeight: Int = Util.parsePx(value: config!["embedHeight"] as! String, max: Int(view.frame.height));
            _constraint?.constant = CGFloat(min(embedHeight, height));
        }
        
        view.layoutIfNeeded()
        
        if (animation) {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /**
        响应onError
     */
    func onError(config: Dictionary<String, Any>) {
        self.dismissView();
    }
    
    /**
        响应Load
     */
    func onLoad(config: Dictionary<String, Any>) {
        NSLog("popupDialog->onLoad")
        let embedBackGround = Util.optBool(config: config, key: "embedBackGround", fallback: true);
        if (embedBackGround) {
            self.view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor;
        }
        if self.onLoadCallback != nil {
            self.onLoadCallback!(config);
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
        NSLog("dismiss popup")
        self.dismiss(animated: animation, completion: nil)
        HYPopupDialog.lastInstance = nil;
    }
    
//    public override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let window = UIApplication.shared.windows.first
//        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
//        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -bottomPadding, right: 0)
//    }

}


