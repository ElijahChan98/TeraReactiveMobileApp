//
//  LeavesHeaderCell.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 6/2/21.
//

import UIKit

class LeavesUsedHeaderCell: UITableViewCell {
    @IBOutlet weak var leavesUsedLabel: UILabel!
    @IBOutlet weak var leavesUsedContainerView: UIView!
    @IBOutlet weak var datesContainerLabel: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leavesUsedContainerView.addTopBorder(with: .gray, andWidth: 0.5)
        datesContainerLabel.addTopBorder(with: .gray, andWidth: 0.5)
        datesContainerLabel.addBottomBorder(with: .gray, andWidth: 0.5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
