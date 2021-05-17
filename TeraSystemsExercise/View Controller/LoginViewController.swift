//
//  LoginViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/6/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let viewModel = LoginViewModel()
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setup() {
        passwordTextField.isSecureTextEntry = true
        viewModel.usernameProperty <~ userNameTextField.reactive.continuousTextValues
        viewModel.passwordProperty <~ passwordTextField.reactive.continuousTextValues
        setupLoginButton()
        setupSignInButton()
    }

    func setupLoginButton() {
        let observer = viewModel.loginButtonObserver {
            self.loginButton.isEnabled = true
            self.loginButton.alpha = 1.0
        } actionIfDisabled: {
            self.loginButton.isEnabled = false
            self.loginButton.alpha = 0.5
        }
        let validator = viewModel.validator
        validator.producer.start(observer)

        
        self.loginButton.reactive.pressed = CocoaAction(viewModel.loginAction(completion: { success, message in
            if success {
                self.delegate?.login(user: self.viewModel.user)
            }
            else {
                Utilities.showGenericOkAlert(title: nil, message: message)
            }
            self.activityIndicator.stopAnimating()
        })) { sender in self.activityIndicator.startAnimating() }
    }
    
    func setupSignInButton() {
        self.signInButton.reactive.pressed = CocoaAction(Action<Void, Void, Never> {
            return SignalProducer<Void, Never> { observer, lifetime in
                self.delegate?.signIn()
                observer.sendCompleted()
            }
        })
    }
}

protocol LoginViewControllerDelegate: AnyObject {
    func login(user: User)
    func signIn()
}