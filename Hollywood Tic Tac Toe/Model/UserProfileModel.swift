//
//  UserProfileModel.swift
//  Hollywood Tic Tac Toe
//
//  Created by Wegile-Gunavardhan on 06/05/24.
//

import Foundation

//MARK: - Save logged in user data local database
struct UserProfileModel {
    
    var appleId = ""
    var email   = ""
    var fname   = ""
    var lname   = ""
    var name    = ""
    
    init(jsonData response: JSONDictionary) {
        
        if response["appleId"] != nil {
            let str = "\(response["appleId"] ?? "")"
            appleId = Helper.shared.checkNullValue(str: str)
        }
        if response["email"] != nil {
            let str = "\(response["email"] ?? "")"
            email = Helper.shared.checkNullValue(str: str)
        }
        if response["fname"] != nil {
            let str = "\(response["fname"] ?? "")"
            fname = Helper.shared.checkNullValue(str: str)
        }
        if response["lname"] != nil {
            let str = "\(response["lname"] ?? "")"
            lname = Helper.shared.checkNullValue(str: str)
        }
        if response["name"] != nil {
            let str = "\(response["name"] ?? "")"
            name = Helper.shared.checkNullValue(str: str)
        }
    }
    
    func toDictionary() -> JSONDictionary {
        
        var dictionary = JSONDictionary()
        dictionary["appleId"] = self.appleId
        dictionary["email"]   = self.email
        dictionary["fname"]   = self.fname
        dictionary["lname"]   = self.lname
        dictionary["name"]    = self.name
        return dictionary
    }
    
    mutating func reset() {
        self.appleId = ""
        self.email   = ""
        self.fname   = ""
        self.lname   = ""
        self.name    = ""
    }
}

