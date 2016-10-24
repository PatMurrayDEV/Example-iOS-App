//
//  ObjectModel.swift
//  QuizApp
//
//  Created by Patrick Murray on 23/10/2016.
//
//

import UIKit

struct Question {
    
    var image : UIImage
    var answer : String
    var characterCount : Int
    var hint : String
    
    init (imageName: String, answer: String, hint: String) {
        if let imageObj = UIImage(named: imageName) {
            self.image = imageObj
        } else {
            self.image = UIImage(named: "NO_IMAGE")!
        }
        self.answer = answer
        self.characterCount = answer.characters.count
        self.hint = hint
    }
    
    public func checkAnswer(text: String) -> Bool {
        let textClean = text.replacingOccurrences(of: " ", with: "")
        return textClean.caseInsensitiveCompare(answer) == ComparisonResult.orderedSame
    }
    

    
}



class QuizModel {
    
    var questions : [Question] = []
    var score : Int = 0
    var currentQuestion : Int = 0
    
    init() {
        questions = makeQuestions()
        score = 0
        currentQuestion = 0
    }
    
    private func makeQuestions() -> [Question] {
        var questionsArray = [Question]()
        questionsArray.append(Question(imageName: "question_1", answer: "Summer", hint: "Season"))
        questionsArray.append(Question(imageName: "question_2", answer: "Party", hint: "Birthday"))
        questionsArray.append(Question(imageName: "question_3", answer: "Can", hint: "Soda"))

        return questionsArray
    }
    
    public func checkCurrentQuestion(text: String) -> Bool {
        return questions[currentQuestion].checkAnswer(text: text)
    }
    
    public func nextQuestion() -> (score: Int, question: Question) {
        // Returns new score + next question
        score = score + questions[currentQuestion].characterCount
        currentQuestion = currentQuestion + 1
        if currentQuestion >= questions.count {
            currentQuestion = 0
        }
        return (score, questions[currentQuestion])
    }
    
    public func getCurrentQuestion() -> (score: Int, question: Question) {
        return (score, questions[currentQuestion])
    }
    
    
}

