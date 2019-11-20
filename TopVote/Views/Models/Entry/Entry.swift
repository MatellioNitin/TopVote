//
//  Entry.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result

typealias Entries = [Entry]

final class Entry: Model, Hashable {
    
    var hashValue: Int {
        return _id?.hashValue ?? 0
    }
    
    // MARK: * Properties
    var _id: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var endDate: Date?
    
    var competition: Competition?
    
    var privateCompetition: PCompitionCreate?
    
    var account: Account?
    
    var title: String?
    
    var subTitle: String?
    
    var mediaType: String?
    
    var mediaUri: String?

    var mediaUriThumbnail: String?
    
    var byImageUri: String?
    
    var locationName: String?
    
    var numberOfShares: Int?

    var numberOfVotes: Int?
    
    var text: String?

    var valueVotes: Int?

    var rank: Int?
    
    var hasVoted: Bool?
    
    var value: String?
    
    var deepUrl: String?
    
    var shareText: String?

    var awardImage: UIImage? {
        if let rank = rank {
            if (rank == 1) {
                return UIImage(named: "icon-trophy-award-gold")
            } else if (rank == 2) {
                return UIImage(named: "icon-trophy-award-silver")
            } else if (rank == 3) {
                return UIImage(named: "icon-trophy-award-bronze")
            } else if (rank > 0 && rank <= 10) {
                return UIImage(named: "icon-trophy-award-blue")
            }
        }
        return nil
    }
    
    var shareURL: URL? {
        return URL(string: "http://www.topvoteapp.com/competition/\(competition?._id ?? "undefined")/entry/\(_id ?? "undefined")")
    }
    
    func isAuthor() -> Bool {
        return account?._id == AccountManager.session?.account?._id
    }
    
    /// The provider closure used by `moya` for default authorization headers used in requests against the api.
    
    static let providerClosure = { (target: Entry.API) -> Endpoint in
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
    
    static let stubbingBehavior = { (target: Entry.API) -> StubBehavior in
        return .never
    }
    
    /// The provider to use for middle ware of `moya`.
    
    static let provider = MoyaProvider<Entry.API>(endpointClosure: providerClosure, stubClosure: stubbingBehavior, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Moya.Response.JSONResponseDataFormatter)])
   
}




