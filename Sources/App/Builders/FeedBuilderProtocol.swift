//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/02/21.
//

import Foundation
import Vapor
import SwiftDate

protocol FeedBuilder {
    
    associatedtype ModelType: Content
    
    var model: ModelType.Type {get}
    var apiErrorData: ModelType {get}
    func build(ids: [Int], stories: [ModelType], page: Int) -> OutputFeed
}

extension FeedBuilder {
    
    func transformToElapsedTime(with unixTimeStamp: Int?) -> String? {
        guard let timeStamp = unixTimeStamp else {return nil}
        
        let currentTime = Date()
        let storyTime = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateComponents = currentTime - storyTime
        
        let date = dateComponents.timeInterval.toString { formatter in
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .abbreviated
        }
        
        
        return date
        
    }
}
