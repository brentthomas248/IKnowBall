import Foundation

public protocol UserProfileServiceProtocol {
    var userProfile: UserProfile { get }
    func addXP(_ amount: Int)
    func updateUsername(_ name: String)
}
