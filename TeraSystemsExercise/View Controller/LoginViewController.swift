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
    private let viewModel = LoginViewModel()
    weak var coordinator: LoginCoordinator?
    
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
        self.loginButton.reactive.controlEvents(.touchUpInside).observeValues { button in
            guard button == self.loginButton else { // make sure its the correct button being used in this instance
                return
            }
            self.viewModel.login { success, message in
                if success {
                    self.coordinator?.login(user: self.viewModel.user)
                }
                else {
                    Utilities.showGenericOkAlert(title: nil, message: message)
                }
            }
        }
    }
    
    func setupSignInButton() {
        self.signInButton.reactive.controlEvents(.touchUpInside).observeValues { button in
            guard button == self.signInButton else {
                return
            }
            self.coordinator?.signIn()
        }
    }
    
    
}
