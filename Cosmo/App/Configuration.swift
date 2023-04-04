//
//  Configuration.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import Foundation

enum Configuration {
    enum ConfigError: Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw ConfigError.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw ConfigError.invalidValue
        }
    }
}
