//
//  MenuTabBarCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/24/21.
//

import UIKit

class MenuTabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var user: User!
    var viewControllers: [UIViewController] = []
    weak var parent: LoginCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setupTimeLogsCoordinator()
        setupLeavesCoordinator()
        
        let clientsVC = UIViewController()
        let clientsItem = UITabBarItem(title: "Clients", image: nil, selectedImage: nil)
        clientsVC.tabBarItem = clientsItem
        viewControllers.append(clientsVC)
        
        setupProfileCoordinator()
        
        let menuTabBarController = MenuTabBarController()
        menuTabBarController.coordinator = self
        self.navigationController.pushViewController(menuTabBarController, animated: false)
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(self.navigationController)
    }
    
    func setupTimeLogsCoordinator() {
        let navigationController = UINavigationController()
        let timeLogsCoordinator = TimeLogsCoordinator(navigationController: navigationController)
        timeLogsCoordinator.start()
        timeLogsCoordinator.parent = self
        
        let timeLogsItem = UITabBarItem(title: "Time Logs", image: UIImage(named: "timelogs"), selectedImage: nil)
        navigationController.tabBarItem = timeLogsItem
        
        viewControllers.append(navigationController)
        childCoordinators.append(timeLogsCoordinator)
    }
    
    func setupLeavesCoordinator() {
        let navigationController = UINavigationController()
        let leavesCoordinator = LeavesCoordinator(navigationController: navigationController)
        leavesCoordinator.start()
        leavesCoordinator.parent = self
        
        let leavesItem = UITabBarItem(title: "Leaves", image: UIImage(named: "leaves"), selectedImage: nil)
        navigationController.tabBarItem = leavesItem
        
        viewControllers.append(navigationController)
        childCoordinators.append(leavesCoordinator)
    }
    
    func setupProfileCoordinator() {
        let navigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.start(user: user)
        profileCoordinator.parent = self
        
        let profileItem = UITabBarItem(title: "Me", image: UIImage(named: "profile"), selectedImage: nil)
        navigationController.tabBarItem = profileItem
        
        viewControllers.append(navigationController)
        childCoordinators.append(profileCoordinator)
    }
    
    func start(user: User) {
        self.user = user
        self.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                if let _ = child as? ProfileCoordinator { //on logout
                    backToLoginScreen()
                }
            }
        }
    }
    
    private func backToLoginScreen() {
        guard let parentNavController = parent?.navigationController else {
            return
        }
        viewControllers = []
        childCoordinators = []
        parent?.childDidFinish(self)
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(parentNavController)
    }
}
