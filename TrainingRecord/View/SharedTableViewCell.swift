//
//  SharedTableViewCell.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/27.
//

import UIKit

class SharedTableViewCell: UITableViewCell {
    static let identifier = "SharedTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "SharedTableViewCell", bundle: nil)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
