//
//  Logger.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

protocol ErrorLoggable {
    /// Logs the given error along with additional information.
    ///
    /// - Parameters:
    ///   - error: The error to be logged.
    ///   - additionalInfo: Additional information to be included in the log.
    ///
    /// This tool provides a simple abstraction for a basic logging system.
    /// However, it is not linked to any comprehensive tool for this trial project.
    /// Behind this system, a basic logging library is intended to run its operations.
    func log(_ error: Error, with additionalInfo: [String: String])
}

class Logger: ErrorLoggable {
    func log(_ error: Error, with additionalInfo: [String: String]) {
        var modifiedInfo = additionalInfo
        modifiedInfo["Error Description"] = error.localizedDescription
        debugPrint("Detail: \(error), info: \(additionalInfo)")
    }
}
