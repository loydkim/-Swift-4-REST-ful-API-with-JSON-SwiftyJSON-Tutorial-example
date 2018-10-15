//
//  RestApiManager.swift
//  RESTAPIWithJsonTest
//
//  Created by YOUNGSIC KIM on 2018-10-14.
//  Copyright © 2018 YOUNGSIC KIM. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias ServiceResponse = (JSON,Error?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    let baseURL = "http://api.randomuser.me/" // this url change json data when load
    
    func getRandomUser(onCompletion:@escaping (JSON) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(path: route) { (json: JSON, error: Error?) in
            onCompletion(json as JSON)
        }
    }
    
    // MARK: perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        // using URL and request getting a json
        let request = URLRequest(url: NSURL(string: path)! as URL)
        URLSession.shared.dataTask(with: request) { (data:Data?, response: URLResponse?, error:Error?) in
            if let jsonData = data { // if data has a data and success
                do {
                    let json: JSON = try JSON(data: jsonData)
                    onCompletion(json,nil)
                }catch {// error
                    onCompletion(JSON(),error)
                }
            } else { // if the data is nil
                onCompletion(JSON(),error)
            }
        }.resume()
    }
    
    // MARK: perform a POST request
    private func makeHTTPPostRequest(path: String, body:[String:AnyObject], onCompletion: @escaping ServiceResponse) {
        var request = URLRequest(url: NSURL(string: path)! as URL)
        request.httpMethod = "POST"
        do { // it's similiar GET but add body data.
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = jsonBody
            URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                if let jsonData = data {
                    do{
                        let json:JSON = try JSON(data:jsonData)
                        onCompletion(json,nil)
                    }catch{
                        onCompletion(JSON(),error)
                    }
                }else {
                    onCompletion(JSON(),error)
                }
            }.resume()
        }catch {
            onCompletion(JSON(),nil)
        }
    }
}
