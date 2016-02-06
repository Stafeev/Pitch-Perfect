//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Artem Stafeev on 3/11/15.
//  Copyright (c) 2015 Artem Stafeev. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden=false
        print("in recordAudio")
        recordingInProgress.hidden=false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        var session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
            AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
            AVNumberOfChannelsKey : NSNumber(int: 1),
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
        
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: recordSettings )
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag)
        {
        recordedAudio=RecordedAudio()
        recordedAudio.filePathUrl=recorder.url
        recordedAudio.title=recorder.url.lastPathComponent
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            print("Recording was not successful")
            recordButton.enabled=true
            stopButton.hidden=true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="stopRecording")
        {
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data=sender as! RecordedAudio
            playSoundVC.receivedAudio=data
        }
    }

    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden=true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true
        recordButton.enabled = true
    }
}

