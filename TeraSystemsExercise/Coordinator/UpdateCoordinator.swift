//
//  UpdateCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/14/21.
//

import UIKit

class UpdateCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    unowned var user: User!
    weak var parent: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(user: User){
        self.user = user
        self.start()
    }
    
    func start() {
        let updateProfileVC = UpdateProfileViewController(viewModel: UpdateProfileViewModel(user: user))
        updateProfileVC.delegate = self
        let updateNavigationController = UINavigationController(rootViewController: updateProfileVC)
        updateNavigationController.modalPresentationStyle = .fullScreen
        self.navigationController = updateNavigationController
        parent?.navigationController.present(updateNavigationController, animated: true, completion: nil)
    }
}

extension UpdateCoordinator: UpdateProfileViewControllerDelegate {
    func successUpdate(updatedUser: User) {
        parent?.user = updatedUser
        let updateCompleteVC = UpdateCompletedViewController()
        updateCompleteVC.delegate = self
        self.navigationController.pushViewController(updateCompleteVC, animated: true)
    }
    
    func closeUpdate() {
        parent?.navigationController.dismiss(animated: true) {
            self.user = nil
            self.parent?.childDidFinish(self)
        }
    }
}
