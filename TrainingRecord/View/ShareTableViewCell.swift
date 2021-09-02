//
//  TableViewCell.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/8.
//

import UIKit
import Foundation

protocol ShareTableViewCellDelegate{
    func shareTableViewCellDidTapGood(_ sender: ShareTableViewCell)
    func shareTableViewCellDidTapNormal(_ sender: ShareTableViewCell)
    func shareTableViewCellDidTapBad(_ sender: ShareTableViewCell)
}


class ShareTableViewCell: UITableViewCell {
    static let identifier = "ShareTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ShareTableViewCell", bundle: nil)
    }
    private let backGroundImage = UIImage(named: "selectedBackground")
    private let noSelectbackGroundImage = UIImage(named: "noselectBackground")
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var normalBtn: UIButton!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    var delegate: ShareTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        goodBtn.setBackgroundImage(backGroundImage, for: .selected)
        goodBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
        normalBtn.setBackgroundImage(backGroundImage, for: .selected)
        normalBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
        badBtn.setBackgroundImage(backGroundImage, for: .selected)
        badBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
    }
    func ratingBtnRecord(_ record: String){
        switch record {
        case "Good":
            goodBtn.setBackgroundImage(backGroundImage, for: .normal)
            normalBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
            badBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
        case "Normal":
            goodBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
            normalBtn.setBackgroundImage(backGroundImage, for: .normal)
            badBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
        case "Bad":
            goodBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
            normalBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
            badBtn.setBackgroundImage(backGroundImage, for: .normal)
        default:
            goodBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
            normalBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
            badBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
            print("wrong")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
    
    @IBAction func goodBtnPressed(_ sender: Any) {
        delegate?.shareTableViewCellDidTapGood(self)
        
        goodBtn.setBackgroundImage(backGroundImage, for: .normal)
        normalBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
        badBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)

    }
    @IBAction func normalBtnPressed(_ sender: Any) {
        delegate?.shareTableViewCellDidTapNormal(self)
        goodBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
        normalBtn.setBackgroundImage(backGroundImage, for: .normal)
        badBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
    }
    @IBAction func badBtnPressed(_ sender: Any) {
        delegate?.shareTableViewCellDidTapBad(self)
        goodBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
        normalBtn.setBackgroundImage(noSelectbackGroundImage, for: .normal)
        badBtn.setBackgroundImage(backGroundImage, for: .normal)
    }
}
