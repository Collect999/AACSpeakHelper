//
//  Prediction.swift
//  Echo
//
//  Created by Gavin Henderson on 02/08/2023.
//

import Foundation
import SQLite

// This is slow an ineffecient
// It brute forces the dictionary every time
// No error handling
// Probably very poor SQLite practice, i reckon it might drop the connection if you leave the app in the background
// It does some basic word prediction, but it doesnt count the weight of the word just if its specific enough
class SlowAndBadPrediciton: PredictionEngine {
    var dbConn: Connection?
    var wordsTable: SQLite.Table?
    
    init() {
        do {
            let path = Bundle.main.path(forResource: "dictionary", ofType: "sqlite")!
            let db = try Connection(path, readonly: true)
            let words = Table("words")
            
            self.dbConn = db
            self.wordsTable = words
            
        } catch {
            print(error)
        }
    }
    
    func predict(enteredText: String) -> [Item] {
        guard let db = dbConn else { return [] }
        guard let words = wordsTable else { return [] }
        
        let alphabet = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".components(separatedBy: ",")
        let alphabetItems = alphabet.map { currentPrediction in
            return Item(letter: currentPrediction, isPredicted: true)
        }
        
        var alphabetScores: [String: Int] = [:]
        
        let splitBySpace = enteredText.components(separatedBy: "·")

        guard let prefix = splitBySpace.last else {
            return alphabetItems
        }
        
        if prefix == "" { return alphabetItems }
        
        var wordPredictions: [String] = []
        
        do {
            let wordExpression = Expression<String>("word")
            let scoreExpression = Expression<Int>("score")
            
            let query = words.filter(wordExpression.like(prefix + "%"))
            
            for word in try db.prepare(query) {
                let nextCharPos = prefix.count
                let unwrappedWord = try word.get(wordExpression)
                let unwrappedScore = try word.get(scoreExpression)
                
                if nextCharPos < unwrappedWord.count {
                    wordPredictions.append(unwrappedWord)
                    
                    let nextCharIndex = unwrappedWord.index(unwrappedWord.startIndex, offsetBy: nextCharPos)
                    let nextChar = unwrappedWord[nextCharIndex].lowercased()
                    
                    if alphabet.contains(nextChar) {
                        let currentScore = alphabetScores[nextChar, default: 0]
                        alphabetScores[nextChar] = currentScore + unwrappedScore
                    }
                }
            }
            
        } catch {
            print(error)
            return alphabetItems
        }
        
        let sortedAlphabet = alphabet.sorted {
            let firstScore = alphabetScores[$0, default: 0]
            let secondScore = alphabetScores[$1, default: 0]
            
            return firstScore > secondScore
        }.map { currentPrediction in
            return Item(letter: currentPrediction, isPredicted: true)
        }
                
        if wordPredictions.count <= 3 {
            let wordItems = wordPredictions.map { word in
                let wordWithoutPrefix = String(word.dropFirst(prefix.count))
                
                return Item(letter: wordWithoutPrefix+"·", display: word, speakText: word, isPredicted: true)
            }
            
            return wordItems + sortedAlphabet
        }
        
        return sortedAlphabet
    }
    
}

// This is a 'prediction' engine that randomly shuffles letters
class RandomPrediction: PredictionEngine {
    var alphabet: [String]
    var words: [String]
    
    init() {
        words = ["This", "is", "word", "I", "suggest", "more"]
        alphabet = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".components(separatedBy: ",")
    }
    
    func predict(enteredText: String) -> [Item] {
        if enteredText == "" {
            return "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
                .components(separatedBy: ",").map { currentPrediction in
                    return Item(letter: currentPrediction, isPredicted: true)
            }
        }
        
        alphabet.shuffle()
        words.shuffle()
        return (words + alphabet).map { currentPrediction in
            return Item(letter: currentPrediction, isPredicted: true)
            
        }
        
    }
}

protocol PredictionEngine {
    func predict(enteredText: String) -> [Item]
}
