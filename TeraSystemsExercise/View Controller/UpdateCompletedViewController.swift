//
//  UpdateCompletedViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit

class UpdateCompletedViewController: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    weak var coordinator: UpdateCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Success"
        setupOkButton()
        navigationItem.setHidesBackButton(true, animated: false)
    }

    func setupOkButton() {
        self.okButton.reactive.controlEvents(.touchUpInside).observeValues { button in
            guard button == self.okButton else {
                return
            }
            self.coordinator?.closeUpdate()
        }
    }
}
