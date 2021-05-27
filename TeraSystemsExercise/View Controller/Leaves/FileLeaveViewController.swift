//
//  FileLeaveViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit

class FileLeaveViewController: UIViewController {
    @IBOutlet weak var timePickerContainerView: UIView!
    @IBOutlet weak var startDatePickerContainerView: UIView!
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var startDatePickerView: UIDatePicker!
    
    @IBOutlet weak var timePickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var startDatePickerViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: FileLeaveViewModel!
    var timePickerDelegateController: TimePickerDelegateController!
    
    init(viewModel: FileLeaveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.timePickerDelegateController = TimePickerDelegateController(viewModel: self.viewModel)
        self.timePickerDelegateController.delegate = self
        self.timePickerView.delegate = self.timePickerDelegateController
        self.timePickerView.dataSource = self.timePickerDelegateController
        self.timeTextField.delegate = self.timePickerDelegateController
    }
    
    func setupViews() {
        timePickerContainerView.addTopBorder(with: UIColor.gray, andWidth: 0.5)
        timePickerContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
    }
}

extension FileLeaveViewController: TimePickerDelegate {
    func timePickerDidSelect(choice: String) {
        timeTextField.text = choice
        timePickerViewHeightConstraint.constant = 0
    }
    
    func timeTextFieldShouldBeginEditing() {
        timePickerViewHeightConstraint.constant = 100
    }
}
