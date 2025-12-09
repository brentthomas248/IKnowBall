import XCTest
@testable import FeatureConnections
@testable import FeatureGamesShared

final class ConnectionGameViewModelTests: XCTestCase {
    
    var viewModel: ConnectionGameViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ConnectionGameViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.tiles.count, 16)
        XCTAssertEqual(viewModel.mistakesRemaining, 4)
        XCTAssertEqual(viewModel.solvedGroups, 0)
        XCTAssertEqual(viewModel.score, 0)
        
        switch viewModel.state {
        case .playing:
            XCTAssertTrue(true)
        default:
            XCTFail("Initial state should be playing")
        }
    }
    
    func testSelectionLogic() {
        let firstTile = viewModel.tiles[0]
        
        // Select
        viewModel.toggleSelection(firstTile)
        XCTAssertTrue(viewModel.tiles[0].isSelected)
        
        // Deselect
        viewModel.toggleSelection(firstTile)
        XCTAssertFalse(viewModel.tiles[0].isSelected)
    }
    
    func testSelectionLimit() {
        // Select 4 tiles
        for i in 0..<4 {
            viewModel.toggleSelection(viewModel.tiles[i])
        }
        
        // Try selecting 5th
        viewModel.toggleSelection(viewModel.tiles[4])
        
        XCTAssertTrue(viewModel.tiles[0].isSelected)
        XCTAssertTrue(viewModel.tiles[3].isSelected)
        XCTAssertFalse(viewModel.tiles[4].isSelected, "Should not allow more than 4 selections")
    }
    
    func testSubmission_IncorrectGroup() {
        // Find tiles from different categories
        // In the mock data: Quarterback (Positions), Touchdown (Scoring), etc.
        // We know the categories from initialization.
        
        // Let's just pick 4 random tiles that are likely mixed since we just shuffled mock data
        // But to be precise, we need to inspect categories.
        // Since we can't easily query by category without exposing more test hooks, we'll try to rely on the fact that 
        // randomly picking 4 is highly unlikely to be a group.
        // BETTER: Create a way to inject data or use known indices if possible.
        // The mock data is fixed in `startNewGame` but shuffled.
        
        // We can inspect the private/internal `tiles` array which is exposed.
        
        // Group tiles by category
        let distinctCategories = Set(viewModel.tiles.map { $0.category })
        guard distinctCategories.count >= 2 else {
            XCTFail("Not enough categories to test incorrect submission")
            return
        }
        
        let cat1 = distinctCategories.first!
        let cat2 = distinctCategories.dropFirst().first!
        
        guard let tile1 = viewModel.tiles.first(where: { $0.category == cat1 }),
              let tile2 = viewModel.tiles.first(where: { $0.category == cat2 }) else {
            XCTFail("Could not find tiles for categories")
            return
        }
        
        // Clear any existing selection just in case
        viewModel.deselectAll()
        
        // Select 3 of cat1 (if available) or just mix
        // Let's just select tile1 and tile2 and 2 others to make 4
        viewModel.toggleSelection(tile1)
        viewModel.toggleSelection(tile2)
        
        // Find 2 more
        for tile in viewModel.tiles {
            if !tile.isSelected && (viewModel.tiles.filter { $0.isSelected }.count < 4) {
                viewModel.toggleSelection(tile)
            }
        }
        
        let initialMistakes = viewModel.mistakesRemaining
        viewModel.submit()
        
        XCTAssertEqual(viewModel.mistakesRemaining, initialMistakes - 1)
        XCTAssertFalse(viewModel.tiles.contains(where: { $0.isSolved }), "No tiles should be solved")
    }
    
    func testSubmission_CorrectGroup() {
        // Group by category to find a valid group
        let grouped = Dictionary(grouping: viewModel.tiles, by: { $0.category })
        guard let validGroup = grouped.first?.value, validGroup.count == 4 else {
            XCTFail("Could not find a valid group of 4")
            return
        }
        
        viewModel.deselectAll()
        
        for tile in validGroup {
            viewModel.toggleSelection(tile)
        }
        
        viewModel.submit()
        
        // Verify all in that group are solved
        for tile in validGroup {
            let updatedTile = viewModel.tiles.first(where: { $0.id == tile.id })!
            XCTAssertTrue(updatedTile.isSolved)
            XCTAssertFalse(updatedTile.isSelected)
        }
        
        XCTAssertEqual(viewModel.solvedGroups, 1)
    }
}
