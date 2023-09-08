import os
import UIKit
import WebKit
import JavaScriptCore

/**
 Survey视图 UIKit版本
 */
public class HYUISurveyView: UIView, WKUIDelegate, WKNavigationDelegate {
    var server : String = "production"
    var surveyId : String?
    var channelId : String?
    var delay : Int = 1000
    var debug : Bool = false
    var force : Bool = false
    var isDialogMode : Bool = false
    var padding : Int = 0
    var bord : Bool = false
    var parameters : Dictionary<String, Any>?
    var options : Dictionary<String, Any>?
    var finished: Bool = false
    var version: String = ""
    var build: String = ""
    var assets: String = ""
    var onSubmit: Optional<() -> Void> = nil
    var onCancel: Optional<() -> Void> = nil
    var onSize: Optional<(_ height: Int) -> Void> = nil
    var onClose: Optional<() -> Void> = nil
    var onLoad: Optional<(_ config: Dictionary<String, Any>) -> Void> = nil
    var _height: Int?
    var _constraint: NSLayoutConstraint? = nil
    var appPaddingWidth: Int = 0;
    
    @IBOutlet var webView: WKWebView!
    
    
    @objc public func setOnSubmit(callback: @escaping () -> Void) {
        self.onSubmit = callback
    }
    
    @objc public func setOnCancel(callback: @escaping () -> Void) {
        self.onCancel = callback
    }
    
    @objc public func setOnClose(callback: @escaping () -> Void) {
        self.onClose = callback
    }
    
    @objc public func setOnSize(callback: @escaping (_ height: Int) -> Void) {
        self.onSize = callback
    }
    
    @objc public func setOnLoad(callback: @escaping (_ config: Dictionary<String, Any>) -> Void) {
        self.onLoad = callback
    }
    
    /**
        内部构造SurveyController
     */
    @objc public static func makeSurveyController(surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
        onSubmit: Optional<() -> Void> = nil,
        onCancel: Optional<() -> Void> = nil,
        onSize: Optional<(_ height: Int) -> Void> = nil,
        onClose: Optional<() -> Void> = nil,
        onLoad: Optional<(_ config: Dictionary<String, Any>) -> Void> = nil
    ) -> HYUISurveyView {
        let controller = HYUISurveyView()
        controller.surveyId = surveyId
        controller.channelId = channelId
        controller.parameters = parameters
        controller.options = options
        controller.onSubmit = onSubmit
        controller.onSize = onSize
        controller.onCancel = onCancel
        controller.onClose = onClose
        controller.onLoad = onLoad
        
        controller.assets = options.index(forKey: "assets") != nil ? options["assets"] as! String : "";
        controller.delay = options.index(forKey: "delay") != nil ? options["delay"] as! Int : 1000
        controller.padding = options.index(forKey: "padding") != nil ? options["padding"] as! Int : 0
        controller.debug = options.index(forKey: "debug") != nil ? options["debug"] as! Bool: false
        controller.force = options.index(forKey: "force") != nil ? options["force"] as! Bool: false
        controller.bord = options.index(forKey: "bord") != nil ? options["bord"] as! Bool: false
        controller.server = options.index(forKey: "server") != nil ? options["server"] as! String : "production"
        controller.isDialogMode = options.index(forKey: "isDialogMode") != nil ? options["isDialogMode"] as! Bool: false

        controller.setup()
        return controller
    }
    
    /**
        构建popupview async version
     */
    @objc public static func makeSurveyControllerAsync(surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
                                                       onReady: Optional<(_ view: HYUISurveyView) -> Void> = nil,
                                                       onError: Optional<(_ error: String) -> Void> = nil,
                                                       onSubmit: Optional<() -> Void> = nil,
                                                       onCancel: Optional<() -> Void> = nil,
                                                       onSize: Optional<(_ height: Int) -> Void> = nil,
                                                       onClose: Optional<() -> Void> = nil
                                                           ) -> Void {
        if (onReady == nil || onError == nil) {
            NSLog("onReady and onError is required in async call")
            return;
        }
        
        let server = options.index(forKey: "server") != nil ? options["server"] as! String : "https://www.xmplus.cn/api/survey"
        let accessCode = parameters.index(forKey: "accessCode") != nil ? parameters["accessCode"] as! String : ""

        HYSurveyService.donwloadConfig(server: server, surveyId: surveyId, channelId: channelId, accessCode: accessCode, onCallback: { config, error in
            if (config != nil && error == nil) {
                DispatchQueue.main.async {
                    let view : HYUISurveyView = makeSurveyController(surveyId: surveyId, channelId: channelId, parameters: parameters, options: options, onSubmit: onSubmit, onCancel: onCancel, onSize: onSize, onClose: onClose);
                    onReady!(view);
                }
            } else {
                onError!(error!);
            }
        });
    }
    
    /**
     加载资源文件
     */
    private func loadFile(res: String, ex: String) -> URL? {
        let myBundle = Bundle(for: Self.self)
        let path = myBundle.url(forResource: res, withExtension: ex, subdirectory: self.assets)
        return path
    }
    
    /**
     创建组件
     */
    @objc public func setup() {
                
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "surveyProxy")
        if debug {
            configuration.userContentController.add(self, name: "logger")
        }
        
        if (self.webView != nil) {
            NSLog("already setup skip!")
            return
        }
        
        
        self.webView = WKWebView(frame: self.frame, configuration: configuration)
        self.webView.navigationDelegate = self;
        self.webView.uiDelegate = self;
        webView.isOpaque = false;
        webView.backgroundColor = UIColor.clear;
        
        
//        self.backgroundColor = UIColor.black.withAlphaComponent(1);

        if let path = loadFile(res: "version", ex: "json")
        {
            if let data = NSData(contentsOf: path) {
                do {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [String : Any]
                        self.version = (dict!["version"] as! String)
                        self.build = (dict!["build"] as! String)
                        self.webView.customUserAgent =  "surveySDK/\(version) (iOS)"
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                    
                }
            }
        }
        var indexURL = loadFile(res: "index", ex: "html")
        if force {
            let timestamp = Int(NSDate().timeIntervalSince1970)
            indexURL = URL(string: "\(indexURL!.absoluteString)#/pages/bridge?_t=\(timestamp)")
            URLCache.shared.removeAllCachedResponses()
        } else {
            indexURL = URL(string: "\(indexURL!.absoluteString)#/pages/bridge?")
        }
//        NSLog("load: \(String(describing: indexURL?.absoluteURL))")
                
        self.webView.isUserInteractionEnabled = true
//        self.webView.scrollView.isScrollEnabled = true
        self.webView.frame.size.height = CGFloat(0)
        
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.webView)
        
        self._constraint = self.heightAnchor.constraint(equalToConstant: CGFloat(0))
        self._constraint?.isActive = true

        self.webView.loadFileURL(indexURL!,
                                 allowingReadAccessTo: indexURL!.deletingLastPathComponent())

    }
    
    /**
     获取版本号
     */
    @objc public func getVersion() -> String {
        return self.version;
    }
    
    /**
     获取版本构建号
     */
    @objc public func getBuild() -> String {
        return self.build;
    }
    
    /**
    显示
     */
    @objc public func show() {
        if finished {
            self.webView.reload()
        }
        self.webView.evaluateJavaScript("document.dispatchEvent(new CustomEvent('show'))")
    }
    
 
    
}

/**
 Webview扩展
 */
extension HYUISurveyView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logger" {
            NSLog("log: \(message.body)")
        } else if message.name == "surveyProxy"  {
            if debug {
                NSLog("proxy: \(message.body)")
            }
            let msg = message.body as? String
            let event = try! JSONSerialization.jsonObject(with: msg!.data(using: .utf8)!, options: []) as? [String: Any]
            let type = event?["type"]! as? String
            if type == "size" {
                if (self.superview != nil) {
                    let value = event?["value"]! as? [String: Any]
                    var height = Int(value?["height"]! as! Double)
                    let width = Int(value?["width"]! as! Double)

                    height = min(Int(UIScreen.main.bounds.height) - 100, height);
                    if (width == 0) {
                        return
                    }
                    self.frame.size.height = CGFloat(height)
                    
                    if (_constraint != nil) {
                        _constraint?.constant = CGFloat(height);
                        superview?.updateConstraintsIfNeeded();
                        superview?.layoutIfNeeded();
                        superview?.layoutSubviews();
                        superview?.sizeToFit();
                    }
                                    
                    if self.onSize != nil {
                        NSLog("onSize \(height)")
                        self.onSize!(height)
                    }
                } else {
                    NSLog("seems no superview")
                }
            } else if type == "close" {
                self.frame.size.height = CGFloat(0)
//                self.superview?.frame.size.height = CGFloat(0)
                self.webView.removeFromSuperview()
                self.removeFromSuperview()
                if self.onClose != nil {
                    self.onClose!()
                }
            } else if type == "submit" {
                self.finished = true
                if self.onSubmit != nil {
                    self.onSubmit!()
                }
            } else if type == "load" {
                //embedBackGround, embedHeightMode, embedVerticalAlign
                var config : [String: Any] = [:];
                if (event?["configure"] != nil) {
                    config = (event?["configure"]! as? [String: Any])!;
                }
                
                if (!isDialogMode){
                    let parentWidth = Int(layer.frame.width);
                    let parentHeight = Int(layer.frame.height);
                    let appBorderRadius = Util.parsePx(value: Util.optString(config: config, key: "appBorderRadius", fallback: "0px"), max: parentWidth);
                    appPaddingWidth = Util.parsePx(value: Util.optString(config: config, key: "appPaddingWidth", fallback: "0px"), max: parentHeight);

                    if (appBorderRadius > 0) {
                        webView.clipsToBounds = true;
                        webView.layer.cornerRadius = CGFloat(appBorderRadius);
                    }
                }
                let constraints = [
                    webView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(appPaddingWidth)),
                    webView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(-1 * appPaddingWidth)),
                    webView.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(0)),
                    webView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: CGFloat(0))
                ]
                NSLayoutConstraint.activate(constraints)
                                
                if self.onLoad != nil {
                    self.onLoad!(config);
                }
                
            } else if type == "cancel" {
                if self.onCancel != nil {
                    self.onCancel!()
                }
                self.frame.size.height = CGFloat(0)
//                self.superview?.frame.size.height = CGFloat(0)
//                self.webView.removeFromSuperview()
                self.removeFromSuperview()
                if self.onClose != nil {
                    self.onClose!()
                }
            } else if type == "init" {
                let data = ["server": self.server, "surveyId": self.surveyId!, "channelId": self.channelId!, "delay": self.delay, "parameters": self.parameters!] as [String: Any]
                let jsonData = try? JSONSerialization.data(withJSONObject: data)
                let jsonText = String.init(data: jsonData!, encoding: String.Encoding.utf8)
                self.webView.evaluateJavaScript("document.dispatchEvent(new CustomEvent('init', { detail:  \(jsonText!)}))")
            }
        } else {
            NSLog("unexpected message received \(message.body)")
        }
    }
}

