//
//  MeasuringUtterancesTests.swift
//  EchoTests
//
//  Created by Gavin Henderson on 25/10/2023.
//

import XCTest
@testable import Echo

final class MeasuringUtterancesTests: XCTestCase {
    func testNumberOfWordsInUtterance() throws {
        let testUtterance = "This is a test sentence"
        let numberOfWords = getNumberOfWords(testUtterance)
        
        XCTAssertEqual(numberOfWords, 5)
    }
    
    func testAverageWordLength() throws {
        let testUtterance = "This is a test sentence"
        let averageWordLength = getAverageWordLength(testUtterance)
        
        XCTAssertEqual(averageWordLength, 4)
    }
    
    func testUtteranceLength() throws {
        let testUtterance = "This is a test sentence"
        let utteranceLength = getTotalUtteranceLength(testUtterance)
        
        XCTAssertEqual(utteranceLength, 23)
    }
}
