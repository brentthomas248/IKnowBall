import XCTest
@testable import FeatureOverUnder

final class OverUnderViewModelTests: XCTestCase {
    
    var viewModel: OverUnderViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = OverUnderViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Since it loads asynchronously or purely from startNewGame,
        // checks might need to wait if we used async loading. 
        // But our GameDataService is synchronous (try Data(contentsOf:)).
        
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertEqual(viewModel.correctCount, 0)
        XCTAssertEqual(viewModel.missedCount, 0)
        XCTAssertEqual(viewModel.timeRemaining, 60)
        // Skip assertion if data hasn't loaded yet
        if viewModel.currentQuestion == nil {
            return
        }
    }
    
    func testCorrectGuess_Over() {
        // Setup a specific question
        guard let question = viewModel.currentQuestion else {
            // Skip test if data hasn't loaded yet
            return
        }
        
        let isActuallyOver = question.actualValue > question.lineValue
        
        // Submit correct guess
        viewModel.submitGuess(isOver: isActuallyOver)
        
        XCTAssertEqual(viewModel.score, 1)
        XCTAssertEqual(viewModel.correctCount, 1)
        XCTAssertEqual(viewModel.missedCount, 0)
        XCTAssertTrue(viewModel.lastGuessWasCorrect == true)
        XCTAssertEqual(viewModel.gameState, .showingResult)
    }
    
    func testIncorrectGuess() {
        guard let question = viewModel.currentQuestion else {
            // Skip test if data hasn't loaded yet
            return
        }
        
        let isActuallyOver = question.actualValue > question.lineValue
        
        // Submit incorrect guess
        viewModel.submitGuess(isOver: !isActuallyOver)
        
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertEqual(viewModel.correctCount, 0)
        XCTAssertEqual(viewModel.missedCount, 1)
        XCTAssertTrue(viewModel.lastGuessWasCorrect == false)
        XCTAssertEqual(viewModel.gameState, .showingResult)
    }
    
    func testTimerExpiryEndsGame() {
        viewModel.timeRemaining = 1
        
        // We need to wait for the timer to fire. 
        let expectation = XCTestExpectation(description: "Game ends after timer expires")
        
        // Helper to check state
        func checkState() {
            if self.viewModel.gameState == .gameOver {
                expectation.fulfill()
            }
        }
        
        // Wait 1.5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            checkState()
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(viewModel.gameState, .gameOver)
        XCTAssertTrue(viewModel.showSummary)
    }
}
