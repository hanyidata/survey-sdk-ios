import UIKit

public class HYTestDialog: UIViewController {

    var dialogView: UIView!
    var bottomConstraint: NSLayoutConstraint?

    @objc public static func makeDialog(context: UIViewController, surveyId: String, channelId: String, parameters: Dictionary<String, Any>, options: Dictionary<String, Any>,
                                        onSubmit: Optional<() -> Void> = nil,
                                        onCancel: Optional<() -> Void> = nil,
                                        onError: Optional<(_: String) -> Void> = nil
    ) -> Void {
        let popupDialogViewController = HYTestDialog()
        popupDialogViewController.modalPresentationStyle = .overFullScreen
        popupDialogViewController.modalTransitionStyle = .crossDissolve
        context.present(popupDialogViewController, animated: true, completion: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // 设置背景颜色
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // 初始化对话框视图
        dialogView = UIView()
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 12
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dialogView)

        // 设置对话框视图的约束
        NSLayoutConstraint.activate([
            dialogView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dialogView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dialogView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        bottomConstraint = dialogView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true

        // 添加输入框
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter your input"
        inputTextField.borderStyle = .roundedRect
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(inputTextField)
        
        // 添加按钮
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeDialog), for: .touchUpInside)
        dialogView.addSubview(button)

        // 设置输入框和按钮的约束
        NSLayoutConstraint.activate([
            inputTextField.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor),
            inputTextField.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 20),
            inputTextField.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 20),
            inputTextField.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -20),
            inputTextField.heightAnchor.constraint(equalToConstant: 40),
            
            button.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor),
            button.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])

        // 键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func closeDialog() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardFrame.cgRectValue.height;
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
