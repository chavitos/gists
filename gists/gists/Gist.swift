//
//  Gist.swift
//  gists
//
//  Created by Tiago Chaves on 02/06/16.
//  Copyright © 2016 netshoes. All rights reserved.
//

import Foundation
import CoreData


class Gist: NSObject {

// Insert code here to add functionality to your managed object subclass

    var id: String?
    var isPublic: NSNumber?
    var createdAt: NSDate?
    var updatedAt: NSDate?
    var desc: String?
    var comments: NSNumber?
    var forks: NSNumber?
    var owner: Owner?
    var files: [File]?
}
