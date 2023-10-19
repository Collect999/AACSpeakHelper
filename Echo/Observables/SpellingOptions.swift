//
//  SpellingOptions.swift
//  Echo
//
//  Created by Gavin Henderson on 18/10/2023.
//

import Foundation
import SwiftUI
import SQLite

struct PredictionLanguage: Hashable, Identifiable {
    var id: String
    var display: String
    var alphabet: [String]
    var databaseLanguageCode: String
    
    static public var english = PredictionLanguage(
        id: "en",
        display: String(
            localized: "English",
            comment: "The label for the English language when setting prediction language"
        ),
        alphabet: "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".components(separatedBy: ","),
        databaseLanguageCode: "en"
    )
    
    static public var arabic = PredictionLanguage(
        id: "ar",
        display: String(
            localized: "Arabic (Experimental)",
            comment: "The label for the Arabic language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "چ,ج,ح,خ,ه,ع,غ,ف,ق,ث,ص,ض,گ,ک,م,ن,ت,ا,ل,ب,ی,س,ش,و,پ,د,ذ,ر,ز,ط,ظ".components(separatedBy: ","),
        databaseLanguageCode: "ar"
    )
    
    static public var welsh = PredictionLanguage(
        id: "cy",
        display: String(
            localized: "Welsh (Experimental)",
            comment: "The label for the Welsh language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "a,b,c,ch,d,dd,e,f,ff,g,ng,h,i,j,l,ll,m,n,o,p,ph,r,rh,s,t,th,u,w,y".components(separatedBy: ","),
        databaseLanguageCode: "cy"
    )
    
    static public var spanish = PredictionLanguage(
        id: "es",
        display: String(
            localized: "Spanish (Experimental)",
            comment: "The label for the Spanish language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "a,á,b,c,d,e,é,f,g,h,i,í,j,k,l,m,n,ñ,o,ó,p,q,r,s,t,u,ú,ü,v,w,x,y,z".components(separatedBy: ","),
        databaseLanguageCode: "es"
    )
    
    static public var hebrew = PredictionLanguage(
        id: "he",
        display: String(
            localized: "Hebrew (Experimental)",
            comment: "The label for the Hebrew language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "א,בּ,ב,גּ,ג,דּ,ד,ה,ו,ז,ח,ט,י,כּ,כ,ךּ,ך,ל,מ,ם,נ,ן,ס,ע,פּ,פ,ף,צ,ץ,ק,ר,שׁ,שׂ,תּ,ת".components(separatedBy: ","),
        databaseLanguageCode: "he"
    )
    
    static public var croatian = PredictionLanguage(
        id: "hr",
        display: String(
            localized: "Croatian (Experimental)",
            comment: "The label for the Croatian language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "a,b,c,ć,č,d,đ,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,š,t,u,v,w,x,z,ž".components(separatedBy: ","),
        databaseLanguageCode: "hr"
    )

    static public var maori = PredictionLanguage(
        id: "mi",
        display: String(
            localized: "Māori (Experimental)",
            comment: "The label for the Māori language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "a,ā,e,ē,h,i,ī,k,m,n,ng,o,ō,p,r,t,u,ū,w,wh".components(separatedBy: ","),
        databaseLanguageCode: "mi"
    )
    
    static public var polish = PredictionLanguage(
        id: "pl",
        display: String(
            localized: "Polish (Experimental)",
            comment: "The label for the Polish language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "a,ä,ą,b,c,ć,d,e,ę,f,g,h,i,j,k,l,ĺ,ł,m,n,ń,o,ó,p,r,s,ś,t,u,w,x,y,z,ź,ż".components(separatedBy: ","),
        databaseLanguageCode: "pl"
    )
    
    static public var portuguese = PredictionLanguage(
        id: "pt",
        display: String(
            localized: "Portuguese (Experimental)",
            comment: "The label for the portuguese language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "a,ª,á,à,ă,â,å,ä,ã,b,c,ç,d,e,é,è,ê,f,g,h,i,í,ì,ï,j,k,l,m,n,ñ,o,º,ó,ò,ô,õ,p,q,r,s,t,u,ú,ü,v,w,x,y,z".components(separatedBy: ","),
        databaseLanguageCode: "pt"
    )
    
    static public var urdu = PredictionLanguage(
        id: "ur",
        display: String(
            localized: "Urdu (Experimental)",
            comment: "The label for the urdu language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "آ,ئ,ا,ب,پ,ت,ث,ٹ,ج,چ,ح,خ,د,ذ,ڈ,ر,ز,ڑ,س,ش,ص,ض,ط,ظ,ع,غ,ف,ق,ك,ک,گ,ل,م,ن,ں,ه,ھ,ہ,و,ى,ي,ی,ے".components(separatedBy: ","),
        databaseLanguageCode: "ur"
    )
    
    static public var yidish = PredictionLanguage(
        id: "yi",
        display: String(
            localized: "Yiddish (Experimental)",
            comment: "The label for the Yiddish language when setting prediction language, make sure to include the experimental tag"
        ),
        alphabet: "א,ב,ג,ד,ה,ו,װ,ז,ח,ט,י,ײ,כ,ך,ל,מ,ם,נ,ן,ס,ע,פ,ף,צ,ץ,ק,ר,ש,ת".components(separatedBy: ","),
        databaseLanguageCode: "yi"
    )
    
    static public var allLanguages: [PredictionLanguage] = [.english, .welsh, .arabic, .spanish, .hebrew, .croatian, .maori, .polish, .urdu, .yidish]
    static public var defaultLanguage: PredictionLanguage = .english
}

class SpellingOptions: ObservableObject {
    @AppStorage("letterPrediction") var letterPrediction: Bool = true
    @AppStorage("wordPrediction") var wordPrediction: Bool = true
    @AppStorage("wordPredictionLimit") var wordPredictionLimit: Int = 3
    @AppStorage("predictionLanguage") var predictionLanguage: String = PredictionLanguage.defaultLanguage.id
    
    var dbConn: Connection?
    var wordsTable: SQLite.Table?
    
    var language: PredictionLanguage {
        return PredictionLanguage.allLanguages.first { current in
            if current.id == predictionLanguage {
                return true
            }
            return false
        } ?? .defaultLanguage
    }
    
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
            let languageExpression = Expression<String>("language")
            
            let query = words
                .filter(languageExpression == language.databaseLanguageCode)
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
