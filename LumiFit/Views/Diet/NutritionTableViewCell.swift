//
//  NutritionTableViewCell.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/29.
//

import UIKit

protocol NutritionTableViewCellDelegate: AnyObject {
    func didTapButton(in cell: NutritionTableViewCell)
}

class NutritionTableViewCell: UITableViewCell {
    
    weak var delegate: NutritionTableViewCellDelegate?
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var calorieProgressView: UIProgressView!
    
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
    
    func configure(with viewModel: CalorieViewModel) {
        calorieLabel.text = "\(viewModel.currentCalories)"
        // Ensure progress is between 0.0 and 1.0
        let progress = min(max(Float(viewModel.progress), 0.0), 1.0)
        calorieProgressView.progress = progress
    }


}
