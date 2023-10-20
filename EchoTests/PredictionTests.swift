//
//  PredictionTests.swift
//  EchoTests
//
//  Created by Gavin Henderson on 19/10/2023.
//

import XCTest
@testable import Echo

final class PredictionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUseEnglishIfPredictionLangugeIsMalformed() {
        let spelling = SpellingOptions()
        
        spelling.letterPrediction = true
        spelling.wordPrediction = true
        spelling.wordPredictionLimit = 3
        spelling.predictionLanguage = "MALFORMED"
                
        XCTAssertEqual(spelling.language, .english)
    }

    func testPredictionIsReturned() throws {
        let spelling = SpellingOptions()
        
        spelling.letterPrediction = true
        spelling.wordPrediction = true
        spelling.wordPredictionLimit = 3
        spelling.predictionLanguage = "en"
        
        let result = spelling.predict(enteredText: "Test")
        
        XCTAssertNotEqual(result.count, 0)
    }
}
