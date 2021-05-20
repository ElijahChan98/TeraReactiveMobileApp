//
//  MainCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/14/21.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    unowned var user: User!
    weak var parent: LoginCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileViewModel = ProfileViewModel(user: user)
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        profileVC.delegate = self
        self.navigationController.pushViewController(profileVC, animated: false)
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(self.navigationController)
    }
    
    func start(user: User) {
        self.user = user
        self.start()
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

extension MainCoordinator: ProfileViewControllerDelegate{
    func update() {
        let child = UpdateCoordinator(navigationController: UINavigationController())
        child.parent = self
        childCoordinators.append(child)
        child.start(user: self.user)
    }
    
    func logout() {
        guard let parentNavController = parent?.navigationController else {
            return
        }
        self.user = nil
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(parentNavController)
        parent?.childDidFinish(self)
    }
    
    func getUser() -> User {
        return self.user
    }
}
