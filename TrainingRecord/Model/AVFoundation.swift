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
    private var audioPlayer : AVAudioPlayer?
    static var share = AVFoundationUse()
    init() {    }
    func playTheSound (_ url: URL){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }catch{
            print("Error")
        }
    }
    func stopTheSound() {
        audioPlayer?.stop()
    }
    
}
