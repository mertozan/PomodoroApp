//
//  ViewController.swift
//  PomodoroApp
//
//  Created by Mert ÖZAN on 25.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    
    // Timer değişkenleri
    var timer: Timer?
    var totalTime: Int = 25 * 60 // 25 dakika (1500 saniye)
    var currentTime: Int = 0
    var isTimerRunning = false
    var isTimerPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if isTimerPaused {
            resumeTimer()
        } else {
            pauseTimer()
        }
    }
    
    // Başlangıç UI ayarları
    func setupUI() {
        timerLabel.text = formatTime(totalTime)
        progressView.progress = 0.0
        startButton.setTitle("Başlat", for: .normal)
        pauseButton.setTitle("Duraklat", for: .normal)
        pauseButton.isHidden = true // Pause butonu başlangıçta gizli
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
        isTimerRunning = false
        isTimerPaused = false
        startButton.setTitle("Başlat", for: .normal)
        pauseButton.isHidden = true // Pause butonu gizlenir
        timer?.invalidate()
        timer = nil
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
    }
    
    // Zamanı MM:SS formatına çevirme
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

