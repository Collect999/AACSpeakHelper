//
//  Random.swift
//  Echo
//
//  Created by Gavin Henderson on 03/10/2023.
//

import Foundation

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
