import Foundation

public typealias MoyaValidationResult = Result<Void, Error>

public typealias MoyaDataValidation = (URLRequest?, HTTPURLResponse, Data?) -> MoyaValidationResult
public typealias MoyaDownloadValidation = (URLRequest?, HTTPURLResponse, URL?) -> MoyaValidationResult

/// Represents the status codes to validate through Alamofire.
public enum ValidationType {

    /// No validation.
    case none

    /// Validate success codes (only 2xx).
    case successCodes

    /// Validate success codes and redirection codes (only 2xx and 3xx).
    case successAndRedirectCodes

    /// Validate only the given status codes.
    case customCodes([Int])
    
    case dataValidation(_ validation: MoyaDataValidation)
    
    case downloadValidation(_ validation: MoyaDownloadValidation)

    /// The list of HTTP status codes to validate.
    var statusCodes: [Int] {
        switch self {
        case .successCodes:
            return Array(200..<300)
        case .successAndRedirectCodes:
            return Array(200..<400)
        case .customCodes(let codes):
            return codes
        case .none, .dataValidation, .downloadValidation:
            return []
        }
    }
    
    var dataValidation: MoyaDataValidation? {
        switch self {
        case .dataValidation(let validation):
            return validation
        default:
            return nil
        }
    }
    var downloadValidation: MoyaDownloadValidation? {
        switch self {
        case .downloadValidation(let validation):
            return validation
        default:
            return nil
        }
    }
}

extension ValidationType: Equatable {

    public static func == (lhs: ValidationType, rhs: ValidationType) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.successCodes, .successCodes),
             (.successAndRedirectCodes, .successAndRedirectCodes):
            return true
        case (.customCodes(let code1), .customCodes(let code2)):
            return code1 == code2
        default:
            return false
        }
    }
}
