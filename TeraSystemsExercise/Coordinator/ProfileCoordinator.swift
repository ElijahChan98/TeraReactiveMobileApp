//
//  MainCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/14/21.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var user: User!
    weak var parent: MenuTabBarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileViewModel = ProfileViewModel(user: user)
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        profileVC.delegate = self
        self.navigationController.pushViewController(profileVC, animated: false)
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

extension ProfileCoordinator: ProfileViewControllerDelegate{
    func update() {
        let child = UpdateCoordinator(navigationController: UINavigationController())
        child.parent = self
        childCoordinators.append(child)
        child.start(user: self.user)
    }
    
    func logout() {
        parent?.childDidFinish(self)
    }
    
    func getUser() -> User {
        return self.user
    }
}
