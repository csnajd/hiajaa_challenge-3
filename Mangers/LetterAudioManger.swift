//
//  LetterAudioManger.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 09/12/2025.
//

import AVFoundation
internal import Combine

// MARK: - Letter Audio Manager
class LetterAudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    // Map Arabic letters to their sound file names
    // File names: Alaf.mp3, Baa.mp3, Taa.mp3, etc.
    private let letterSounds: [String: String] = [
        "أ": "Alaf",
        "ب": "Baa",
        "ت": "Taa",
        "ث": "Thaa",
        "ج": "Jeem",
        "ح": "Haa",
        "خ": "Khaa",
        "د": "Daal",
        "ذ": "Thaal",
        "ر": "Raa",
        "ز": "Zay",
        "س": "Seen",
        "ش": "Sheen",
        "ص": "Saad",
        "ض": "Daad",
        "ط": "Taa_heavy",
        "ظ": "Thaa_heavy",
        "ع": "Ayn",
        "غ": "Ghayn",
        "ف": "Faa",
        "ق": "Qaaf",
        "ك": "Kaaf",
        "ل": "Laam",
        "م": "Meem",
        "ن": "Noon",
        "هـ": "Haa_end",
        "و": "Waaw",
        "ي": "Yaa"
    ]
    
    func playLetterSound(for letter: String) {
        guard let soundName = letterSounds[letter] else {
            print("⚠️ No sound mapping for letter: \(letter)")
            return
        }
        
        // Try different extensions
        let extensions = ["mp3", "wav", "m4a", "aac", "caf", "MP3", "WAV", "M4A"]
        var soundURL: URL?
        
        for ext in extensions {
            if let url = Bundle.main.url(forResource: soundName, withExtension: ext) {
                soundURL = url
                print("✅ Found sound file: \(soundName).\(ext)")
                break
            }
        }
        
        // Also try lowercase version of the sound name
        if soundURL == nil {
            let lowercaseName = soundName.lowercased()
            for ext in extensions {
                if let url = Bundle.main.url(forResource: lowercaseName, withExtension: ext) {
                    soundURL = url
                    print("✅ Found sound file: \(lowercaseName).\(ext)")
                    break
                }
            }
        }
        
        guard let url = soundURL else {
            print("⚠️ Sound file '\(soundName)' not found for letter '\(letter)'")
            // Debug: List all files in bundle containing the sound name
            if let resourcePath = Bundle.main.resourcePath {
                do {
                    let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                    let matchingFiles = files.filter { $0.lowercased().contains(soundName.lowercased()) }
                    print("🔍 Files matching '\(soundName)': \(matchingFiles)")
                } catch {
                    print("❌ Could not list bundle files")
                }
            }
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
            print("🔊 Playing sound: \(url.lastPathComponent)")
        } catch {
            print("❌ Failed to play letter sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
}
