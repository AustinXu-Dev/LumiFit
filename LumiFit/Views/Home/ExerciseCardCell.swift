//
//  ExerciseCardCell.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/25.
//

import UIKit

class ExerciseCardCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private let durationLabel = UILabel()
    private let caloriesLabel = UILabel()
    private let playButton = UIButton(type: .system)
    private let illustrationImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAutoLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupAutoLayout()
    }

    private func setupView() {
        layer.cornerRadius = 20
        clipsToBounds = true

        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)

        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.textColor = .white
        contentView.addSubview(durationLabel)

        caloriesLabel.font = UIFont.systemFont(ofSize: 14)
        caloriesLabel.textColor = .white
        contentView.addSubview(caloriesLabel)

        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = .white
        playButton.setTitleColor(.black, for: .normal)
        playButton.layer.cornerRadius = 10
        contentView.addSubview(playButton)

        illustrationImageView.contentMode = .scaleAspectFit
        contentView.addSubview(illustrationImageView)
    }

    private func setupAutoLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        illustrationImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            caloriesLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 5),
            caloriesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 40),

            illustrationImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            illustrationImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            illustrationImageView.widthAnchor.constraint(equalToConstant: 100),
            illustrationImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func configure(with model: ExerciseCardModel) {
        titleLabel.text = model.title
        durationLabel.text = model.duration
        caloriesLabel.text = model.calories
        illustrationImageView.image = model.image
        contentView.backgroundColor = model.backgroundColor
    }
}
