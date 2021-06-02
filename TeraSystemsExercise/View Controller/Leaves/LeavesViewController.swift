//
//  LeavesViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit
import ReactiveSwift

class LeavesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    var addButton: UIBarButtonItem!
    
    var viewModel: LeavesViewModel!
    weak var delegate: LeavesDelegate?
    
    init(viewModel: LeavesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "LeaveDetailCell", bundle: nil), forCellReuseIdentifier: "leavesUsedCell")
        self.tableView.register(UINib(nibName: "RemainingLeavesCell", bundle: nil), forCellReuseIdentifier: "leavesRemainingCell")
        self.tableView.register(UINib(nibName: "LeavesRemainingHeaderCell", bundle: nil), forCellReuseIdentifier: "leavesRemainingHeader")
        self.tableView.register(UINib(nibName: "LeavesUsedHeaderCell", bundle: nil), forCellReuseIdentifier: "leavesUsedHeader")
        
        reloadTableView()
    }
    
    func reloadTableView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        
        self.viewModel.getLeaves {
            self.tableView.reloadData()
            self.navigationItem.rightBarButtonItem = self.addButton
            self.activityIndicator.stopAnimating()
        }
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Leaves"
        
        addButton = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(self.fileLeave))
        addButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = addButton
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func fileLeave() {
        self.delegate?.fileLeave()
    }
}
extension LeavesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leavesRemainingCell", for: indexPath) as! RemainingLeavesCell
            guard let leave = viewModel.remainingLeaves.value?[indexPath.row] else {
                return UITableViewCell()
            }
            
            for (type, amount) in leave {
                cell.type.text = type
                cell.amount.text = amount
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leavesUsedCell", for: indexPath) as! LeaveDetailCell
            guard let leaves = viewModel.leaves?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.dateLabel.reactive.text <~ leaves.map({
                if let dateTo = $0?.dateTo, let dateFrom = $0?.dateFrom {
                    return "\(dateFrom.stringDate(in: "MM/dd/yyyy", out: "MMMM d")) to \(dateTo.stringDate(in: "MM/dd/yyyy", out: "MMMM d"))"
                }
                else {
                    return $0?.dateFrom.stringDate(in: "MM/dd/yyyy", out: "MMMM d") ?? "N/A"
                }
            })
            cell.typeLabel.reactive.text <~ leaves.map({$0?.typeAbbreviation ?? "N/A"})
            cell.daysLabel.reactive.text <~ leaves.map({$0?.totalNumberOfDays()})
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.remainingLeaves.value?.count ?? 0
        }
        else {
            return viewModel.leaves?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "leavesRemainingHeader") as! LeavesRemainingHeaderCell
            return headerCell
        }
        else if section == 1 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "leavesUsedHeader") as! LeavesUsedHeaderCell
            return headerCell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 41.0
        }
        else {
            return 70.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60.0
        }
        else {
            return 85.0
        }
    }
}

protocol LeavesDelegate: AnyObject {
    func fileLeave()
}
