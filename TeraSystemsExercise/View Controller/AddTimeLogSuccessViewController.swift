//
//  AddTimeLogSuccessViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/25/21.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class AddTimeLogSuccessViewController: UIViewController {
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    weak var delegate: AddTimeLogDelegate?
    var viewModel: AddTimeLogSuccessViewModel!
    
    init(viewModel: AddTimeLogSuccessViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Success"
        
        self.typeTextField.reactive.text <~ viewModel.type
        self.timeTextField.reactive.text <~ viewModel.time
        
        setupOkButton()
    }
    
    func setupOkButton() {
        var action: Action<Void, Void, Never> {
            return Action<Void, Void, Never> {
                return SignalProducer<Void, Never> { [weak self] observer, lifetime in
                    self?.delegate?.closeAddTimeLog(reloadLogs: true)
                    observer.sendCompleted()
                }
            }
        }
        
        self.okButton.reactive.pressed = CocoaAction(action)
    }
}

