import AVFoundation
import SwiftUI

class SoundManager {
    static let shared = SoundManager()
    
    var bgmPlayer: AVAudioPlayer?
    var buzzPlayer: AVAudioPlayer?
    var sfxPlayers: [AVAudioPlayer] = []
    
   
    var bgmVolume: Float   = 0.02   
    var sfxVolume: Float   = 0.15   
    var buzzVolume: Float  = 0.38   
    var chimeVolume: Float = 0.50   
    
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    

    func playBGM(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "m4a") else { return }
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1 
            bgmPlayer?.volume = bgmVolume 
            bgmPlayer?.play()
        } catch {
            print("BGM Error: \(error)")
        }
    }
    
   
    func playSFX(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "m4a") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            
       
            if filename == "winchime" {
                player.volume = chimeVolume
            } else {
                player.volume = sfxVolume
            }
            
            player.play()
            sfxPlayers.append(player)
            sfxPlayers.removeAll { !$0.isPlaying }
        } catch {
            print("SFX Error: \(error)")
        }
    }
    
    func startBuzz() {
        if buzzPlayer?.isPlaying == true { return } 
        guard let url = Bundle.main.url(forResource: "buzz", withExtension: "m4a") else { return }
        do {
            buzzPlayer = try AVAudioPlayer(contentsOf: url)
            buzzPlayer?.numberOfLoops = -1
            buzzPlayer?.volume = buzzVolume 
            buzzPlayer?.play()
        } catch {
            print("Buzz Error: \(error)")
        }
    }
    
    func stopBuzz() {
        buzzPlayer?.stop()
    }
    
    func playHaptic() {
#if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
#endif
    }
}
