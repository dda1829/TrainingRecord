//
//  AVFoundation.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/12.
//

import Foundation
import AVFoundation

class AVFoundationUse {
    let session = AVAudioSession.sharedInstance()
    var audioPlayer : AVAudioPlayer?
    static var share = AVFoundationUse()
    init() {    }
    func playTheSound (_ url: URL){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            let scene = UIApplication.shared.connectedScenes.first
                   // grab the scene delegate and give it a reference to this ViewController
                   if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                       sceneDelegate.videoViewController = self;
                   }
        }catch{
            print("Error")
        }
    }
    func stopTheSound() {
        audioPlayer?.stop()
    }
    
}
