//
//  AddTimeLogViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/25/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class AddTimeLogViewController: UIViewController {
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    var activityIndicator: UIActivityIndicatorView!
    var doneButton: UIBarButtonItem!
    
    weak var delegate: AddTimeLogDelegate?
    var viewModel: AddTimeLogViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AddTimeLogViewModel()
        
        setupNavigationBar()
        setupViews()
    }
    
    func setupViews() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.typeTextField.delegate = self
        self.typeTextField.inputView = pickerView
        self.pickerView.isHidden = true
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Add Time Log"
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.done))
        doneButton.tintColor = UIColor.white
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
        guard let type = typeTextField.text else {
            return
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        let completionObserver = viewModel.addTimeLogResponseObserver { [weak self] _ in
            guard let self = self else {return}
            self.delegate?.addTimeLogDone(type: type, time: self.viewModel.getCurrentTime())
            
            self.navigationItem.rightBarButtonItem = self.doneButton
            self.activityIndicator.stopAnimating()
        } actionOnFail: { [weak self] message in
            guard let self = self else {return}
            Utilities.showGenericOkAlert(title: nil, message: message)
            
            self.navigationItem.rightBarButtonItem = self.doneButton
            self.activityIndicator.stopAnimating()
        }
        
        let addTimeLogAction = viewModel.addTimeLog(completionObserver: completionObserver)
        
        addTimeLogAction.apply().start()

    }
    
    @objc func cancel() {
        self.delegate?.closeAddTimeLog(reloadLogs: false)
    }
}

extension AddTimeLogViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.timeLogTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.timeLogTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = viewModel.timeLogTypes[row]
        viewModel.type.value = viewModel.timeLogTypes[row]
        pickerView.isHidden = true
    }
}

extension AddTimeLogViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = false
        return false
    }
}

protocol AddTimeLogDelegate: AnyObject {
    func closeAddTimeLog(reloadLogs: Bool)
    func addTimeLogDone(type: String, time: String)
}
