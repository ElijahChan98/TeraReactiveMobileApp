//
//  CodableObjectFactory.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit

struct CodableObjectFactory {
    public static func objectFromPayload<T: Codable>(_ payload: [String: Any]) -> T? {
        let decoder = JSONDecoder()
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
                do {
                    let object = try decoder.decode(T.self, from: jsonData)
                    return object
                } catch {
                    print(error.localizedDescription)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        return nil
    }
}
