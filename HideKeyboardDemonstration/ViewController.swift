import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(keyboardWillShow), 
                                               name: UIResponder.keyboardWillShowNotification, 
                                               object: nil)
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(keyboardWillHide), 
                                               name: UIResponder.keyboardWillHideNotification, 
                                               object: nil)
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(handleTextDidChange), 
                                               name: UITextField.textDidChangeNotification, 
                                               object: nil) 
    }
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self, 
                                                  name: UIResponder.keyboardWillChangeFrameNotification, 
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, 
                                                  name: UIResponder.keyboardWillHideNotification, 
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, 
                                                  name: UITextField.textDidChangeNotification , 
                                                  object: nil)
    }
    
    /// Handle a click on the UITextField onscreen keyboard button.
    ///
    /// Each time a keyboard button is pressed and a textDidChangeNotification notification is received, the timer is stopped if it was started, and the timer is started again, which calls the hideKeyboard() method via timeInterval.
    @objc
    func handleTextDidChange() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.0, 
                                     target: self, 
                                     selector: #selector(hideKeyboard), 
                                     userInfo: nil, 
                                     repeats: false)
    }
    
    /// Hide the UITextField onscreen keyboard
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    /// Raise the content when the onscreen keyboard UITextField appears
    @objc
    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    /// Return content to its original location when the onscreen keyboard UITextField disappears
    @objc
    func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    @IBAction func hideKeyboardButtonTap(_ sender: UIButton) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
    
}


