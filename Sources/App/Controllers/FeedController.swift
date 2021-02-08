//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/02/21.
//

import Foundation
import Vapor

struct FeedController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let feed = routes.grouped(APIBearerAuthentication()).grouped(.feed)
        
        feed.group(.new) { newFeed in
            newFeed.get(use: initialNewFeed)
            newFeed.post(":page", use: appendToNewFeed)
        }
        feed.group(.job) { newFeed in
            newFeed.get(use: initialJobFeed)
            newFeed.post(":page", use: appendToJobFeed)
        }
        feed.group(.top) { newFeed in
            newFeed.get(use: initialTopFeed)
            newFeed.post(":page", use: appendToTopFeed)
        }
        
    }
    
    //MARK: New Feed Routes
    func initialNewFeed(req: Request) throws -> EventLoopFuture<OutputFeed> {
        guard req.auth.has(User.self) else { throw Abort(.unauthorized) }
        let ids = try storyIdentifers(req.client, for: .new)
        return getStories(req, for: ids, page: 0, using: StoryFeedBuilder())
    }
    
    func appendToNewFeed(req: Request) throws -> EventLoopFuture<OutputFeed> {
        guard req.auth.has(User.self) else { throw Abort(.unauthorized) }
        let page = retrievePageFromParameter(of: req)
        let ids = try retriveIdsFromBody(of: req)
        return getStories(req, for: ids, page: page, using: StoryFeedBuilder())
    }
    
    //MARK: Top Feed Routes
    func initialTopFeed(req: Request) throws -> EventLoopFuture<OutputFeed> {
        guard req.auth.has(User.self) else { throw Abort(.unauthorized) }
        let ids = try storyIdentifers(req.client, for: .top)
        return getStories(req, for: ids, page: 0, using: StoryFeedBuilder())
    }
    
    func appendToTopFeed(req: Request) throws -> EventLoopFuture<OutputFeed> {
        guard req.auth.has(User.self) else { throw Abort(.unauthorized) }
        let page = retrievePageFromParameter(of: req)
        let ids = try retriveIdsFromBody(of: req)
        return getStories(req, for: ids, page: page, using: StoryFeedBuilder())
    }
    
    //MARK: Job Feed Routes
    func initialJobFeed(req: Request) throws -> EventLoopFuture<OutputFeed> {
        guard req.auth.has(User.self) else { throw Abort(.unauthorized) }
        let ids = try storyIdentifers(req.client, for: .job)
        return getStories(req, for: ids, page: 0, using: JobFeedBuilder())
    }
    
    func appendToJobFeed(req: Request) throws -> EventLoopFuture<OutputFeed> {
        guard req.auth.has(User.self) else { throw Abort(.unauthorized) }
        let page = retrievePageFromParameter(of: req)
        let ids = try retriveIdsFromBody(of: req)
        return getStories(req, for: ids, page: page, using: StoryFeedBuilder())
    }
    
    //MARK: Request Handlers
    private func storyIdentifers(_ client: Client, for storyType: StoryType) throws -> EventLoopFuture<[Int]> {
        return client.get(storyType.url).flatMapThrowing { res in
           return try res.content.decode([Int].self)
        }
    }
    
    private func getStories<Builder: FeedBuilder>(_ req: Request, for idFuture: EventLoopFuture<[Int]>, page: Int, using builder: Builder) -> EventLoopFuture<OutputFeed> {
        var identifersOutput: [Int] = []
        
        return idFuture.map { identifers -> ArraySlice<Int> in
            identifersOutput = identifers
            let boundarie = Boundary(for: page)
            return identifers[boundarie.lower..<boundarie.upper]
        }.flatMapEach(on: req.eventLoop) {
            id in
            req.client.get(storyRoute(for: id))
                .flatMapThrowing { res in
                guard let story = try? res.content.decode(builder.model) else { return builder.apiErrorData }
                return story
            }
        }.map { stories in
            builder.build(ids: identifersOutput, stories: stories, page: page)
        }
    }
    
    private func retriveIdsFromBody(of req: Request) throws -> EventLoopFuture<[Int]> {
        let data = try req.content.decode([Int].self)
        return data.encodeResponse(for: req).flatMapThrowing { res in try res.content.decode([Int].self) }
    }
    
    private func retrievePageFromParameter(of req: Request) -> Int {
        guard let page = Int(req.parameters.get("page")!) else { return 0 }
        return page
    }
    
}

//MARK: Routing Strings
extension FeedController {
    
    enum StoryType: String {
        case top = "topstories"
        case new = "newstories"
        case job = "jobstories"
        
        var url: URI {
            "https://hacker-news.firebaseio.com/v0/\(self.rawValue).json"
        }
    }
    
    func storyRoute(for id: Int) -> URI {
        "https://hacker-news.firebaseio.com/v0/item/\(id).json"
    }
}

private extension PathComponent {
    
    static var top: PathComponent {
        PathComponent(stringLiteral: FeedController.StoryType.top.rawValue)
    }
    
    static var new: PathComponent {
        PathComponent(stringLiteral: FeedController.StoryType.new.rawValue)
    }
    
    static var job: PathComponent {
        PathComponent(stringLiteral: FeedController.StoryType.job.rawValue)
    }
    
    static var feed: PathComponent {
        PathComponent(stringLiteral: "feed")
    }
}

extension FeedController {
    
    private struct Boundary {
        var page: Int
        var maxQuantity: Int = 50
        var lower: Int {
            page * maxQuantity
        }
        var upper: Int {
            lower + maxQuantity
        }
        
        init(for page: Int) {
            self.page = page
        }
    }
}
