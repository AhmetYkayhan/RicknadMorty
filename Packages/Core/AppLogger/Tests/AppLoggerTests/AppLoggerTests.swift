import Testing
@testable import AppLogger

@Suite("AppLogger smoke")
struct AppLoggerSmokeTests {
    @Test("AppLogger initializes")
    func initializes() {
        let logger: LoggerProtocol = AppLogger(category: "test")
        logger.info("hello")
        #expect(Bool(true))
    }
}
