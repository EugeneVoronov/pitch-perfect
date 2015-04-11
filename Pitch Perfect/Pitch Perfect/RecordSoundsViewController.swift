//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eugene Voronov on 2015-04-06.
//  Copyright (c) 2015 Eugene Voronov. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var bntMicrophone: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func startRecording(sender: UIButton) {
        lblRecording.text = "Recording"
        btnStop.hidden = false
        bntMicrophone.enabled = false
        record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        reset()
        
        audioRecorder.stop()
        AVAudioSession.sharedInstance().setActive(false, error: nil)
    }
    
    func reset() {
        lblRecording.text = "Tap to Record"
        btnStop.hidden = true
        bntMicrophone.enabled = true
    }
    
    func record() {
        
        // get dir for the recording file to be stored in.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // construct the filename for the recording.
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray as [AnyObject])
        println(filePath)
        
        // handle recording house-keeping.
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // record.
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self // hook-up delegate, so that audioRecorderDidFinishRecording gets called.
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url!, title: recorder.url!.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            playSVC.receivedAudio = sender as! RecordedAudio
        }
    }
}