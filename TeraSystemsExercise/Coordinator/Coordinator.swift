//
//  Coordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/10/21.
//

import UIKit
import SafariServices

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class LoginCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        self.navigationController.pushViewController(loginVC, animated: false)
    }
    
    func login(user: User) {
        let navController = UINavigationController()
        let mainCoordinator = MainCoordinator(navigationController: navController)
        mainCoordinator.user = user
        mainCoordinator.parent = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    func signIn() {
        guard let url = URL(string: "http://www.terasystem.com.") else {
            return
        }
        let config = SFSafariViewController.Configuration()
        let signInVC = SFSafariViewController(url: url, configuration: config)
        navigationController.present(signInVC, animated: true, completion: nil)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var user: User!
    var parent: LoginCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileViewModel = ProfileViewModel(user: user)
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        profileVC.coordinator = self
        profileViewModel.delegate = profileVC
        self.navigationController.pushViewController(profileVC, animated: false)
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(self.navigationController)
    }
    
    func update() {
        let child = UpdateCoordinator(navigationController: UINavigationController())
        child.user = user
        child.parent = self
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    @objc func logout() {
        guard let parentNavController = parent?.navigationController else {
            return
        }
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(parentNavController)
        parent?.childDidFinish(self)
    }
}

class UpdateCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var user: User!
    var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let updateProfileVC = UpdateProfileViewController(viewModel: UpdateProfileViewModel(user: user))
        updateProfileVC.coordinator = self
        let updateNavigationController = UINavigationController(rootViewController: updateProfileVC)
        updateNavigationController.modalPresentationStyle = .fullScreen
        self.navigationController = updateNavigationController
        parent?.navigationController.present(updateNavigationController, animated: true, completion: nil)
    }
    func successUpdate(updatedUser: User) {
        self.user = updatedUser
        let updateCompleteVC = UpdateCompletedViewController()
        updateCompleteVC.coordinator = self
        self.navigationController.pushViewController(updateCompleteVC, animated: true)
    }
    
    @objc func closeUpdate() {
        parent?.user = self.user
        parent?.navigationController.dismiss(animated: true) {
            self.parent?.childDidFinish(self)
        }
    }
}
