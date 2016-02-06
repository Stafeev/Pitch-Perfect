//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Artem Stafeev on 3/24/15.
//  Copyright (c) 2015 Artem Stafeev. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate=true
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playFastAudio(sender: UIButton) {
        playWithSpeed(1.5,currentTime: 0.0)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    @IBAction func playSlowAudio(sender: UIButton) {
        playWithSpeed(0.5,currentTime: 0.0)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func stopAndResetAudioPlayback() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    func playWithSpeed(rate:Float, currentTime:Double) {
        stopAndResetAudioPlayback()
        audioPlayer.rate=rate
        audioPlayer.currentTime=currentTime
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAndResetAudioPlayback()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
}
