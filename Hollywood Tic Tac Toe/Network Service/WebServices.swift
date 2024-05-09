//
//  WebServices.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile on 06/05/24.
//

import UIKit

typealias CompletionBlock = (Bool, JSONDictionary?) -> Void

//MARK: - Webservices class for call apis
class WebServices: NSObject {
    
    func startParsingWithGetApi(url: String, completion: @escaping(Bool, [String : Any]?) -> Void) {
                
        if isConnectedToNetwork() == true {
            let requestUrl = URL(string: "\(url)")
            print("requestUrl: \(String(describing: requestUrl))")
           
            var request = URLRequest(url: requestUrl!)
            request.httpMethod = "GET"
            request.timeoutInterval = 120
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
           
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                if data != nil {
                    //print ("sendsyncRequest Get: \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")")
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if (statusCode == 200) {
                        let jsonResult: AnyObject = try! JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        //print("Response Get: \(jsonResult)")
                        if jsonResult.count > 0 {
                            completion(true, jsonResult as? JSONDictionary)
                        }else {
                            completion(false, [:])
                        }
                    }else {
                        completion(false, [:])
                    }
                }else {
                    completion(false, [:])
                }
            })
            task.resume()
        }else {
            DispatchQueue.main.async {
                Helper.stopLoader()
            }
            Helper.shared.errorCatcher(title: "Error", error: .internetNotWorking)
        }
    }
}
