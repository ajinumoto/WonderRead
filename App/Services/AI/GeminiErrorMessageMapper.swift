import Foundation

enum GeminiErrorMessageMapper {
  static func message(statusCode: Int, data: Data, operation: GeminiOperation) -> String {
    let detail = detail(from: data)
    switch statusCode {
    case 400: return badRequest(operation, detail: detail)
    case 401, 403: return accessDenied(statusCode, operation, detail: detail)
    case 404: return modelUnavailable(operation, detail: detail)
    case 429: return quotaReached(operation, detail: detail)
    default: return generalFailure(statusCode, operation, detail: detail)
    }
  }

  private static func detail(from data: Data) -> String? {
    (try? JSONDecoder().decode(GeminiErrorEnvelope.self, from: data))?.error?.message.map { String($0.prefix(260)) }
  }

  private static func badRequest(_ operation: GeminiOperation, detail: String?) -> String {
    String(localized: "Gemini rejected the request to create the \(operation.localizedTitle) (400). \(detail ?? "Check the request format and try again.")", comment: "Localized app copy.")
  }

  private static func accessDenied(_ code: Int, _ operation: GeminiOperation, detail: String?) -> String {
    String(localized: "Gemini denied access while creating the \(operation.localizedTitle) (\(code)). Check the API key and Gemini API access. \(detail ?? "")", comment: "Localized app copy.")
  }

  private static func modelUnavailable(_ operation: GeminiOperation, detail: String?) -> String {
    String(localized: "The Gemini model for the \(operation.localizedTitle) isn't available (404). \(detail ?? "Check model availability for this account.")", comment: "Localized app copy.")
  }

  private static func quotaReached(_ operation: GeminiOperation, detail: String?) -> String {
    String(localized: "The Gemini quota was reached while creating the \(operation.localizedTitle). Try again later or check the Google account quota. \(detail ?? "")", comment: "Localized app copy.")
  }

  private static func generalFailure(_ code: Int, _ operation: GeminiOperation, detail: String?) -> String {
    String(localized: "Gemini couldn't create the \(operation.localizedTitle) (HTTP \(code)). \(detail ?? "Check your internet connection and try again.")", comment: "Localized app copy.")
  }
}
