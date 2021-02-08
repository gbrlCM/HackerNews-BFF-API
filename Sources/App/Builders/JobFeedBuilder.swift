//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/02/21.
//

import Foundation

struct JobFeedBuilder: FeedBuilder {
    typealias ModelType = InputJob
    
    var model: InputJob.Type = InputJob.self
    var apiErrorData: InputJob = .errorJob
    
    func build(ids: [Int], stories: [InputJob], page: Int) -> OutputFeed {
        let output = stories.filter{job in
            job != apiErrorData
        }.map { job in
            buildOutputJob(for: job)
        }
        
        let filteredIds = ids.filter {id in id != apiErrorData.id}
        
        return OutputFeed(ids: filteredIds, page: page, quantity: output.count, data: output)
    }
    
    
    private func buildOutputJob(for job: InputJob) -> OutputStory {
        let title = job.title ?? "null"
        let subtitle = buildSubtitle(for: job)
        let url = job.url ?? "https://news.ycombinator.com/item?id=\(job.id)"
        
        return OutputStory(storyIdentifier: job.id, title: title, subtitle: subtitle, url: url)
    }
    
    private func buildSubtitle (for job: InputJob) -> String {
        let elapsedTime = transformToElapsedTime(with: job.creationDate) ?? "null"
        let author = job.author ?? "John Doe"
        
        return "by \(author) \(elapsedTime) ago"
    }
    
}
