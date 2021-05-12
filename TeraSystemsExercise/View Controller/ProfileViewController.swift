//
//  ProfileViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/6/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ProfileViewController: UIViewController, ProfileViewModelProtocol {
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
    var coordinator: MainCoordinator?
    
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
        guard let user = coordinator?.user else {
            return
        }
        self.viewModel.updateUser(user: user)
    }
    
    func setupNavigationBar() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: coordinator, action: #selector(coordinator?.logout))
        logoutButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = logoutButton
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func setupViews() {
        initialsContainerView.layer.cornerRadius = initialsContainerView.frame.size.width / 2
        mainContainerView.layer.borderWidth = 1
        mainContainerView.layer.borderColor = UIColor.gray.cgColor
        mainContainerView.layer.cornerRadius = 10
    }
    
    func reloadUserLabels() {
        updateLabelsObserver.send(value: ())
    }
    
    func setupLabels() {
        updateLabelsObserver = Signal<Void, Never>.Observer(value: { _ in
            self.initialsLabel.reactive.text <~ self.viewModel.initials
            self.fullNameLabel.reactive.text <~ self.viewModel.fullName
            self.idNumberLabel.reactive.text <~ self.viewModel.user.idNumberProperty
            self.emailLabel.reactive.text <~ self.viewModel.user.emailProperty
            self.mobileNumberLabel.reactive.text <~ self.viewModel.user.mobileNumberProperty
        })
        updateLabelsObserver.send(value: ())
    }
    
    func setupUpdateButton() {
        self.updateButton.reactive.controlEvents(.touchUpInside).observeValues { button in
            guard button == self.updateButton else {
                return
            }
            self.coordinator?.update()
        }
    }

}
