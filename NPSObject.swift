//
//  NPSObject.swift
//  KineduApp
//
//  Created by Horacio Garza on 12/11/16.
//  Copyright © 2016 HoracioGarza. All rights reserved.
//

import Foundation


struct NPSObject {
    
    var id:Int64
    var nps:Int8
    var days_since_signup:Int
    var user_plan:String
    var activity_views:Int
    
    var build:Build
}

struct Build{
    var version: String
    var release_date:String
}
