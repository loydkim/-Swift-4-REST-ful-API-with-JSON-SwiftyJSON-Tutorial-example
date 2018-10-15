//
//  UserObject.swift
//  RESTAPIWithJsonTest
//
//  Created by YOUNGSIC KIM on 2018-10-14.
//  Copyright © 2018 YOUNGSIC KIM. All rights reserved.
//

import SwiftyJSON

class UserObject {
    var pictureURL: String!
    var username: String!
    
    // Get data from json file. I will get only picutre URL and user name
    // PictureURL located in 'results -> picture -> medium' in JSON data
    // UserName located in 'results -> login -> username' in JSON data
    required init(json: JSON) {
        pictureURL = json["picture"]["medium"].stringValue
        username = json["login"]["username"].stringValue
    }
}
