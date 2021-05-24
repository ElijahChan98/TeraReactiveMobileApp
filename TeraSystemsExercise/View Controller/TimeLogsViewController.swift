//
//  TimeLogsViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/24/21.
//

import UIKit

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
        let addButton = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(self.addLog))
        addButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = addButton
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func addLog() {
    }
    
}

extension TimeLogsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TimeLogCell
        guard let timeLog = viewModel.timeLogs?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.dateLabel.text = timeLog.date
        cell.inLabel.text = timeLog.timeIn ?? "N/A"
        cell.outLabel.text = timeLog.timeOut ?? "N/A"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.timeLogs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

protocol TimeLogsDelegate: AnyObject {
    
}
