//
//  Competition.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result


typealias Competitions = [Competition]

final class Competition: Model {
    // MARK: * Properties
    
    var _id: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var endDate: Date?
    
    var startDate: Date?

    var title: String?
    
    var text: String?
    
     var description: String?
    
    var mediaUri: String?

    var byText: String?
    
    var byImageUri: String?
    
    var termsLink: String?
    
    var status: Int?
    
    var type: Int?
    
    var featured: Bool?
    
    var localized: Bool?
    
    var winner: Entry? = Entry()

    var giftCardURL: String?
    
    var deepUrl: String?
    
    var ownerName: String?
    
    var profileImage: String?
    
    var ownerId: String?
    
    var sType: String?
    
    var shareText: String?
    
    var autoApprove: Int? = 0
    var isPrivate: Int?
    
    var category:[String]? = [String]()

    /// The provider closure used by `moya` for default authorization headers used in requests against the api.
    
    static let providerClosure = { (target: Competition.API) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        var absolutePath = try! defaultEndpoint.urlRequest().url?.path ?? ""
        if let query = try! defaultEndpoint.urlRequest().url?.query {
            absolutePath = absolutePath + "?" + query
        }
        
        let headerFields = URLRequest.authHeaders(httpMethod: defaultEndpoint.method.rawValue, urlPath: absolutePath, version: target.version)
        let endpointWithHeaders = defaultEndpoint.adding(newHTTPHeaderFields: headerFields)
        return endpointWithHeaders
    }
    
    /// the stubbing behavior moya should use for this document. will stub fake data for accounts if set to enum value of .immediate.
    
    static let stubbingBehavior = { (target: Competition.API) -> StubBehavior in
        return .never
    }
    
    /// The provider to use for middle ware of `moya`.
    
    static let provider = MoyaProvider<Competition.API>(endpointClosure: providerClosure, stubClosure: stubbingBehavior, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Moya.Response.JSONResponseDataFormatter)])
    
    // MARK: * Instant methods
    
    func hasEnded() -> Bool {
        return status != 0
    }
    
    func timeRemainingString() -> String {
        var string = ""
        if let endDate = endDate {
            let days = (endDate.timeIntervalSinceNow / 86400)
            let hours = endDate.timeIntervalSinceNow.truncatingRemainder(dividingBy: 86400) / 3600
            let minutes = endDate.timeIntervalSinceNow.truncatingRemainder(dividingBy: 86400).truncatingRemainder(dividingBy: 3600) / 60
            string = String(format: "%dd %dh %dm", arguments: [Int(days), Int(hours), Int(minutes)])
//            if (days > 0) {
//                string = String(format: "%dd", arguments: [Int(days)])
//            } else if (hours > 0) {
//                string = String(format: "%dh", arguments: [Int(hours)])
//            } else if (minutes > 0) {
//                string = String(format: "%dm", arguments: [Int(minutes)])
//            } else {
//                string = "Expired"
//            }
        }
        return string
    }
    
    func winnerString() -> String {
        var string = ""
        string = "Won by "
        if let winnerName = winner?.account?.username ?? winner?.account?.name {
            string += winnerName
        }
        return string
    }
}



