//
//  TimeLogsCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/24/21.
//

import UIKit

class TimeLogsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parent: MenuTabBarCoordinator?
    unowned var user: User!
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(user: User){
        self.user = user
        self.start()
    }
    
    func start() {
        let timeLogsViewModel = TimeLogsViewModel(user: user)
        let timeLogsVC = TimeLogsViewController(viewModel: timeLogsViewModel)
        timeLogsVC.delegate = self
        self.navigationController.pushViewController(timeLogsVC, animated: false)
    }
}

extension TimeLogsCoordinator: TimeLogsDelegate {
    
}
