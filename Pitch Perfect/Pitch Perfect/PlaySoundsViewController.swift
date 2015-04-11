//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eugene Voronov on 2015-04-07.
//  Copyright (c) 2015 Eugene Voronov. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    // To be passed from the recording view.
    var receivedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playAudioWithVariableSpeed(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        playAudioWithVariableSpeed(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
       playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Play the recording based on the passed-in rate.
    func playAudioWithVariableSpeed(rate: Float) {
        stopPlay(stopButton)
        
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }

    // Play the recording based on the passed-in pitch.
    func playAudioWithVariablePitch(pitch: Float){
        stopPlay(stopButton)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
