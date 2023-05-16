import UIKit
import WebKit
import JavaScriptCore

public class SurveyView: UIView, WKUIDelegate, WKNavigationDelegate {
    
    var surveyId : String!
    var channelId : String!
    var delay : Int = 3000
    var debug : Bool = false
    var parameters : Dictionary<String, Any>!
    var options : Dictionary<String, Any>!
    var finished: Bool!
    var version: String?
    var build: Int?
    var assets: String = ""

    @IBOutlet var webView: WKWebView!

    
    public static func makeSurveyController(surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>, assets: String = "") -> SurveyView {
        let controller = SurveyView()
        controller.surveyId = surveyId
        controller.channelId = channelId
        controller.finished = false
        controller.assets = assets
        
        controller.delay = options.index(forKey: "delay") != nil ? options["delay"] as! Int : 3000
        controller.debug = options.index(forKey: "debug") != nil ? options["debug"] as! Bool: false
        controller.parameters = parameters
        controller.setup()
        return controller
    }
    
    private func loadFile(res: String, ex: String) -> URL? {
        let myBundle = Bundle(for: Self.self)
        let path = myBundle.url(forResource: res, withExtension: ex, subdirectory: self.assets)
        return path
    }
    
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
        
        if debug {
            print("setup controller")
        }
                
        self.webView = WKWebView(frame: self.frame, configuration: configuration)
        self.webView.navigationDelegate = self;
        self.webView.uiDelegate = self;
        
        let myBundle = Bundle(for: Self.self)
        print(myBundle.bundlePath)
        
//        myb
        if let path = loadFile(res: "version", ex: "json")
        {
            do {
                if let data = NSData(contentsOf: path) {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:AnyObject]
                        self.version = (dictionary?["version"] as? String)
                        self.build = dictionary?["build"] as? Int
                        self.webView.customUserAgent =  "surveySDK/\(version!) (iOS)"
                    }
                }
              } catch {
                  print("unexpected error here!")
              }
        }
        let indexURL = loadFile(res: "index", ex: "html")
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let url = URL(string: "\(indexURL!.absoluteString)?_t=\(timestamp)")

        URLCache.shared.removeAllCachedResponses()
                
        self.webView.isUserInteractionEnabled = true
        self.webView.scrollView.isScrollEnabled = true

        self.webView.layer.frame.size.height = CGFloat(0)
        self.webView.layer.frame.size.width = self.frame.width
        
//        if (debug) {
//            self.webView.layer.borderWidth = 2
//            self.webView.layer.borderColor = UIColor.yellow.cgColor
//            self.webView.layer.backgroundColor = UIColor.blue.cgColor
//
//            self.layer.borderWidth = 2
//            self.layer.borderColor = UIColor.red.cgColor
//        }
        
        
        self.addSubview(self.webView)
        self.webView.loadFileURL(url!,
                                 allowingReadAccessTo: url!.deletingLastPathComponent())

    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.webView.frame = bounds
    }
    
    public func getVersion() -> String {
        return self.version!;
    }
    
    public func getBuild() -> Int {
        return self.build!;
    }
    
    public func show() {
        if finished {
            self.webView.reload()
        }
        self.webView.evaluateJavaScript("document.dispatchEvent(new CustomEvent('show'))")
    }
    
}

extension SurveyView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logger" {
            print("log: \(message.body)")
        } else if message.name == "surveyProxy"  {
//            print("message receive")
            print("proxy: \(message.body)")
            let msg = message.body as? String
            let event = try! JSONSerialization.jsonObject(with: msg!.data(using: .utf8)!, options: []) as? [String: Any]
            let type = event?["type"]! as? String
            if type == "size" {
                let value = event?["value"]! as? [String: Any]
                let height = value?["height"]! as? Int
//                print("size heigt: \(height!)")
                self.layer.frame.size.height = CGFloat(height!)
                print("size heigt: \(self.layer.frame.size.height)")
            } else if type == "close" {
                self.layer.frame.size.height = CGFloat(0)
            } else if type == "submit" {
                self.finished = true
            } else if type == "init" {
                let data = ["surveyId": self.surveyId, "channelId": self.channelId, "delay": self.delay, "parameters": self.parameters] as [String : Any] as [String : Any]
                let jsonData = try? JSONSerialization.data(withJSONObject: data)
                let jsonText = String.init(data: jsonData!, encoding: String.Encoding.utf8)
//                print("dispatch command \(jsonText!)")
                self.webView.evaluateJavaScript("document.dispatchEvent(new CustomEvent('init', { detail:  \(jsonText!)}))")
            }
        } else {
            print("unexpected message received \(message.body)")
        }
    }
}

