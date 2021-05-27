//
//  FileLeaveDelegates.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit

class TimePickerDelegateController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var viewModel: FileLeaveViewModel!
    weak var delegate: TimePickerDelegate?
    
    init(viewModel: FileLeaveViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.choices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.timePickerDidSelect(choice: viewModel.choices[row])
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.timeTextFieldShouldBeginEditing()
        return false
    }
}

protocol TimePickerDelegate: AnyObject{
    func timePickerDidSelect(choice: String)
    func timeTextFieldShouldBeginEditing()
}
