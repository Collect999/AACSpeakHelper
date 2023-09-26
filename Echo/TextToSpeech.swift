//
//  TextToSpeech.swift
//  Echo
//
//  Created by Gavin Henderson on 02/08/2023.
//

import Foundation
import AVKit

// This is a basic wrapper around Apples TTS
class TextToSpeech: NSObject, AVSpeechSynthesizerDelegate {
    var synthesizer = AVSpeechSynthesizer()
    var mainVoice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.en-GB.Daniel")
    var promptVoice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.en-AU.Karen")
    var callback: (() -> Void)?
    
    override init() {
        super.init()
        self.synthesizer.delegate = self
        
        // This makes it work in silent mode by setting the audio to playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch let error {
            print("This error message from SpeechSynthesizer \(error.localizedDescription)")
        }
    }

    func speak(_ text: String, voiceType: VoiceType = .prompt, cb: (() -> Void)?) {
        let utterance = AVSpeechUtterance(string: text)

        if voiceType == .main {
            utterance.voice = mainVoice
        } else if voiceType == .prompt {
            utterance.voice = promptVoice
        }
        
        self.synthesizer.stopSpeaking(at: .immediate)
        
        if cb != nil {
            self.callback = cb
        }
        
        self.synthesizer.speak(utterance)
    }
    
    enum VoiceType {
        case prompt, main
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        if let unwappedCallback = self.callback {
            unwappedCallback()
        }
        
        self.callback = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let unwappedCallback = self.callback {
            unwappedCallback()
        }
        
        self.callback = nil
    }
}
