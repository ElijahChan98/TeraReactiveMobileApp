//
//  RequestManager.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit

public enum RequestMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}

class RequestManager {
    static let shared = RequestManager()
    
    func login(username: String, password: String, completion: @escaping (_ success: Bool, _ response: [String:Any]?) -> ()) {
        let queryItems = [URLQueryItem(name: "userID", value: username),
                          URLQueryItem(name: "password", value: password),
        ]
        var urlComponents = URLComponents(string: Constants.BASE_URL + Constants.LOGIN)!
        urlComponents.queryItems = queryItems
        self.createGenericRequest(url: urlComponents.url!, requestMethod: .post) { (success, response) in
            completion(success, response)
        }
    }
    
    func update(user: User, completion: @escaping (_ success: Bool, _ response: [String:Any]?) -> ()) {
        let queryItems = [URLQueryItem(name: "userID", value: user.id),
                          URLQueryItem(name: "firstName", value: user.firstName),
                          URLQueryItem(name: "middleName", value: user.middleName),
                          URLQueryItem(name: "lastName", value: user.lastName),
                          URLQueryItem(name: "emailAddress", value: user.email),
                          URLQueryItem(name: "mobileNumber", value: user.mobileNumber),
                          URLQueryItem(name: "landline", value: user.landline),
        ]
        var urlComponents = URLComponents(string: Constants.BASE_URL + Constants.UPDATE)!
        urlComponents.queryItems = queryItems
        self.createGenericRequest(url: urlComponents.url!, requestMethod: .post) { (success, response) in
            completion(success, response)
        }
    }
    
    private func createGenericRequest(url: URL, requestMethod: RequestMethod, completion: @escaping (_ success: Bool, _ response: [String: Any]?) -> ()) {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        completion(false, nil)
                    }
                    else if httpResponse.statusCode == 500 {
                        //internal server error
                        completion(false, nil)
                    }
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let payload = json as? [String: Any] {
                            completion(true, payload)
                        }
                        else if let payloads = json as? [[String:Any]] {
                            //print(payloads)
                            completion(true, ["payloads" : payloads])
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                        print("something went wrong")
                    }
                }
                else {
                    completion(false, nil)
                }
            }
        }
        task.resume()
    }
}
