//
//  TimeLogsViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/24/21.
//

import UIKit
import ReactiveSwift

class TimeLogsViewController: UIViewController {
    @IBOutlet weak var labelView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TimeLogsViewModel!
    weak var delegate: TimeLogsDelegate?
    
    init(viewModel: TimeLogsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "TimeLogCell", bundle: nil), forCellReuseIdentifier: "Cell")
        reloadTableView()
    }
    
    func reloadTableView() {
        self.viewModel.fetchTimeLogs {
            self.tableView.reloadData()
        }
    }
    
    func setupViews() {
        labelView.layer.borderWidth = 1
        labelView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Time Logs"
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        let addButton = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(self.addLog))
        addButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = addButton
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func addLog() {
        delegate?.addTimeLog()
    }
    
}

extension TimeLogsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TimeLogCell
        guard let timeLog = viewModel.timeLogs?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.dateLabel.reactive.text <~ timeLog.map({$0?.date.stringDate(in: "MM/dd/yyyy", out: "MMMM d")})
        
        cell.inLabel.reactive.text <~ timeLog.map({$0?.timeIn?.stringDate(in: "HH:mm:ss", out: "h:mm a") ?? "N/A"})
        cell.inLabel.reactive.textColor <~ timeLog.map({
            $0?.timeIn == nil ? UIColor.red : UIColor.black
        })
        
        cell.outLabel.reactive.text <~ timeLog.map({$0?.timeOut?.stringDate(in: "HH:mm:ss", out: "h:mm a") ?? "N/A"})
        cell.outLabel.reactive.textColor <~ timeLog.map({
            $0?.timeOut == nil ? UIColor.red : UIColor.black
        })
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.timeLogs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let timeLog = viewModel.timeLogs?[indexPath.row].value else {
            return
        }
        delegate?.showTimeLogDetails(timeLog: timeLog)
    }
}

protocol TimeLogsDelegate: AnyObject {
    func showTimeLogDetails(timeLog: TimeLog)
    func addTimeLog()
}
