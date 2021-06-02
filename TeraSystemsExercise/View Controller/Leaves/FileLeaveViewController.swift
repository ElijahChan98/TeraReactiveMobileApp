//
//  FileLeaveViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class FileLeaveViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var typeSelectorControl: UISegmentedControl!
    
    @IBOutlet weak var timePickerContainerView: UIView!
    @IBOutlet weak var startDatePickerContainerView: UIView!
    @IBOutlet weak var endDatePickerContainerView: UIView!
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDatePickerView: UIDatePicker!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var endDatePickerView: UIDatePicker!
    
    @IBOutlet weak var timePickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var startDatePickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var endDatePickerViewHeightConstraint: NSLayoutConstraint!
    var activityIndicator: UIActivityIndicatorView!
    var doneButton: UIBarButtonItem!
    
    weak var delegate: FileLeaveDelegate?
    var viewModel: FileLeaveViewModel!
    var timePickerDelegateController: TimePickerDelegateController!
    private var formatter = DateFormatter()
    
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
        setupDataSource()
        setupStartDateViews()
        setupEndDateViews()
        setupNavigationBar()
    }
    
    func setupStartDateViews() {
        startDatePickerView.minimumDate = Date()
        viewModel.startDate.value = formatter.string(from: Date()) //setup default value
        viewModel.startDate <~ startDatePickerView.reactive.mapControlEvents(.valueChanged, { [weak self] in
            self?.startDatePickerViewHeightConstraint.constant = 0
            self?.startDateTextField.resignFirstResponder()
            self?.startDateTextField.isUserInteractionEnabled = true
            
            return self?.formatter.string(from: $0.date) ?? ""
        })
        startDateTextField.reactive.text <~ startDateTextField.reactive.mapControlEvents(.editingDidBegin) { [weak self] textField in
            self?.startDatePickerViewHeightConstraint.constant = 100
            textField.isUserInteractionEnabled = false
            return textField.text ?? ""
        }
        
        self.startDateTextField.reactive.text <~ viewModel.startDate
    }
    
    func setupEndDateViews() {
        endDatePickerView.minimumDate = startDatePickerView.date
        viewModel.endDate.value = formatter.string(from: Date()) //setup default value
        viewModel.endDate <~ endDatePickerView.reactive.mapControlEvents(.valueChanged, { [weak self] in
            self?.endDatePickerViewHeightConstraint.constant = 0
            self?.endDateTextField.resignFirstResponder()
            self?.endDateTextField.isUserInteractionEnabled = true
            
            return self?.formatter.string(from: $0.date) ?? ""
        })
        endDateTextField.reactive.text <~ endDateTextField.reactive.mapControlEvents(.editingDidBegin) { [weak self] textField in
            self?.endDatePickerViewHeightConstraint.constant = 100
            textField.isUserInteractionEnabled = false
            return textField.text ?? ""
        }
        
        self.endDateTextField.reactive.text <~ viewModel.endDate
    }
    
    func setupDataSource() {
        viewModel.leaveType <~ typeSelectorControl.reactive.mapControlEvents(.valueChanged, {
            return "\($0.selectedSegmentIndex + 1)"
        })
        
        self.timePickerDelegateController = TimePickerDelegateController(viewModel: self.viewModel)
        self.timePickerDelegateController.delegate = self
        self.timePickerView.delegate = self.timePickerDelegateController
        self.timePickerView.dataSource = self.timePickerDelegateController
        self.timeTextField.delegate = self.timePickerDelegateController
        
        formatter.dateFormat = "MMMM d, yyyy"
    }
    
    func setupViews() {
        timePickerContainerView.addTopBorder(with: UIColor.gray, andWidth: 0.5)
        timePickerContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
        
        startDatePickerContainerView.addTopBorder(with: UIColor.gray, andWidth: 0.5)
        startDatePickerContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
        
        endDatePickerContainerView.addTopBorder(with: UIColor.gray, andWidth: 0.5)
        endDatePickerContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "File Leave"
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.done))
        doneButton.tintColor = UIColor.white
        doneButton.reactive.isEnabled <~ viewModel.doneButtonEnabled
        navigationItem.rightBarButtonItem = doneButton
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
        cancelButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = cancelButton
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func done() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        let completionObserver = viewModel.fileLeaveResponseObserver { [weak self] message in
            guard let self = self else {return}
            Utilities.showGenericOkAlert(title: nil, message: message) { _ in
                self.delegate?.fileLeaveDone(leave: self.viewModel.leave)
                
                self.navigationItem.rightBarButtonItem = self.doneButton
                self.activityIndicator.stopAnimating()
            }
        } actionOnFail: { [weak self] message in
            guard let self = self else {return}
            Utilities.showGenericOkAlert(title: nil, message: message)
            
            self.navigationItem.rightBarButtonItem = self.doneButton
            self.activityIndicator.stopAnimating()
        }
        let action = viewModel.fileLeave(completionObserver: completionObserver)
        action.apply().start()
    }
    
    @objc func cancel() {
        self.delegate?.closeFileLeave(reloadLeaves: false)
    }
}

extension FileLeaveViewController: TimePickerDelegate {
    func timePickerDidSelect(choice: String) {
        if choice != LeaveType.WholeDay.rawValue {
            endDatePickerContainerView.isHidden = true
            startDateLabel.text = "Date"
        }
        else {
            endDatePickerContainerView.isHidden = false
            startDateLabel.text = "Start Date"
        }
        timeTextField.text = choice
        viewModel.timeSpan.value = choice
        timePickerViewHeightConstraint.constant = 0
    }
    
    func timeTextFieldShouldBeginEditing() {
        timePickerViewHeightConstraint.constant = 100
    }
}

protocol FileLeaveDelegate: AnyObject {
    func closeFileLeave(reloadLeaves: Bool)
    func fileLeaveDone(leave: MutableProperty<Leaves>)
}
