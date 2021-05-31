//
//  FileLeaveSuccessfulViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/28/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class FileLeaveSuccessfulViewController: UIViewController {
    @IBOutlet weak var typeContainerView: UIView!
    @IBOutlet weak var timeContainerView: UIView!
    @IBOutlet weak var startContainerView: UIView!
    @IBOutlet weak var endContainerView: UIView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    weak var delegate: FileLeaveDelegate?
    var viewModel: FileLeaveSuccessfulViewModel!
    
    init(viewModel: FileLeaveSuccessfulViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.navigationItem.title = "Success"
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupOkButton()
        
        typeLabel.reactive.text <~ viewModel.leave.map({$0.typeValue})
        timeLabel.reactive.text <~ viewModel.leave.map({$0.time})
        startLabel.reactive.text <~ viewModel.leave.map({$0.dateFrom})
        endLabel.reactive.text <~ viewModel.leave.map({$0.dateTo})
        
        endContainerView.reactive.isHidden <~ viewModel.leave.map({$0.timeValue != "1"})
    }
    
    func setupViews() {
        typeContainerView.addTopBorder(with: UIColor.gray, andWidth: 0.5)
        typeContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
        
        startContainerView.addTopBorder(with: UIColor.gray, andWidth: 0.5)
        startContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
        
        endContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
    }
    
    func setupOkButton() {
        let completionObserver = viewModel.fileLeaveResponseObserver { [weak self] message in
            guard let self = self else {return}
            Utilities.showGenericOkAlert(title: nil, message: message) { _ in
                self.delegate?.closeFileLeave(reloadLeaves: true)
            }
        } actionOnFail: { [weak self] message in
            guard let self = self else {return}
            Utilities.showGenericOkAlert(title: nil, message: message) { _ in
                self.delegate?.closeFileLeave(reloadLeaves: true)
            }
        }
        
        self.okButton.reactive.pressed = CocoaAction(viewModel.fileLeave(completionObserver: completionObserver))
    }

}
