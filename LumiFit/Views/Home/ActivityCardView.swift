//
//  ActivityCardView.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit

class ActivityCardView: UIView {

    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Set up background circle layer
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.lineWidth = 5
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        backgroundLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY - 10)
        layer.addSublayer(backgroundLayer)
        
        // Set up progress circle layer
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 5
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY - 10)
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:-3)
        ])
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
    func configure(image: UIImage, title: String, backgroundColor: UIColor, progress: CGFloat) {
        imageView.image = image
        titleLabel.text = title
        self.backgroundColor = backgroundColor
        setProgress(to: progress)
    }
    
    private func setProgress(to progress: CGFloat) {
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = UIColor.white.cgColor
    }
    
    func updateProgress(to newProgress: CGFloat, withAnimation: Bool = true, duration: CFTimeInterval = 0.5) {
            if withAnimation {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.fromValue = progressLayer.strokeEnd
                animation.toValue = newProgress
                animation.duration = duration
                progressLayer.add(animation, forKey: "progressAnimation")
            }
            
            // Update the progress value
            progressLayer.strokeEnd = newProgress
        }
    
}
