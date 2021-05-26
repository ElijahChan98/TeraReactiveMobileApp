//
//  String+Extension.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/26/21.
//

import UIKit

extension String {
    func stringDate(in inFormat: String, out outFormat: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = inFormat
        
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = outFormat
        
        if let date = inFormatter.date(from: self) {
            return outFormatter.string(from: date)
        }
        else {
            return self
        }
    }
}
