//
//  LeavesViewController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit
import ReactiveSwift

class LeavesViewController: UIViewController {
    @IBOutlet weak var leavesRemainingContainerView: UIView!
    @IBOutlet weak var leavesUsedContainerView: UIView!
    @IBOutlet weak var dateContainerView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leavesRemainingTableView: UITableView!
    
    var leavesRemainingController: LeavesRemainingTableController!
    
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
        setupViews()
        self.leavesRemainingController = LeavesRemainingTableController(viewModel: self.viewModel)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "LeaveDetailCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        self.leavesRemainingTableView.delegate = leavesRemainingController
        self.leavesRemainingTableView.dataSource = leavesRemainingController
        self.leavesRemainingTableView.register(UINib(nibName: "RemainingLeavesCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        reloadTableView()
    }
    
    func reloadTableView() {
        self.viewModel.getLeaves {
            self.tableView.reloadData()
            self.leavesRemainingTableView.reloadData()
        }
    }
    
    func setupViews() {
        leavesRemainingContainerView.addTopBorder(with: UIColor.gray, andWidth: 0.5)
        leavesRemainingContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
        
        leavesUsedContainerView.addTopBorder(with: .gray, andWidth: 0.5)
        
        dateContainerView.addTopBorder(with: UIColor.gray, andWidth: 0.5)
        dateContainerView.addBottomBorder(with: UIColor.gray, andWidth: 0.5)
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Leaves"
        
        let addButton = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(self.fileLeave))
        addButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = addButton
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func fileLeave() {
        self.delegate?.fileLeave()
    }
}
extension LeavesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeaveDetailCell
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.leaves?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
}

protocol LeavesDelegate: AnyObject {
    func fileLeave()
}
