import Foundation
import Testing
@testable import WonderRead

struct LocalStoryErrorMapperTests {
  @Test func reportsGenericModelFailureDiagnostics() {
    let error = NSError(domain: "test.foundation-model", code: 17)
    let message = LocalStoryErrorMapper.message(for: error)
    #expect(message.contains(error.domain))
    #expect(message.contains("17"))
  }

  @Test func detectsNestedSensitiveContentServiceFailure() {
    let nested = NSError(domain: "com.apple.SensitiveContentAnalysisML", code: 42)
    let outer = NSError(domain: "test.wrapper", code: 1, userInfo: [NSUnderlyingErrorKey: nested])
    let message = LocalStoryErrorMapper.message(for: outer)
    #expect(message.contains("test.wrapper"))
    #expect(message.contains("code 42"))
  }

  @Test func detectsSensitiveFailureAmongMultipleUnderlyingErrors() {
    let unrelated = NSError(domain: "test.other", code: 4)
    let sensitive = NSError(domain: "sensitivecontentanalysisml.service", code: 73)
    let outer = NSError(domain: "test.wrapper", code: 1, userInfo: ["NSMultipleUnderlyingErrorsKey": [unrelated, sensitive]])
    let message = LocalStoryErrorMapper.message(for: outer)
    #expect(message.contains("code 73"))
  }
}
