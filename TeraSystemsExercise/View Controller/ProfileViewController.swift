//
//  ProfileViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/6/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ProfileViewController: UIViewController {
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var initialsContainerView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var idNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    private var updateLabelsObserver: Signal<Void, Never>.Observer!
    var viewModel: ProfileViewModel!
    weak var delegate: ProfileViewControllerDelegate?
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUpdateButton()
        setupViews()
        setupLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = delegate?.getUser() else {
            return
        }
        self.viewModel.updateUser(user: user)
    }
    
    func setupNavigationBar() {
        self.title = "Profile"
        let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(self.logout))
        logoutButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = logoutButton
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func logout() {
        self.delegate?.logout()
    }
    
    func setupViews() {
        initialsContainerView.layer.cornerRadius = initialsContainerView.frame.size.width / 2
        mainContainerView.layer.borderWidth = 1
        mainContainerView.layer.borderColor = UIColor.gray.cgColor
        mainContainerView.layer.cornerRadius = 10
    }
    
    func setupLabels() {
        self.initialsLabel.reactive.text <~ self.viewModel.initialsProducer
        self.fullNameLabel.reactive.text <~ self.viewModel.fullNameProducer
        self.idNumberLabel.reactive.text <~ self.viewModel.userProperty.idNumberProperty
        self.emailLabel.reactive.text <~ self.viewModel.userProperty.emailProperty
        self.mobileNumberLabel.reactive.text <~ self.viewModel.userProperty.mobileNumberProperty
    }
    
    func setupUpdateButton() {
        self.updateButton.reactive.pressed = CocoaAction(Action<Void, Void, Never> {
            return SignalProducer<Void, Never> { observer, lifetime in
                self.delegate?.update()
                observer.sendCompleted()
            }
        })
    }
}

protocol ProfileViewControllerDelegate: AnyObject {
    func update()
    func logout()
    func getUser() -> User
}
