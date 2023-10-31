//
//  PredictionTests.swift
//  EchoTests
//
//  Created by Gavin Henderson on 19/10/2023.
//

import XCTest
@testable import Echo

final class PredictionTests: XCTestCase {
    enum BasicError: Error {
        case textError(String)
    }
    
    var testSentences = [
        /**
         No Prediction
        1 - Select a
        13 - moves to n
        1 - select n
        1 - select word
        1 - select a
        15 - move to p
        1 - select p
        15 - move to p
        1 - select p
        11 - move to l
        1 - select l
        4 - move to e
        1 - select e
        1 - select word
        Total = 67
         
         
         */
        "an apple",
        "The quick brown fox jumps over the lazy dog.",
        "The weather forecast predicts rain with a chance of thunderstorms",
        "Please send me the latest sales report by the end of the day",
        "I'm interested in learning more about machine learning and artificial intelligence",
        "The sun sets in the west, casting a warm, golden glow over the horizon",
        "She played a beautiful melody on her violin, filling the room with enchanting music.",
        "The scientist conducted experiments to prove his groundbreaking theory.",
        "He embarked on a journey to explore the uncharted wilderness.",
        "The ancient castle stood atop the hill, shrouded in legends and mysteries.",
        "The chef prepared a delicious gourmet meal that delighted the guests."
    ]
    
    func normaliseString(_ given: String) -> String {
        let allowedLetters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z, ".components(separatedBy: ",")
        let lowered = given.lowercased()
        let split = lowered.split(separator: "")
        
        let filtered = split.filter { current in
            return allowedLetters.contains(String(current))
        }
        
        return filtered.joined(separator: "")
    }
    
    func testUseEnglishIfPredictionLangugeIsMalformed() {
        let spelling = SpellingOptions()
        
        spelling.letterPrediction = true
        spelling.wordPrediction = true
        spelling.wordPredictionLimit = 3
        spelling.predictionLanguage = "MALFORMED"
        
        XCTAssertEqual(spelling.language, .english)
    }
    
//    func testNoPredictionMeasure() throws {
//        let spelling = SpellingOptions()
//        
//        spelling.letterPrediction = false
//        spelling.wordPrediction = false
//        
//        let index = 0
//        let sentence = testSentences[0]
//        let normalisedSentence = normaliseString(sentence)
//        let words = normalisedSentence.split(separator: " ")
//        var moves = 0
//        var isCompleted = false
//        
//        var currentSentence = ""
//        
//        while isCompleted == false {
//            let currentSplitByWords = currentSentence.split(separator: " ")
//            let currentFullWordIndex = currentSplitByWords.count
//            let currentFullWord = String(words[currentFullWordIndex])
//            let currentEnteredWord = String(currentSentence.split(separator: " ").last ?? "")
//            
//            if currentFullWord == currentEnteredWord {
//                moves += 1
//                currentSentence += " "
//                continue
//            }
//            
//            if normaliseString(currentSentence) == normalisedSentence {
//                isCompleted = true
//                break
//            }
//            
//            // This long line is basically just `currentFullWord[currenteEnteredWord.count]`
//            let nextLetter = currentFullWord[currentFullWord.index(currentFullWord.startIndex, offsetBy: currentEnteredWord.count)]
//            
//            let results = spelling.predict(enteredText: currentSentence)
//            
//            let posInResult = results.firstIndex(where: { result in
//                if result.details.displayText == String(nextLetter) {
//                    return true
//                }
//                    
//                return false
//            })
//            
//            guard let unwrappedPosInResult = posInResult else {
//                throw BasicError.textError("Failed to find letter or word in result")
//            }
//            
//            moves += unwrappedPosInResult + 1
//            currentSentence += results[unwrappedPosInResult].details.displayText
//        }
//        
//        print("No Prediction: \(index + 1), completed in \(moves) moves")
//        
//        XCTAssertEqual(true, true)
//    }
}

//        for (index, sentence) in testSentences.enumerated() {
