import Foundation
import OSLog

// MARK: - Logger Protocol

protocol LoggerProtocol {
    func debug(_ message: String, file: String, function: String, line: Int)
    func info(_ message: String, file: String, function: String, line: Int)
    func warning(_ message: String, file: String, function: String, line: Int)
    func error(_ message: String, file: String, function: String, line: Int)
}

extension LoggerProtocol {
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        debug(message, file: file, function: function, line: line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        info(message, file: file, function: function, line: line)
    }

    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        warning(message, file: file, function: function, line: line)
    }

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        error(message, file: file, function: function, line: line)
    }
}

// MARK: - App Logger (OSLog-based)

final class AppLogger: LoggerProtocol {
    private let logger: os.Logger
    private let isEnabled: Bool

    init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.ricknadmorty",
         category: String = "general",
         isEnabled: Bool = true) {
        self.logger = os.Logger(subsystem: subsystem, category: category)
        self.isEnabled = isEnabled
    }

    func debug(_ message: String, file: String, function: String, line: Int) {
        guard isEnabled else { return }
        logger.debug("[\(self.fileName(file)):\(line)] \(message)")
    }

    func info(_ message: String, file: String, function: String, line: Int) {
        guard isEnabled else { return }
        logger.info("[\(self.fileName(file)):\(line)] \(message)")
    }

    func warning(_ message: String, file: String, function: String, line: Int) {
        guard isEnabled else { return }
        logger.warning("⚠️ [\(self.fileName(file)):\(line)] \(message)")
    }

    func error(_ message: String, file: String, function: String, line: Int) {
        guard isEnabled else { return }
        logger.error("❌ [\(self.fileName(file)):\(line)] \(message)")
    }

    private func fileName(_ path: String) -> String {
        (path as NSString).lastPathComponent
    }
}
