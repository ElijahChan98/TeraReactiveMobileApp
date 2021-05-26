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
    var navigationController: UINavigationController
    private var timeLogsVC: TimeLogsViewController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = TimeLogsViewModel()
        self.timeLogsVC = TimeLogsViewController(viewModel: viewModel)
        timeLogsVC.delegate = self
        self.navigationController.pushViewController(timeLogsVC, animated: false)
    }
    
    func reloadLogs() {
        self.timeLogsVC.reloadTableView()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
            }
        }
    }
}

extension TimeLogsCoordinator: TimeLogsDelegate {
    func showTimeLogDetails(timeLog: TimeLog) {
        let viewModel = TimeLogDetailsViewModel(timeLog: timeLog)
        let timeLogDetailsVC = TimeLogDetailsViewController(viewModel: viewModel)
        self.navigationController.pushViewController(timeLogDetailsVC, animated: true)
    }
    
    func addTimeLog() {
        let child = AddTimeLogCoordinator(navigationController: UINavigationController())
        child.parent = self
        childCoordinators.append(child)
        child.start()
    }
}
