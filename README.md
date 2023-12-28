# How to hide the onscreen keyboard automatically on UITextField UIKit

By default, the UITextField onscreen keyboard does not hide itself. It is the programmer's responsibility to write the logic of keyboard hiding. 
It would be convenient to hide the keyboard automatically when the user has finished entering data and is no longer active.

This code tracks changes in the text field by starting a timer each time the user enters a new character. If no new characters are entered for a period of time, the keyboard hides. You can customise the waiting time for your project.

[![Demonstration](https://im2.ezgif.com/tmp/ezgif-2-eea7b2730c.gif) 


### Code

```swift
import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(trackEditing),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }

    func unsubscribeToNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextField.textDidChangeNotification,
                                                  object: nil)
    }

    @objc
    func trackEditing(_ notification: Notification) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(hideKeyboard),
                                     userInfo: nil,
                                     repeats: true)
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
}
```

[Download Demonstration Project](https://github.com/Konst-Is/HideKeyboardAutomatically.git) 

## How to rise UITextField when keyboard appears

When the onscreen keyboard appears on the screen, it can obscure the text field and other elements on the screen. To solve this problem, place a UIScrollView on the screen and place text fields and other UI-elements on it. 
This code implements raising the content to exactly the height of the onscreen keyboard.

### Code

```swift
import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
    }

    deinit {
        unsubscribeToNotifications()
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
    }

    func unsubscribeToNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
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
```

[Download Demonstration Project](https://github.com/Konst-Is/HideKeyboardAutomatically.git) 



