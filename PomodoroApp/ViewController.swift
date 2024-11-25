//
//  ViewController.swift
//  PomodoroApp
//
//  Created by Mert ÖZAN on 25.11.2024.
//

import UIKit
import AVFoundation // Ses dosyalarını oynatmak için

class ViewController: UIViewController {
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    
    // Timer değişkenleri
    var timer: Timer?
    var totalTime: Int = 25 * 60
    var currentTime: Int = 0
    var isTimerRunning = false
    var isTimerPaused = false
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        playSound(named: "ding")
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        playSound(named: "click")
        if isTimerPaused {
            resumeTimer()
        } else {
            pauseTimer()
        }
    }
    
    func playSound(named soundName: String) {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Ses dosyası çalınamadı: \(error.localizedDescription)")
            }
        } else {
            print("Ses dosyası bulanamadı: \(soundName).mp3")
        }
    }
    
    // Başlangıç UI ayarları
    func setupUI() {
        
        // Timer Label Ayarları
        timerLabel.text = formatTime(totalTime)
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .bold)
        timerLabel.textColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        timerLabel.textAlignment = .center
        
        // Progress View Ayarları
        progressView.progress = 0.0
        progressView.progressTintColor = UIColor(red: 76/255, green: 201/255, blue: 133/255, alpha: 1.0)
        progressView.trackTintColor = UIColor(red: 30/255, green: 36/255, blue: 48/255, alpha: 1.0)
        progressView.layer.cornerRadius = 8
        progressView.clipsToBounds = true
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        
        // Başlat Butonu Ayarları
        startButton.setTitle("Başlat", for: .normal)
        startButton.backgroundColor = UIColor(red: 56/255, green: 150/255, blue: 230/255, alpha: 1.0)
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOpacity = 0.2
        startButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        // Duraklat Butonu Ayarları
        pauseButton.setTitle("Duraklat", for: .normal)
        pauseButton.backgroundColor = UIColor(red: 255/255, green: 159/255, blue: 64/255, alpha: 1.0)
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.layer.cornerRadius = 8
        pauseButton.layer.shadowColor = UIColor.black.cgColor
        pauseButton.layer.shadowOpacity = 0.2
        pauseButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        pauseButton.isHidden = true
    }
    
    
    // Timer başlatma
    func startTimer() {
        isTimerRunning = true
        isTimerPaused = false
        startButton.setTitle("Durdur", for: .normal)
        pauseButton.isHidden = false // Pause butonu görünür
        currentTime = totalTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    // Timer durdurma
    func stopTimer() {
        playSound(named: "click")
        isTimerRunning = false
        isTimerPaused = false
        startButton.setTitle("Başlat", for: .normal)
        pauseButton.isHidden = true // Pause butonu gizlenir
        timer?.invalidate()
        timer = nil
        currentTime = totalTime
        timerLabel.text = formatTime(totalTime)
        progressView.progress = 0.0
        progressView.progressTintColor = UIColor(red: 76/255, green: 201/255, blue: 133/255, alpha: 1.0)
        progressView.trackTintColor = UIColor(red: 30/255, green: 36/255, blue: 48/255, alpha: 1.0)
        
    }
    
    // Timer duraklatma
    func pauseTimer() {
        isTimerPaused = true
        pauseButton.setTitle("Devam Et", for: .normal)
        timer?.invalidate() // Timer'ı duraklatır
    }
    
    // Timer devam ettirme
    func resumeTimer() {
        isTimerPaused = false
        pauseButton.setTitle("Duraklat", for: .normal)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    // Timer güncelleme
    func updateTimer() {
        guard currentTime > 0 else {
            timerDidFinish()
            return
        }
        currentTime -= 1
        timerLabel.text = formatTime(currentTime)
        progressView.progress = Float(totalTime - currentTime) / Float(totalTime)
    }
    
    // Timer tamamlandığında
    func timerDidFinish() {
        stopTimer()
        timerLabel.text = "Tamamlandı!"
        progressView.progress = 1.0
        playSound(named: "finish")
    }
    
    // Zamanı MM:SS formatına çevirme
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

