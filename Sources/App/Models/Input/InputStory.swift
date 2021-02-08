//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/02/21.
//

import Foundation
import Vapor

struct InputStory: Content, Equatable {
    var id: Int
        var deleted: Bool?
        var type: String
        var author: String?
        var creationDate: Int?
        var isDead: Bool?
        var commentsIds: [Int]?
        var commentCount: Int?
        var score: Int?
        var title: String?
        var url: String?
        
        
        enum CodingKeys: String, CodingKey {
            case id
            case deleted
            case type
            case url
            case title
            case score
            case author = "by"
            case creationDate = "time"
            case isDead = "dead"
            case commentsIds = "kids"
            case commentCount = "descendants"
        }
}

extension InputStory {
    static var errorStory: InputStory {
        InputStory(id: 666, deleted: true, type: "error", author: "error", creationDate: 0, isDead: true, commentsIds: [], commentCount: 0, score: 0, title: "error", url: "error")
    }
}
