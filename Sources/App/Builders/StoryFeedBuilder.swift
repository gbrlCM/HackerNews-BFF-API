//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/02/21.
//

import Foundation
import Vapor

struct StoryFeedBuilder: FeedBuilder {
    typealias ModelType = InputStory
    
    var model = InputStory.self
    var apiErrorData: InputStory = .errorStory
    
    func build(ids: [Int], stories: [ModelType], page: Int) -> OutputFeed {
        let formatedStory = stories.filter{story in
            story != apiErrorData
        }.map { story in
            buildOutput(forStory: story)
        }
        
        let filteredIds = ids.filter {id in id != apiErrorData.id}
        
        return OutputFeed(ids: filteredIds, page: page, quantity: formatedStory.count, data: formatedStory)
    }
    
    private func buildOutput(forStory story: InputStory) -> OutputStory {
        let title = story.title ?? "null"
        let subtitle = buildSubtitle(forStory: story)
        let url = story.url ?? "https://news.ycombinator.com/item?id=\(story.id)"
        
        return OutputStory(storyIdentifier: story.id, title: title, subtitle: subtitle, url: url)
    }
    
    private func buildSubtitle(forStory story: InputStory) -> String {
        let elapsedTime = transformToElapsedTime(with: story.creationDate) ?? "0"
        let score = story.score ?? 0
        let author = story.author ?? "John Doe"
        
        let subtitle = "\(score) points, by \(author), \(elapsedTime) ago"
        return subtitle
    }
}
