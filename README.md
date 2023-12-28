# Implementation of automatic hiding of UITextField keyboard in UIKit

By default, the UITextField popup keyboard does not hide itself. It is the programmer's responsibility to write the logic of keyboard hiding. 
It would be convenient to hide the keyboard automatically when the user has finished entering data and is no longer active.
This code tracks changes in the text field by starting a timer each time the user enters a new character. If no new characters are entered for a period of time, the keyboard hides. You can customise the waiting time for your project.

### Code

```swift
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
        NotificationCenter.default.addObserver(self, selector: #selector(trackEditing), name: UITextField.textDidChangeNotification, object: nil)
    }

    func unsubscribeToNotifications() {
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
}
```
