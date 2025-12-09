import SwiftUI

struct GameTileView: View {
    let tile: GameTileModel
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                // Use a subtle border for better contrast on light backgrounds
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                )
            
            VStack(spacing: 2) {
                if tile.isRevealed {
                    Text(tile.playerName)
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(2)
                        .minimumScaleFactor(0.5)
                } else {
                    Text(tile.stat)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text(tile.teamAbbr)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            .padding(2)
        }
        .aspectRatio(1.0, contentMode: .fit) // Ensure square tiles
    }
    
    // MARK: - Computed Properties
    
    private var backgroundColor: Color {
        if tile.isRevealed {
            return Color(red: 0.1, green: 0.15, blue: 0.3) // Navy Blue
        } else {
            switch tile.tier {
            case 1:
                return Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.3) // Gold
            case 2:
                return Color.gray.opacity(0.3) // Silver
            case 3:
                return Color(red: 0.8, green: 0.5, blue: 0.2).opacity(0.3) // Bronze
            default:
                return Color.secondary.opacity(0.1)
            }
        }
    }
}

#Preview {
    HStack {
        GameTileView(tile: GameTileModel(id: UUID(), stat: "5,477 Yds", teamAbbr: "DEN", playerName: "Peyton Manning", isRevealed: false, tier: 1))
            .frame(width: 100)
        
        GameTileView(tile: GameTileModel(id: UUID(), stat: "5,477 Yds", teamAbbr: "DEN", playerName: "Peyton Manning", isRevealed: true, tier: 1))
            .frame(width: 100)
    }
    .padding()
}
