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
        // Initialize the player with the first video URL
        player = AVPlayer(url: videoURLs[currentVideoIndex])
        playerController = AVPlayerViewController()
        playerController?.player = player
        
        // Add the player as a child view controller
        self.addChild(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.didMove(toParent: self)
        
        // Set up the player's view with Auto Layout
        playerController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints: One third of the screen height, full width, and positioned at the top
        NSLayoutConstraint.activate([
            playerController!.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            playerController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerController!.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33)  // One third of the screen
        ])
    }
    
    func playCurrentVideo() {
        player?.pause()
        player = AVPlayer(url: videoURLs[currentVideoIndex])
        playerController?.player = player
        player?.play()
    }
    
    func setupButtons() {
        // Back Button
        let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: configuration), for: .normal)
        backButton.tintColor = .systemBlue
        
        backButton.addTarget(self, action: #selector(previousVideo), for: .touchUpInside)
        
        // Next Button
        let nextButton = UIButton(type: .system)
        nextButton.setImage(UIImage(systemName: "arrow.forward.circle.fill", withConfiguration: configuration), for: .normal)
        nextButton.tintColor = .systemBlue
        nextButton.addTarget(self, action: #selector(nextVideo), for: .touchUpInside)
        
        // Pause Button
        let pauseButton = UIButton(type: .system)
        pauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: configuration), for: .normal)
        pauseButton.tintColor = .systemRed
        pauseButton.addTarget(self, action: #selector(pauseVideo), for: .touchUpInside)
        
        // Create a horizontal stack view to arrange the buttons
        let buttonStack = UIStackView(arrangedSubviews: [backButton, pauseButton, nextButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .center
        buttonStack.spacing = 30  // Reduced spacing between buttons
        
        // Add the stack view to the main view
        self.view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for the stack view
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonStack.topAnchor.constraint(equalTo: playerController!.view.bottomAnchor, constant: 30)
        ])
        
        // Make the buttons larger by setting width and height constraints
        [backButton, nextButton, pauseButton].forEach { button in
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 100),  // Slightly smaller width
                button.heightAnchor.constraint(equalToConstant: 100)  // Slightly smaller height
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
       if player?.timeControlStatus == .playing {
           player?.pause()
       } else {
           player?.play()
       }
    }
}



