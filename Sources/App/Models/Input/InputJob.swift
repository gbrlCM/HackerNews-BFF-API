//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/02/21.
//

import Foundation
import Vapor

struct InputJob: Content, Equatable {
    var id: Int
        var deleted: Bool?
        var type: String
        var author: String?
        var creationDate: Int?
        var isDead: Bool?
        var commentsIds: [Int]?
        var descriptionText: String?
        var title: String?
        var url: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case deleted
            case type
            case url
            case title
            case author = "by"
            case descriptionText = "text"
            case creationDate = "time"
            case isDead = "dead"
            case commentsIds = "kids"
        }
}

extension InputJob {
    static var errorJob: InputJob {
        InputJob(id: 666, deleted: true, type: "error", author: "error", creationDate: 0, isDead: true, commentsIds: [], descriptionText: "error", title: "error", url: "error")
    }
}
