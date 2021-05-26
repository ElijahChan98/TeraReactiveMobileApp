//
//  TimeLogDetailsViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/25/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class TimeLogDetailsViewController: UIViewController {
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var timeInStack: UIStackView!
    @IBOutlet weak var timeIn: UILabel!
    @IBOutlet weak var timeOut: UILabel!
    
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var breakTimeStack: UIStackView!
    @IBOutlet weak var breakIn: UILabel!
    @IBOutlet weak var breakOut: UILabel!
    
    var viewModel: TimeLogDetailsViewModel!
    
    init(viewModel: TimeLogDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        updateLabels()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = viewModel.getDateInFormat("MMMM d")
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func updateLabels() {
        self.viewModel.timeLog.map { timeLog in
            self.timeIn.reactive.text <~ timeLog.map({$0.timeIn?.stringDate(in: "HH:mm:ss", out: "h:mm a") ?? "N/A"})
            self.timeIn.reactive.textColor <~ timeLog.map({
                $0.timeIn == nil ? UIColor.red : UIColor.black
            })
            
            self.timeOut.reactive.text <~ timeLog.map({$0.timeOut?.stringDate(in: "HH:mm:ss", out: "h:mm a") ?? "N/A"})
            self.timeOut.reactive.textColor <~ timeLog.map({
                $0.timeOut == nil ? UIColor.red : UIColor.black
            })
            
            self.breakIn.reactive.text <~ timeLog.map({$0.breakIn?.stringDate(in: "HH:mm:ss", out: "h:mm a") ?? "N/A"})
            self.breakIn.reactive.textColor <~ timeLog.map({
                $0.breakIn == nil ? UIColor.red : UIColor.black
            })
            
            self.breakOut.reactive.text <~ timeLog.map({$0.breakOut?.stringDate(in: "HH:mm:ss", out: "h:mm a") ?? "N/A"})
            self.breakOut.reactive.textColor <~ timeLog.map({
                $0.breakOut == nil ? UIColor.red : UIColor.black
            })
        }
    }
}
