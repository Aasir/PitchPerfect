//
//  RecordSoundsController.swift
//  Pitch Perfect
//
//  Created by Aasiruddin Walajahi on 1/17/15.
//  Copyright (c) 2015 Aasiruddin Walajahi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true;
        recordButton.enabled = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("START YO");
        
        recordButton.enabled = false
        recordingInProgress.hidden = false;
        stopButton.hidden = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            //TODO - Step 2 - Perform a Seque
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaysSoundsViewController = segue.destinationViewController as PlaysSoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }

    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true;
        stopButton.hidden = true;
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

        println("STOP YO");
    }
}

