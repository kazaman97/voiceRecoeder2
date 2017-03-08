//
//  ViewController.swift
//  voiceRecorder2
//
//  Created by Kazama Ryusei on 2017/03/08.
//  Copyright © 2017年 Malfoy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var voicePlayer: AVAudioPlayer!
    
    @IBOutlet weak var recordLabel: UIButton!
    
    @IBAction func recordButton(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func playButton(_ sender: Any) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            let sound = try AVAudioPlayer(contentsOf: audioFilename)
            voicePlayer = sound
            sound.play()
        } catch {
            // couldn't load file
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
        
    }
    
    
    func finishRecording(success: Bool){
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordLabel.setTitle("再録音", for: .normal)
        } else {
            recordLabel.setTitle("録音", for: .normal)
            // recording failed
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in DispatchQueue.main.async {
                if allowed {
                    // true to record!
                } else {
                    // failed to record!
                }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

