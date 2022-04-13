
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    private var customScrollView: UIScrollView!
    private var infoLabel: UILabel!
    private var userLabel: UILabel!
    private var passwordLabel: UILabel!
    private var registrationLabel: UILabel!
    private var userField: UITextField!
    private var passwordField: UITextField!
    private var confirmButton: UIButton!
    private var newUserButton: UIButton!
    private var backImageView: UIImageView!
    private var date: Date!
    private var userDictionary: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewSetup()
        addTextField(field: userField)
        addTextField(field: passwordField)
        addLabel(label: infoLabel)
        addLabel(label: userLabel)
        addLabel(label: passwordLabel)
        addLabel(label: registrationLabel)
        
        backImageView = UIImageView()
        backImageView.frame = CGRect(x: view.bounds.midX - view.bounds.width / 2,
                                     y: view.bounds.minY,
                                     width: view.bounds.width,
                                     height: view.bounds.height / 3.5)
        backImageView.image = UIImage(named: "background")
        backImageView.contentMode = .scaleAspectFill
        customScrollView.addSubview(backImageView)
        backImageView.addSubview(infoLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: ViewController.keyboardWillShowNotification, object: nil)
        
        // for fast app testing
        let button = UIButton()
        button.frame = CGRect(x: view.bounds.midX - 100, y: view.bounds.maxY - 200, width: 200, height: 100)
        button.setTitle("PRESS TO TEST APP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        customScrollView.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // for fast app testing
    @objc func onButton() {
        transitToAddPhotoScreen()
    }
    
    @objc private func onConfirmButton() {
        if confirmButton.titleLabel?.text == "ENTER" {
            if passwordField.text! == userDictionary[userField.text!] {
                transitToAddPhotoScreen()
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                    self.registrationLabel.alpha = 0.7
                    self.registrationLabel.text = "Wrong! Try again!"
                    self.registrationLabel.textColor = .systemPink
                } completion: { _ in
                    UIView.animate(withDuration: 0.3, delay: 3, options: []) {
                        self.registrationLabel.alpha = 0
                    }
                }
            }
        } else {
            if userDictionary.keys.contains(userField.text!) || passwordField.text!.count < 5  {
                registrationLabel.text = "Short password or taken name"
                registrationLabel.textColor = .systemPink
                registrationLabel.alpha = 0.7
            } else {
                userDictionary[userField.text!] = passwordField.text!
                UserDefaults.standard.setValue(passwordField.text!, forKey: userField.text!)
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.labelAnimationSettings(alpha: 1,
                                                userLabelText: "user",
                                                userFieldText: "",
                                                passLabelText: "password",
                                                passFieldText: "",
                                                newUserText: "Add new user account",
                                                confirmText: "ENTER")
                    self.registrationLabel.alpha = 0
                    self.confirmButton.setTitleColor(.darkGray, for: .normal)
                }
            }
        }
    }
    
    @objc private func addNewUser() {
        if newUserButton.titleLabel?.text == "Add new user account" {
            UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                self.userLabel.alpha = 0
                self.passwordLabel.alpha = 0
                self.newUserButton.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.labelAnimationSettings(alpha: 1,
                                                userLabelText: "new user",
                                                userFieldText: "Enter new user name",
                                                passLabelText: "new password",
                                                passFieldText: "Enter new password",
                                                newUserText: "Cancel",
                                                confirmText: "CONFIRM NEW USER")
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                self.userLabel.alpha = 0
                self.passwordLabel.alpha = 0
                self.newUserButton.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.labelAnimationSettings(alpha: 1,
                                                userLabelText: "user",
                                                userFieldText: "",
                                                passLabelText: "password",
                                                passFieldText: "",
                                                newUserText: "Add new user account",
                                                confirmText: "ENTER")
                    self.confirmButton.setTitleColor(.darkGray, for: .normal)
                    self.registrationLabel.alpha = 0
                }
            }
        }
    }
    
    @objc private func keyboardWillShow() {
        customScrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height + 80)
        customScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    private func scrollViewSetup() {
        customScrollView = UIScrollView()
        confirmButton = UIButton()
        userField = UITextField()
        passwordField = UITextField()
        newUserButton = UIButton()
        userLabel = UILabel()
        passwordLabel = UILabel()
        infoLabel = UILabel()
        registrationLabel = UILabel()
        
        let labelWidth: CGFloat = view.bounds.width
        let labelHeight: CGFloat = 70
        customScrollView.backgroundColor = .black
        customScrollView.frame = view.bounds
        view.addSubview(customScrollView)
        
        confirmButton.frame = CGRect(x: view.bounds.midX - labelWidth / 3,
                                     y: view.bounds.midY + labelHeight,
                                     width: labelWidth / 1.5,
                                     height: labelHeight)
        confirmButton.layer.cornerRadius = labelHeight / 2
        confirmButton.backgroundColor = .white
        confirmButton.titleLabel?.font = UIFont(name: "AbrilFatface-Regular", size:20)
        confirmButton.setTitle("ENTER", for: .normal)
        confirmButton.setTitleColor(.darkGray, for: .normal)
        confirmButton.addTarget(self, action: #selector(onConfirmButton), for: .touchUpInside)
        customScrollView.addSubview(confirmButton)
        
        newUserButton.setTitleColor(.systemBlue, for: .normal)
        newUserButton.frame = confirmButton.frame.offsetBy(dx: 0, dy: 75)
        newUserButton.setTitle("Add new user account", for: .normal)
        newUserButton.addTarget(self, action: #selector(addNewUser), for: .touchUpInside)
        customScrollView.addSubview(newUserButton)
    }
    
    private func addTextField(field: UITextField) {
        let fieldWidth: CGFloat = view.bounds.width - 175
        let fieldHeight: CGFloat = 40
        field.delegate = self
        field.clearButtonMode = .always
        field.textAlignment = .center
        field.clearsOnBeginEditing = true
        field.backgroundColor = .systemGray5
        field.layer.cornerRadius = fieldHeight / 2
        if field == userField {
            field.frame = CGRect(x: view.bounds.midX - fieldHeight,
                                 y: view.bounds.midY - fieldWidth / 1.5,
                                 width: fieldWidth,
                                 height: fieldHeight)
            customScrollView.addSubview(userField)
        } else {
            field.frame = userField.frame.offsetBy(dx: 0, dy: 100)
            customScrollView.addSubview(passwordField)
        }
        userLabel.frame = userField.frame.offsetBy(dx: -200, dy: 0)
        passwordLabel.frame = passwordField.frame.offsetBy(dx: -200, dy: 0)
    }
    
    private func addLabel(label: UILabel) {
        let labelWidth: CGFloat = view.bounds.width
        let labelHeight: CGFloat = 70
        
        if label == infoLabel {
            label.frame = CGRect(x: view.bounds.midX - labelWidth / 2,
                                 y: view.bounds.minY + labelHeight * 2,
                                 width: labelWidth,
                                 height: labelHeight)
            label.text = "PHOTO GALLERY"
            label.font = UIFont(name: "AbrilFatface-Regular", size:40)
        } else if label == userLabel {
            label.text = "user"
            label.font = UIFont(name: "AbrilFatface-Regular", size:25)
        } else if label == passwordLabel {
            passwordLabel.text = "password"
            label.font = UIFont(name: "AbrilFatface-Regular", size:25)
        } else {
            label.frame = confirmButton.frame.offsetBy(dx: 0, dy: -75)
            label.text = ""
            label.font = UIFont(name: "AbrilFatface-Regular", size: 15)
            label.alpha = 0
        }
        label.textColor = .white
        label.textAlignment = .center
        customScrollView.addSubview(label)
    }
    
    private func labelAnimationSettings(alpha: CGFloat,
                                        userLabelText: String,
                                        userFieldText: String,
                                        passLabelText: String,
                                        passFieldText: String,
                                        newUserText: String,
                                        confirmText: String) {
        userLabel.alpha = alpha
        passwordLabel.alpha = alpha
        newUserButton.alpha = alpha
        userLabel.text = userLabelText
        userField.text = userFieldText
        passwordLabel.text = passLabelText
        passwordField.text = passFieldText
        newUserButton.setTitle(newUserText, for: .normal)
        passwordLabel.font = UIFont(name: "AbrilFatface-Regular", size: 22)
        confirmButton.setTitle(confirmText, for: .normal)
        confirmButton.setTitleColor(.systemGreen, for: .normal)
    }
    
    private func transitToAddPhotoScreen() {
        let storyboard = UIStoryboard.init(name: "AddPhotoScreen", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as! AddPhotoScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        customScrollView.isScrollEnabled = false
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.customScrollView.contentSize = CGSize(width: self.view.bounds.width,
                                                       height: self.view.bounds.height)
        }
        return true
    }
    

}

