//
//  LeavesRemainingHeaderCell.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 6/2/21.
//

import UIKit

class LeavesRemainingHeaderCell: UITableViewCell {
    @IBOutlet weak var leavesRemainingContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leavesRemainingContainerView.addTopBorder(with: .gray, andWidth: 0.5)
        leavesRemainingContainerView.addBottomBorder(with: .gray, andWidth: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
