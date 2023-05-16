import UIKit
import WebKit
import JavaScriptCore

public class SurveyViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var surveyId : String!
    var channelId : String!
    var delay : Int!
    var debug : Bool!
    var parameters : Dictionary<String, Any>!
    var options : Dictionary<String, Any>!
    var finished: Bool!
    var version: String?
    var build: Int?

    @IBOutlet var webView: WKWebView!
    
    public static func makeSurveyController(surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>) -> SurveyViewController {
        let controller = SurveyViewController()
        controller.surveyId = surveyId
        controller.channelId = channelId
        controller.finished = false
        
        controller.delay = options.index(forKey: "delay") != nil ? options["delay"] as? Int : 3000
        controller.debug = options.index(forKey: "debug") != nil ? options["debug"] as? Bool: false
        controller.parameters = parameters
        return controller
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
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
                
        self.webView = WKWebView(frame: view.frame, configuration: configuration)
        self.webView.navigationDelegate = self;
        self.webView.uiDelegate = self;
        
        let myBundle = Bundle(for: Self.self)
        if let path = myBundle.url(forResource: "version", withExtension: "json", subdirectory: "assets")
        {
            do {
                if let data = NSData(contentsOf: path) {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:AnyObject]
                        self.version = (dictionary?["version"] as? String)
                        self.build = dictionary?["build"] as? Int
                        
//                        String.format("surveySDK/%s (Android) %s", version, build);
                        self.webView.customUserAgent =  "surveySDK/\(version!) (iOS)"
                    } catch {
                    }
                }
              } catch {
                   // handle error
              }
        }
        let indexURL = myBundle.url(forResource: "index", withExtension: "html", subdirectory: "assets")
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let url = URL(string: "\(indexURL!.absoluteString)?_t=\(timestamp)")

        URLCache.shared.removeAllCachedResponses()
                
        self.webView.isUserInteractionEnabled = true
        self.webView.scrollView.isScrollEnabled = true

        self.webView.frame.size.height = CGFloat(0)
        self.webView.frame.size.width = self.view.frame.width
        
//        if (debug) {
//            self.webView.layer.borderWidth = 2
//            self.webView.layer.borderColor = UIColor.yellow.cgColor
//
//            self.view.layer.borderWidth = 2
//            self.view.layer.borderColor = UIColor.red.cgColor
//        }
        
        self.view.addSubview(self.webView)
        
        
        self.webView.loadFileURL(url!,
                                 allowingReadAccessTo: url!.deletingLastPathComponent())

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

extension SurveyViewController: WKScriptMessageHandler {
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
                self.webView?.frame.size.height = CGFloat(height!)
                self.view.layer.frame.size.height = CGFloat(height!)
                print("size heigt: \(self.view.layer.frame.size.height)")
            } else if type == "close" {
                self.view.layer.frame.size.height = CGFloat(0)
                self.webView?.frame.size.height = CGFloat(0)
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

