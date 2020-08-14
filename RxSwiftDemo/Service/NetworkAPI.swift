//
//  NetworkAPI.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/13.
//  Copyright © 2018 張帥. All rights reserved.
//

import Foundation
import Moya

let PER_PAGE:UInt = 10

public enum GitHubAPI {
    /**
     GET /search/repositories
     
     q      string     Required. The search keywords, as well as any qualifiers.
     sort   string     The sort field. One of stars, forks, or updated. Default: results are sorted by best match.
     order  string     The sort order if sort parameter is provided. One of asc or desc. Default: desc
     */
    case repositories(_ params:[String : Any])
}

extension GitHubAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .repositories:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .repositories(let params):
            print("发起请求: \(params)")
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var validate: Bool {
        return false
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}
