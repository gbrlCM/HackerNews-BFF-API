//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/02/21.
//

import Foundation
import Vapor

struct OutputFeed: Content {
    var ids: [Int]
    var page: Int
    var quantity: Int
    var data: [OutputStory]
}
