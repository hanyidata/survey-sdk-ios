//import UIKit
//import WebKit
//
//public class HYTestDialog: UIViewController {
//
//    var dialogView: UIView!
//    var bottomConstraint: NSLayoutConstraint?
//    var webView: WKWebView!
//
//    @objc public static func makeDialog(context: UIViewController, surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
//                                        onSubmit: Optional<() -> Void> = nil,
//                                        onCancel: Optional<() -> Void> = nil,
//                                        onError: Optional<(_: String) -> Void> = nil
//    ) -> Void {
//        let popupDialogViewController = HYTestDialog()
//        popupDialogViewController.modalPresentationStyle = .overFullScreen
//        popupDialogViewController.modalTransitionStyle = .crossDissolve
//        context.present(popupDialogViewController, animated: true, completion: nil)
//    }
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.close(_:)))
//        self.view.addGestureRecognizer(tapGesture)
//        
//        
//        // 设置背景颜色
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//
//        // 初始化对话框视图
//        dialogView = UIView()
//        dialogView.backgroundColor = .white
//        dialogView.layer.cornerRadius = 12
//        dialogView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(dialogView)
//
//        // 设置对话框视图的约束
//        NSLayoutConstraint.activate([
//            dialogView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            dialogView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            dialogView.heightAnchor.constraint(equalToConstant: 500),
////            dialogView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        // 添加 WebView
//        webView = WKWebView()
//        if #available(iOS 16.4, *) {
//            webView.isInspectable = true
//        } else {
//            // Fallback on earlier versions
//        }
//        self.webView.isUserInteractionEnabled = true
////        self.webView.scrollView.isScrollEnabled = true
//        self.webView.scrollView.bounces = false
//        self.webView.scrollView.alwaysBounceVertical = false
//        self.webView.scrollView.alwaysBounceHorizontal = false
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        webView.scrollView.contentInsetAdjustmentBehavior = .never
//        self.webView.scrollView.isScrollEnabled = false
//        
//
//        dialogView.addSubview(webView)
//        
//        // https://www.baidu.com
//        // https://tailwindui.com/login
//        // http://localhost:8080/
//        // https://www.xmplus.cn/lite/6553091743348736
//        if let url = URL(string: "http://localhost:8080") {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//        
//        let webConfiguration = WKWebViewConfiguration()
//        let contentController = WKUserContentController()
//        webConfiguration.userContentController = contentController
//
//
//        // 设置 WebView 的约束
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 20),
//            webView.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 20),
//            webView.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -20),
//            webView.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -20)
//        ])
//        
//        bottomConstraint = dialogView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        bottomConstraint?.isActive = true
//        
//        // 键盘通知
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    
////    @objc func closeDialog() {
////        self.dismiss(animated: true, completion: nil)
////    }
////    
//    @objc func close(_ sender: UITapGestureRecognizer) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
//            NSLog("keyboardWillShow");
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            bottomConstraint?.constant = -keyboardHeight
//            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
//            self.webView.scrollView.contentInset = contentInsets
//            self.webView.scrollView.scrollIndicatorInsets = contentInsets
////            self.webView.scrollView.isScrollEnabled = false;
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        bottomConstraint?.constant = 0
//        let contentInsets = UIEdgeInsets.zero
//        self.webView.scrollView.contentInset = contentInsets
//        self.webView.scrollView.scrollIndicatorInsets = contentInsets
////        self.webView.scrollView.isScrollEnabled = true;
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//}
