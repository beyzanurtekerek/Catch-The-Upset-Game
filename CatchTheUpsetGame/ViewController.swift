//
//  ViewController.swift
//  CatchTheUpsetGame
//
//  Created by Beyza Nur Tekerek on 30.07.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // variables
    var score = 0
    var timer = Timer()
    var counter = 0 // bu counter time labelin icerisinde gözükecek
    var upsetArray = [UIImageView]()
    var hideTimer = Timer()
    var highScore = 0
    
    // views
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var upset1: UIImageView!
    @IBOutlet weak var upset2: UIImageView!
    @IBOutlet weak var upset3: UIImageView!
    @IBOutlet weak var upset4: UIImageView!
    @IBOutlet weak var upset5: UIImageView!
    @IBOutlet weak var upset6: UIImageView!
    @IBOutlet weak var upset7: UIImageView!
    @IBOutlet weak var upset8: UIImageView!
    @IBOutlet weak var upset9: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Score: \(score)" // score label da skoru gösterdik
        
        // highscore check
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "Highscore: \(highScore)"
        }
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highScoreLabel.text = "Highscore: \(highScore)"
        }
        
        // images
        upset1.isUserInteractionEnabled = true // kullanıcı tıklaması aktif
        upset2.isUserInteractionEnabled = true
        upset3.isUserInteractionEnabled = true
        upset4.isUserInteractionEnabled = true
        upset5.isUserInteractionEnabled = true
        upset6.isUserInteractionEnabled = true
        upset7.isUserInteractionEnabled = true
        upset8.isUserInteractionEnabled = true
        upset9.isUserInteractionEnabled = true
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore)) // tanıyıcılar
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))

        upset1.addGestureRecognizer(recognizer1) // upsetlere jest algılayıcıları atadık
        upset2.addGestureRecognizer(recognizer2)
        upset3.addGestureRecognizer(recognizer3)
        upset4.addGestureRecognizer(recognizer4)
        upset5.addGestureRecognizer(recognizer5)
        upset6.addGestureRecognizer(recognizer6)
        upset7.addGestureRecognizer(recognizer7)
        upset8.addGestureRecognizer(recognizer8)
        upset9.addGestureRecognizer(recognizer9)
        
        upsetArray = [upset1, upset2, upset3, upset4, upset5, upset6, upset7, upset8, upset9]
        
        
        // timers
        counter = 20
        timeLabel.text = "\(counter)" // veya String(counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true) // bununla kac saniyede bir ne yapacagımızı yazabiliyoruz
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideUpset), userInfo: nil, repeats: true)
        
        hideUpset()
        
    }
    
    @objc func hideUpset() {
        for upset in upsetArray { // bu arraydeki her elemanı alıp tek tek upset e atıyor
            upset.isHidden = true
        }
        let random = Int(arc4random_uniform(UInt32(upsetArray.count - 1)))
        upsetArray[random].isHidden = false // gizlenmis upsetleri acacak
        
    }

    @objc func increaseScore() {
        score += 1 // tıklama fonksiyonu icin her tıklandıgında skoru arttıracagız
        scoreLabel.text = "Score: \(score)" // skor güncellensin diye tekrar yazdık
    }
    
    @objc func countDown() {
        counter -= 1
        timeLabel.text = String(counter)
        
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            
            for upset in upsetArray { // bu arraydeki her elemanı alıp tek tek upset e atıyor
                upset.isHidden = true
            } // tekrar görünmez hale gelebilsin diye buraya da ekledik
            
            
            // high score
            if self.score > self.highScore {
                self.highScore = self.score
                highScoreLabel.text = "Highscore: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highscore")
            }
            
            
            // alert
            let alert = UIAlertController(title: "Time's Over", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            // handler bisey olsun istiyosak kullanılır mesela:
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
                
                // replay func - skoru ve counteri resetlemis olduk
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 20
                self.timeLabel.text = String(self.counter)
                // baslarına self koyarak buradan kullanacagımızı anlatıyoruz - tekrar sıfırladık timerlarımızı
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true) // bununla kac saniyede bir ne yapacagımızı yazabiliyoruz
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideUpset), userInfo: nil, repeats: true)
                
            }
            
            // alertleri ekledik
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
            
        }
    }

}

