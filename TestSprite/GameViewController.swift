//
//  GameViewController.swift
//  TestSprite
//
//  Created by Quentin Duquesne on 09/02/2020.
//  Copyright © 2020 Quentin Duquesne. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVKit

class GameViewController: UIViewController {
    
    let videoView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneNode = GameScene(size: view.frame.size)
        let skView = SKView(frame: view.frame)
        
        view.backgroundColor = .green
        
        let videoView = UIView(frame: .zero)
        videoView.backgroundColor = .blue
        
        view.addSubview(videoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.heightAnchor.constraint(equalToConstant: 200),
            videoView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
//        view.addSubview(skView)
//
//        if let view = skView as! SKView? {
//            view.allowsTransparency = true
//            view.backgroundColor = .clear
//            view.presentScene(sceneNode)
//            view.ignoresSiblingOrder = true
//            //view.showsPhysics = true
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        let videoURL = Bundle.main.url(forResource: "dog", withExtension: "mp4")
        let asset = AVAsset(url: videoURL!)
        let playerItem = AVPlayerItem(asset: asset)
        
        let player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        
        videoView.layer.addSublayer(playerLayer)
        player.play()
        
//        let videoControler = AVPlayerViewController()
//        videoControler.player = player
//
//        self.present(videoControler, animated: false, completion: nil)
        
    }
    


}
