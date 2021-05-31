//
//  NetworkError.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/18/21.
//

import UIKit

enum NetworkError: Error {
    case failed(_ message: String?)
}

extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failed(let message):
            return message ?? "Something went wrong, please try again later"
        }
    }
}
