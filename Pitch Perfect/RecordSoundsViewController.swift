//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Francisco Barrios on 02-04-15.
//  Copyright (c) 2015 Francisco Barrios. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButtonImage: UIButton!
    @IBOutlet weak var stopButtonImage: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingInProgress.text = "Tap to record"
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingInProgress.hidden = false
        recordingInProgress.text = "Tap to record"
        stopButtonImage.hidden = true
        recordButtonImage.enabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RecordAudio(sender: UIButton) {

        stopButtonImage.hidden = false
        recordingInProgress.hidden = false
        recordingInProgress.text = "Recording ..."
        recordButtonImage.enabled = false
      
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {

            if(flag){
                recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, recordingFilePath: recorder.url)
                self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            }else{
                println("Error while recording!!!")
                recordButtonImage.enabled = true
                stopButtonImage.hidden = true
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func StopRecordingAudio(sender: UIButton) {

        recordingInProgress.hidden = true
        stopButtonImage.hidden = true
        recordButtonImage.enabled = true
        audioRecorder.stop()

        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}



