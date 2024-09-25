//
//  WorkoutCardCell.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/9/18.
//

import UIKit

class WorkoutCardCell: UICollectionViewCell {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workoutIcon: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func configure(with model: WorkoutProcessModel){
        borderView.layer.cornerRadius = 20
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.gray.cgColor
        titleLabel.text = model.title
        workoutIcon.image = UIImage(named: model.image)
        countLabel.text = "\(model.count)"
        typeLabel.text = model.type
    }
    
}
