//
//  VideoViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/25.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    
    var player: AVPlayer?
    var playerController: AVPlayerViewController?
    var currentVideoIndex = 0
    var pauseButton: UIButton? // Reference to pause/play button
    
    // Video URLs
    var videoURLs: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the player
        setupPlayer()
        
        // Create and layout buttons in a stack
        setupButtons()
    }
    
    func setupPlayer() {
        player = AVPlayer(url: videoURLs[currentVideoIndex])
        playerController = AVPlayerViewController()
        playerController?.player = player
        
        // Add the player as a child view controller
        self.addChild(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.didMove(toParent: self)
        
        playerController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerController!.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            playerController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerController!.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33)
        ])
    }
    
    func playCurrentVideo() {
        player?.pause()
        player = AVPlayer(url: videoURLs[currentVideoIndex])
        playerController?.player = player
        player?.play()
    }
    
    func setupButtons() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: configuration), for: .normal)
        backButton.tintColor = .systemBlue
        backButton.addTarget(self, action: #selector(previousVideo), for: .touchUpInside)
        
        let nextButton = UIButton(type: .system)
        nextButton.setImage(UIImage(systemName: "arrow.forward.circle.fill", withConfiguration: configuration), for: .normal)
        nextButton.tintColor = .systemBlue
        nextButton.addTarget(self, action: #selector(nextVideo), for: .touchUpInside)
        
        pauseButton = UIButton(type: .system)
        pauseButton?.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: configuration), for: .normal)
        pauseButton?.tintColor = .systemRed
        pauseButton?.addTarget(self, action: #selector(pauseVideo), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [backButton, pauseButton!, nextButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .center
        buttonStack.spacing = 30
        
        self.view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonStack.topAnchor.constraint(equalTo: playerController!.view.bottomAnchor, constant: 30)
        ])
        
        [backButton, nextButton, pauseButton!].forEach { button in
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 100),
                button.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
    
    @objc func nextVideo() {
        if currentVideoIndex < videoURLs.count - 1 {
            currentVideoIndex += 1
            playCurrentVideo()
        }
    }
    
    @objc func previousVideo() {
        if currentVideoIndex > 0 {
            currentVideoIndex -= 1
            playCurrentVideo()
        }
    }
    
    @objc func pauseVideo() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        
        if player?.timeControlStatus == .playing {
            player?.pause()
            pauseButton?.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: configuration), for: .normal)
        } else {
            player?.play()
            pauseButton?.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: configuration), for: .normal)
        }
    }
}

