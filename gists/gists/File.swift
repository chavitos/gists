//
//  File.swift
//  gists
//
//  Created by Tiago Chaves on 02/06/16.
//  Copyright © 2016 netshoes. All rights reserved.
//

import Foundation
import CoreData


class File: NSObject {

// Insert code here to add functionality to your managed object subclass

    var filename: String?
    var type: String?
    var language: String?
    var rawUrl: String?
    var content: String?
}
