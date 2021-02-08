//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/02/21.
//

import Foundation
import Vapor

struct Story: Content {
    var storyIdentifier: Int
    var title: String
    var subtitle: String
    var url: String
}
