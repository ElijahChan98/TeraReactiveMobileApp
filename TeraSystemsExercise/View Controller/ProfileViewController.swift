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
        setupViews()
        setupLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUpdateButton()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        self.viewModel.user.map { user in
            self.idNumberLabel.reactive.text <~ user.map({$0.idNumber})
            self.fullNameLabel.reactive.text <~ user.map({$0.fullName})
            self.initialsLabel.reactive.text <~ user.map({$0.initials})
            self.emailLabel.reactive.text <~ user.map({$0.email})
            self.mobileNumberLabel.reactive.text <~ user.map({$0.mobileNumber})
        }
    }
    
    func setupUpdateButton() {
        self.updateButton.reactive.pressed = CocoaAction(Action<Void, Void, Never> {
            return SignalProducer<Void, Never> { observer, lifetime in
                self.delegate?.update()
                observer.sendCompleted()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.updateButton.reactive.pressed = nil
    }
}

protocol ProfileViewControllerDelegate: AnyObject {
    func update()
    func logout()
    func getUser() -> User
}
