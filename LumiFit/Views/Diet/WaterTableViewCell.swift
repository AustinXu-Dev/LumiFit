//
//  WaterTableViewCell.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/29.
//

import UIKit

protocol WaterTableViewCellDelegate: AnyObject {
    func didTapButton(in cell: WaterTableViewCell)
}

class WaterTableViewCell: UITableViewCell {
    
    weak var delegate: WaterTableViewCellDelegate?
    @IBOutlet weak var waterConsumedLabel: UILabel!
    @IBOutlet weak var mlLabel: UILabel!
    @IBOutlet weak var glassGoal: UILabel!
    @IBOutlet weak var mlGoal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapButton(in: self)
    }
    
    func configure(with viewModel: WaterCalViewModel) {
        glassGoal.text = "of \(Int(viewModel.dailyGoal / 240)) glasses consumed"
        
        // Set the ml goal
        mlGoal.text = "/ \(Int(viewModel.dailyGoal)) ml"
        
        waterConsumedLabel.text = "\(Int(viewModel.glassCount))"
        mlLabel.text = "\(viewModel.totalMl) ml"
    }

}
