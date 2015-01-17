//
//  PlaysSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aasiruddin Walajahi on 1/17/15.
//  Copyright (c) 2015 Aasiruddin Walajahi. All rights reserved.
//

import UIKit
import AVFoundation

class PlaysSoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//            
//        }
//        else{
//            println("File not Found.")
//        }

        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true;
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func slowAudio(sender: UIButton) {
        stopButton.hidden = false;
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }

    @IBAction func fastAudio(sender: UIButton) {
        stopButton.hidden = false;
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    @IBAction func chipmunkAudio(sender: UIButton){
        stopButton.hidden = false;
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthvaderAudio(sender: UIButton) {
        stopButton.hidden = false;
        playAudioWithVariablePitch(-1000)
    }
    //New Function
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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

    
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        stopButton.hidden = true;
    }
}
