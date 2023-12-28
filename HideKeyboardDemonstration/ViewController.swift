import UIKit

final class ViewController: UIViewController {

    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var editingNotifications: [Notification] = []
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeToNotifications()
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(trackEditing), name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    func unsubscribeToNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification , object: nil)
    }
    
    @objc
    func trackEditing(_ notification: Notification) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideKeyboard), userInfo: nil, repeats: true)
        
        editingNotifications.append(notification)
    }
    
    @objc
    func hideKeyboard() {
        if editingNotifications.isEmpty {
            view.endEditing(true)
            timer?.invalidate()
        } else {
            editingNotifications = []
        }
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc
    func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    @IBAction func hideKeyboardButtonTap(_ sender: UIButton) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
    
}


