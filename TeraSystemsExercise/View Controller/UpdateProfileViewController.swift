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
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var idNumberTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var landlineTextField: UITextField!
    var viewModel: UpdateProfileViewModel!
    weak var coordinator: UpdateCoordinator?
    
    init(viewModel: UpdateProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLabels()
        setupUpdateButton()
    }
    
    func setupLabels() {
        self.idNumberTextField.reactive.text <~ viewModel.user.idNumberProperty
        self.firstNameTextField.reactive.text <~ viewModel.user.firstNameProperty
        self.middleNameTextField.reactive.text <~ viewModel.user.middleNameProperty
        self.lastNameTextField.reactive.text <~ viewModel.user.lastNameProperty
        self.emailTextField.reactive.text <~ viewModel.user.emailProperty
        self.mobileTextField.reactive.text <~ viewModel.user.mobileNumberProperty
        self.landlineTextField.reactive.text <~ viewModel.user.landlineProperty
        
        viewModel.user.idNumberProperty <~ self.idNumberTextField.reactive.continuousTextValues
        viewModel.user.firstNameProperty <~ self.firstNameTextField.reactive.continuousTextValues
        viewModel.user.middleNameProperty <~ self.middleNameTextField.reactive.continuousTextValues
        viewModel.user.lastNameProperty <~ self.lastNameTextField.reactive.continuousTextValues
        viewModel.user.emailProperty <~ self.emailTextField.reactive.continuousTextValues
        viewModel.user.mobileNumberProperty <~ self.mobileTextField.reactive.continuousTextValues
        viewModel.user.landlineProperty <~ self.landlineTextField.reactive.continuousTextValues
    }

    func setupNavigationBar() {
        self.title = "Update Profile"
        let closeButton = UIBarButtonItem(title: "X", style: .done, target: coordinator, action: #selector(coordinator?.closeUpdate))
        closeButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    func setupUpdateButton() {
        let observer = viewModel.updateButtonObserver {
            self.updateButton.isEnabled = true
            self.updateButton.alpha = 1.0
        } actionIfDisabled: {
            self.updateButton.isEnabled = false
            self.updateButton.alpha = 0.5
        }
        let enabled = viewModel.updateButtonEnabled
        enabled.signal.observe(observer)

        self.updateButton.reactive.controlEvents(.touchUpInside).observeValues { button in
            guard button == self.updateButton else {
                return
            }
            self.viewModel.update { success, message in
                if success {
                    self.coordinator?.successUpdate(updatedUser: self.viewModel.user)
                }
            }
        }
    }

}
