# How to hide the onscreen keyboard automatically on UITextField UIKit

By default, the UITextField onscreen keyboard does not hide itself. It is the programmer's responsibility to write the logic of keyboard hiding. 
It would be convenient to hide the keyboard automatically when the user has finished entering data and is no longer active.

This code tracks changes in the text field by starting a timer each time the user enters a new character. If no new characters are entered for a period of time, the keyboard hides. You can customise the waiting time for your project.

![2023-12-2816 30 58-ezgif com-video-to-gif-converter](https://github.com/Konst-Is/HideKeyboardAutomatically/assets/125888284/1c467426-bb58-4a28-8aed-9a4dc40428b5)

### Code

```swift
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification , object: nil)
    }
    
    /// Handle a click on the UITextField onscreen keyboard button.
    ///
    /// Each time a keyboard button is pressed and a textDidChangeNotification notification is received, the timer is stopped if it was started, and the timer is started again, which calls the hideKeyboard() method via timeInterval.
    @objc
    func handleTextDidChange() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(hideKeyboard), userInfo: nil, repeats: false)
    }
    
    /// Hide the UITextField onscreen keyboard
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
}
```

## How to rise UITextField when keyboard appears

When the onscreen keyboard appears on the screen, it can obscure the text field and other elements on the screen. To solve this problem, place a UIScrollView on the screen and place text fields and other UI-elements on it. 
This code implements raising the content to exactly the height of the onscreen keyboard.

### Code

```swift
final class ViewController: UIViewController {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
```




