//
//  MenuTabBarController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/24/21.
//

import UIKit

class MenuTabBarController: UITabBarController, UITabBarControllerDelegate {
    weak var coordinator: MenuTabBarCoordinator?
    
    override func viewDidLoad() {
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.viewControllers = coordinator?.viewControllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
