//
//  SpellingOptions.swift
//  Echo
//
//  Created by Gavin Henderson on 18/10/2023.
//

import Foundation
import SwiftUI
import SQLite

struct PredictionLanguage {
    var alphabet: [String]
}

class SpellingOptions: ObservableObject {
    @AppStorage("letterPrediction") var letterPrediction: Bool = true
    @AppStorage("wordPrediction") var wordPrediction: Bool = true
    @AppStorage("wordPredictionLimit") var wordPredictionLimit: Int = 3
    
    var dbConn: Connection?
    var wordsTable: SQLite.Table?
    
    var language = PredictionLanguage(
        alphabet: "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".components(separatedBy: ",")
    )
    
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
        
        let alphabet = language.alphabet
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
            
            let query = words
                .filter(wordExpression.like(prefix + "%"))
                .order(scoreExpression.desc)
            
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
        
        let finalAlphabet = letterPrediction ? sortedAlphabet : alphabetItems
        
        if wordPrediction {
            let wordItems = wordPredictions.prefix(wordPredictionLimit).map { word in
                let wordWithoutPrefix = String(word.dropFirst(prefix.count))

                return Item(letter: wordWithoutPrefix+"·", display: word, speakText: word, isPredicted: true)
            }
            
            return wordItems + finalAlphabet
        }
        
        return finalAlphabet
    }
}
