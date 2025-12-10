import Foundation
import OSLog

/// Centralized error handling service
/// Provides consistent error logging and user message mapping
@Observable
public final class ErrorHandler: Sendable {
    
    // MARK: - Singleton
    
    public static let shared = ErrorHandler()
    
    // MARK: - Properties
    
    private let logger = Logger(subsystem: "com.iknowball", category: "ErrorHandler")
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public API
    
    /// Handle an error with optional retry action
    /// - Parameters:
    ///   - error: The error that occurred
    ///   - context: Optional context string for debugging
    ///   - retryAction: Optional retry closure
    /// - Returns: UserFacingError for UI display
    public func handle(
        _ error: Error,
        context: String? = nil,
        retryAction: (() -> Void)? = nil
    ) -> UserFacingError {
        
        // Log the error
        log(error, context: context)
        
        // Convert to UserFacingError
        return createUserFacingError(from: error, retryAction: retryAction)
    }
    
    /// Handle an AppError specifically
    /// - Parameters:
    ///   - error: The AppError that occurred
    ///   - context: Optional context string
    ///   - retryAction: Optional retry closure
    /// - Returns: UserFacingError for UI display
    public func handle(
        _ error: AppError,
        context: String? = nil,
        retryAction: (() -> Void)? = nil
    ) -> UserFacingError {
        handle(error as Error, context: context, retryAction: retryAction)
    }
    
    // MARK: - Private Helpers
    
    private func log(_ error: Error, context: String?) {
        let contextString = context.map { " [\($0)]" } ?? ""
        
        if let appError = error as? AppError {
            let severity = appError.severity
            let message = "[AppError\(contextString)] \(appError.errorDescription ?? "Unknown error")"
            
            #if DEBUG
            // In debug, log full details
            let details = """
            Severity: \(severity)
            Reason: \(appError.failureReason ?? "Unknown")
            Recovery: \(appError.recoverySuggestion ?? "None")
            """
            print("🔴 \(message)\n\(details)")
            #endif
            
            
            // Log to OSLog based on severity
            switch severity {
            case .low:
                logger.info("\(message)")
            case .medium:
                logger.warning("\(message)")
            case .high, .critical:
                logger.error("\(message)")
            }
        } else {
            // Generic error
            let message = "[Error\(contextString)] \(error.localizedDescription)"
            logger.error("\(message)")
        }
    }
    
    private func createUserFacingError(
        from error: Error,
        retryAction: (() -> Void)?
    ) -> UserFacingError {
        
        if let appError = error as? AppError {
            return UserFacingError(
                title: appError.errorDescription ?? "Something went wrong",
                message: appError.recoverySuggestion ?? "Please try again",
                icon: iconForError(appError),
                canRetry: appError.canRetry,
                retryAction: retryAction
            )
        } else {
            // Generic error fallback
            return UserFacingError(
                title: "Something went wrong",
                message: error.localizedDescription,
                icon: "exclamationmark.triangle.fill",
                canRetry: true,
                retryAction: retryAction
            )
        }
    }
    
    private func iconForError(_ error: AppError) -> String {
        switch error.severity {
        case .low:
            return "info.circle.fill"
        case .medium:
            return "exclamationmark.circle.fill"
        case .high, .critical:
            return "exclamationmark.triangle.fill"
        }
    }
}

// MARK: - User Facing Error

/// Error representation for UI display
public struct UserFacingError: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let icon: String
    public let canRetry: Bool
    public let retryAction: (() -> Void)?
    
    public init(
        title: String,
        message: String,
        icon: String = "exclamationmark.triangle.fill",
        canRetry: Bool = false,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.canRetry = canRetry
        self.retryAction = retryAction
    }
}
