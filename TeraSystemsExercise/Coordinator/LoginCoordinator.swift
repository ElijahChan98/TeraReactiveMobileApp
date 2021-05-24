//
//  LoginCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/14/21.
//

import UIKit
import SafariServices

class LoginCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        self.navigationController.pushViewController(loginVC, animated: false)
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

extension LoginCoordinator: LoginViewControllerDelegate {
    func login(user: User) {
        let navController = UINavigationController()
        let menuTabBarCoordinator = MenuTabBarCoordinator(navigationController: navController)
        menuTabBarCoordinator.parent = self
        childCoordinators.append(menuTabBarCoordinator)
        menuTabBarCoordinator.start(user: user)
    }
    
    func signIn() {
        guard let url = URL(string: "http://www.terasystem.com") else {
            return
        }
        let config = SFSafariViewController.Configuration()
        let signInVC = SFSafariViewController(url: url, configuration: config)
        navigationController.present(signInVC, animated: true, completion: nil)
    }
}
