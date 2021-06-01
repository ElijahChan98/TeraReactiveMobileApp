//
//  RemainingLeavesCell.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 6/1/21.
//

import UIKit

class RemainingLeavesCell: UITableViewCell {
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
