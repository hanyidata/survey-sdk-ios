import UIKit
import WebKit
import JavaScriptCore

/**
 Survey视图 UIKit版本
 */
public class HYUISurveyView: UIView, WKUIDelegate, WKNavigationDelegate {
    
    var surveyId : String?
    var channelId : String?
    var delay : Int = 3000
    var debug : Bool = false
    var force : Bool = false
    var padding : Int = 0
    var bord : Bool = false
    var autoheight: Bool = false
    var parameters : Dictionary<String, Any>?
    var options : Dictionary<String, Any>?
    var finished: Bool = false
    var version: String = ""
    var build: Int = 0
    var assets: String = ""
    var callback: Optional<(_ event: String, _ params: Any?) -> Void> = nil
    var _height: Int?

    @IBOutlet var webView: WKWebView!
    
    public static func makeSurveyController(surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>, callback: Optional<(_ event: String, _ params: Any?) -> Void> = nil, assets: String = "") -> HYUISurveyView {
        let controller = HYUISurveyView()
        controller.surveyId = surveyId
        controller.channelId = channelId
        controller.parameters = parameters
        controller.options = options
        controller.assets = assets
        controller.callback = callback

        controller.delay = options.index(forKey: "delay") != nil ? options["delay"] as! Int : 3000
        controller.padding = options.index(forKey: "padding") != nil ? options["padding"] as! Int : 0
        controller.debug = options.index(forKey: "debug") != nil ? options["debug"] as! Bool: false
        controller.force = options.index(forKey: "force") != nil ? options["force"] as! Bool: false
        controller.bord = options.index(forKey: "bord") != nil ? options["bord"] as! Bool: false
        controller.autoheight = options.index(forKey: "autoheight") != nil ? options["autoheight"] as! Bool: false

        controller.setup()
        return controller
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
    public func setup() {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "surveyProxy")
        if debug {
            configuration.userContentController.add(self, name: "logger")
        }
        
        if (self.webView != nil) {
            print("already setup skip!")
            return
        }
        
        self.webView = WKWebView(frame: self.frame, configuration: configuration)
        self.webView.navigationDelegate = self;
        self.webView.uiDelegate = self;
                
        if let path = loadFile(res: "version", ex: "json")
        {
            if let data = NSData(contentsOf: path) {
                do {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [String : Any]
                        self.version = (dict!["version"] as! String)
                        self.build = dict!["build"] as! Int
                        self.webView.customUserAgent =  "surveySDK/\(version) (iOS)"
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            }
        }
        var indexURL = loadFile(res: "index", ex: "html")
        if force {
            let timestamp = Int(NSDate().timeIntervalSince1970)
            indexURL = URL(string: "\(indexURL!.absoluteString)?_t=\(timestamp)")
            URLCache.shared.removeAllCachedResponses()
        }
                
        self.webView.isUserInteractionEnabled = true
        self.webView.scrollView.isScrollEnabled = true

        self.webView.frame.size.height = CGFloat(0)
//        self.webView.frame.size.width = self.frame.width
        
        if (bord) {
            self.webView.layer.borderWidth = 2
            self.webView.layer.borderColor = UIColor.yellow.cgColor
            self.webView.layer.backgroundColor = UIColor.blue.cgColor
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.red.cgColor
        }
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.webView)
        let constraints = [
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(padding)),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(-1 * padding)),
            webView.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(padding)),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: CGFloat(-1 * padding))
        ]
        NSLayoutConstraint.activate(constraints)

        self.webView.loadFileURL(indexURL!,
                                 allowingReadAccessTo: indexURL!.deletingLastPathComponent())

    }
    
    /**
     获取版本号
     */
    public func getVersion() -> String {
        return self.version;
    }
    
    /**
     获取版本构建号
     */
    public func getBuild() -> Int {
        return self.build;
    }
    
    /**
    显示
     */
    public func show() {
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
            print("log: \(message.body)")
        } else if message.name == "surveyProxy"  {
            if debug {
                print("proxy: \(message.body)")
            }
            let msg = message.body as? String
            let event = try! JSONSerialization.jsonObject(with: msg!.data(using: .utf8)!, options: []) as? [String: Any]
            let type = event?["type"]! as? String
            if type == "size" {
                if (self.superview != nil) {
                    let value = event?["value"]! as? [String: Any]
                    let height = value?["height"]! as! Int
                    if autoheight && height != 0 && _height == nil {
                        self.superview?.frame.size.height = CGFloat(height)
                        _height = height
                        if self.callback != nil {
                            self.callback!("size", height)
                        }
                    }
                    let maxHeight = Int((self.superview?.frame.size.height)!)
                    if height < maxHeight {
                        self.frame.size.height = CGFloat(height)
                    }
                    if debug {
                        print("size heigt: \(self.layer.frame.size.height)")
                    }
                }
            } else if type == "close" {
                self.layer.frame.size.height = CGFloat(0)
                self.superview?.frame.size.height = CGFloat(0)
                self.webView.removeFromSuperview()
                self.removeFromSuperview()
                if self.callback != nil {
                    self.callback!("close", nil)
                }
            } else if type == "submit" {
                self.finished = true
            } else if type == "init" {
                let data = ["surveyId": self.surveyId!, "channelId": self.channelId!, "delay": self.delay, "parameters": self.parameters!] as [String: Any]
                let jsonData = try? JSONSerialization.data(withJSONObject: data)
                let jsonText = String.init(data: jsonData!, encoding: String.Encoding.utf8)
                self.webView.evaluateJavaScript("document.dispatchEvent(new CustomEvent('init', { detail:  \(jsonText!)}))")
            }
        } else {
            print("unexpected message received \(message.body)")
        }
    }
}

