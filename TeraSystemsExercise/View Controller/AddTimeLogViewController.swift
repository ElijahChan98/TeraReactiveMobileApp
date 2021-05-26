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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.done))
        doneButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
        cancelButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = cancelButton
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func done() {
        guard let type = typeTextField.text, type.count > 0 else {
            return
        }
        self.delegate?.addTimeLogDone(type: type, time: viewModel.getCurrentTime())
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
