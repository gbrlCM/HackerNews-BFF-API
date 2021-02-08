//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/02/21.
//

import Foundation
import Vapor

struct APIBearerAuthentication: BearerAuthenticator {
    
    enum AuthError: Error {
        case authenticationFailed
    }
    
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
        if bearer.token == Environment.get("TOKEN")! {
            request.auth.login(User(name: "pudim"))
        }
        return request.eventLoop.makeSucceededFuture(())
    }
}
