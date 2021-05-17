//
//  Coordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/10/21.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
