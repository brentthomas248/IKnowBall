import XCTest
@testable import FeatureBallKnowledge

final class BallKnowledgeViewModelTests: XCTestCase {
    
    var sut: BallKnowledgeViewModel!
    
    override func setUp() {
        super.setUp()
        sut = BallKnowledgeViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization_SetsDefaultValues() {
        XCTAssertEqual(sut.score, 0)
        XCTAssertEqual(sut.timeRemaining, 120)
        XCTAssertEqual(sut.correctCount, 0)
        XCTAssertEqual(sut.missedCount, 0)
        XCTAssertFalse(sut.showSummary)
        XCTAssertFalse(sut.tiles.isEmpty)
    }
    
    func testStartNewGame_ResetsScoreAndTimer() {
        // Arrange
        sut.score = 500
        sut.timeRemaining = 10
        sut.correctCount = 5
        sut.missedCount = 2
        sut.showSummary = true
        
        // Act
        sut.startNewGame()
        
        // Assert
        XCTAssertEqual(sut.score, 0)
        XCTAssertEqual(sut.timeRemaining, 120)
        XCTAssertEqual(sut.correctCount, 0)
        XCTAssertEqual(sut.missedCount, 0)
        XCTAssertFalse(sut.showSummary)
    }
    
    func testSubmitGuess_CorrectGuess_UpdatesScore() {
        // Arrange
        let tile = sut.tiles.first!
        let correctName = tile.playerName
        sut.currentInput = correctName
        
        // Act
        sut.submitGuess()
        
        // Assert
        XCTAssertTrue(sut.tiles.first!.isRevealed)
        XCTAssertGreaterThan(sut.score, 0)
        XCTAssertEqual(sut.correctCount, 1)
        XCTAssertTrue(sut.currentInput.isEmpty) // Should clear input
    }
    
    func testSubmitGuess_IncorrectGuess_UpdatesMissedCount() {
        // Arrange
        sut.currentInput = "Wrong Name"
        let initialTime = sut.timeRemaining
        
        // Act
        sut.submitGuess()
        
        // Assert
        XCTAssertEqual(sut.missedCount, 1)
        XCTAssertLessThan(sut.timeRemaining, initialTime) // Penalty applied
    }
}
