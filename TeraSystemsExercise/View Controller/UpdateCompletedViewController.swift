//
//  UpdateCompletedViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class UpdateCompletedViewController: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    weak var delegate: UpdateProfileViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Success"
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupOkButton()
    }

    func setupOkButton() {
        self.okButton.reactive.pressed = CocoaAction(Action<Void, Void, Never> { [weak self] in
            return SignalProducer<Void, Never> { observer, lifetime in
                self?.delegate?.closeUpdate()
                observer.sendCompleted()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.okButton.reactive.pressed = nil
    }
}
