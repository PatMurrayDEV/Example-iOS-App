//
//  ViewController.swift
//  QuizApp
//
//  Created by Patrick Murray on 23/10/2016.
//
//

import UIKit
import AudioToolbox


class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var letterCountLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    
    let quiz = QuizModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
        loadNextQuestion(quiz.getCurrentQuestion())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let answerText = textField.text
        if quiz.checkCurrentQuestion(text: answerText!) {
            // PLAY SUCCESS SOUND
            loadNextQuestion(quiz.nextQuestion())
            SystemSoundID.playFileNamed(fileName: "Ping", withExtenstion: "aiff")

        } else {
            // PLAY FAIL SOUND
            self.imageView.shake()
            self.scoreLabel.shake()
            self.letterCountLabel.shake()
            self.hintLabel.shake()
            self.textField.shake()
            SystemSoundID.playFileNamed(fileName: "Funk", withExtenstion: "aiff")
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = quiz.questions[quiz.currentQuestion].characterCount
        let currentString : NSString = textField.text! as NSString
        let newString : NSString  = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func loadNextQuestion(_ questionTuple: (score: Int, question: Question)) {
        
        imageView.image = questionTuple.question.image
        scoreLabel.text = "\(questionTuple.score)"
        letterCountLabel.text = "\(questionTuple.question.characterCount) letters"
        hintLabel.text = "HINT: \(questionTuple.question.hint)"
        textField.text = ""
        textField.becomeFirstResponder()
        SystemSoundID.playFileNamed(fileName: "Pop", withExtenstion: "aiff")

    }
    
}


// Extensions
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension SystemSoundID {
    static func playFileNamed(fileName: String, withExtenstion fileExtension: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}

