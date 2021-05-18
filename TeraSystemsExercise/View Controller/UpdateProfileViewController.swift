//
//  UpdateProfileViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/6/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class UpdateProfileViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var idNumberTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var landlineTextField: UITextField!
    var viewModel: UpdateProfileViewModel!
    weak var delegate: UpdateProfileViewControllerDelegate?
    
    init(viewModel: UpdateProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardInset()
        setupNavigationBar()
        setupLabels()
        setupUpdateButton()
        
        mobileTextField.delegate = self
        landlineTextField.delegate = self
    }
    
    func setupLabels() {
        let user = viewModel.userProperty!
        self.idNumberTextField.reactive.text <~ user.idNumberProperty
        self.firstNameTextField.reactive.text <~ user.firstNameProperty
        self.middleNameTextField.reactive.text <~ user.middleNameProperty
        self.lastNameTextField.reactive.text <~ user.lastNameProperty
        self.emailTextField.reactive.text <~ user.emailProperty
        self.mobileTextField.reactive.text <~ user.mobileNumberProperty
        self.landlineTextField.reactive.text <~ user.landlineProperty
        
        user.idNumberProperty <~ self.idNumberTextField.reactive.continuousTextValues
        user.firstNameProperty <~ self.firstNameTextField.reactive.continuousTextValues
        user.middleNameProperty <~ self.middleNameTextField.reactive.continuousTextValues
        user.lastNameProperty <~ self.lastNameTextField.reactive.continuousTextValues
        user.emailProperty <~ self.emailTextField.reactive.continuousTextValues
        user.mobileNumberProperty <~ self.mobileTextField.reactive.continuousTextValues
        user.landlineProperty <~ self.landlineTextField.reactive.continuousTextValues
    }

    func setupNavigationBar() {
        self.title = "Update Profile"
        let closeButton = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(closeUpdate))
        
        closeButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    @objc func closeUpdate() {
        self.delegate?.closeUpdate()
    }
    
    func setupUpdateButton() {
        let buttonObserver = viewModel.updateButtonObserver {
            self.updateButton.isEnabled = true
            self.updateButton.alpha = 1.0
        } actionIfDisabled: {
            self.updateButton.isEnabled = false
            self.updateButton.alpha = 0.5
        }
        
        let completionObserver = viewModel.updateResponseObserver { message in
            self.delegate?.successUpdate(updatedUser: self.viewModel.user)
            self.activityIndicator.stopAnimating()
        } actionOnFail: { message in
            Utilities.showGenericOkAlert(title: nil, message: message)
            self.activityIndicator.stopAnimating()
        }
        
        self.updateButton.reactive.pressed = CocoaAction(viewModel.update(stateObserver: buttonObserver, completionObserver: completionObserver)) { sender in
            self.activityIndicator.startAnimating()
        }
    }
}

extension UpdateProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func setupKeyboardInset() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

protocol UpdateProfileViewControllerDelegate: AnyObject{
    func successUpdate(updatedUser: User)
    func closeUpdate()
}
