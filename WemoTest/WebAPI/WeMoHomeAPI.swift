//
//  WeMoHomeAPI.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/6.
//

import Foundation
import DolphinHTTP

enum NewsCase: String {
    case movie = "Movie"
    case sport = "Sports"
    case nature = "Nature"
    case science = "Science"
    case technology = "Technology"
}

final class WeMoHomeAPI {
    // https://newsapi.org/v2/everything?q=Movie&apiKey=0bd22af1fccc4f9d940bd454fbc1c539
    private let loader: HTTPLoader
    private let apiKey: String
    
    init(loader: HTTPLoader = URLSessionLoader(session: URLSession.shared), key: String = "0bd22af1fccc4f9d940bd454fbc1c539") {
        self.loader = loader
        self.apiKey = key
    }
    
    func loadNews(newsCase: NewsCase, completion: @escaping((Result<SuccessResponse, FailureResponse>) -> Void)) {
        
        let url = URL(string: "https://newsapi.org")!
        var r = HTTPRequest(scheme: url.scheme ?? "https")
        r.host = url.host
        r.port = url.port
        r.path = "/v2/everything"
        r.method = .get
        r.queryItems = [
            URLQueryItem(name: "q", value: newsCase.rawValue),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        // https://newsapi.org/v2/everything?q=Movie&apiKey=0bd22af1fccc4f9d940bd454fbc1c539
        // https://newsapi.org/v2/everything?q=Sports&apiKey=0bd22af1fccc4f9d940bd454fbc1c539
        loader.load(request: r) { result in
            
            switch result {
            case.failure(let error):
                
                completion(.failure(FailureResponse(statusCode: nil, type: .httpError(error))))
                
            case .success(let response):
                
                guard let data = response.body else {
                    completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .noResponseBody)))
                    return
                }
                
                switch response.status {
                case .success, .create:
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let items = try decoder.decode(News.self, from: data)
                        
                        let successResponse = SuccessResponse(statusCode: response.status.rawValue, type: .normal(content: items))
                        
                        completion(.success(successResponse))
                        
                    } catch {
                        
                        completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .parsingFailed)))
                    }
                    
                case .badRequest, .unauthorized, .forbidden, .notFound, .methodNotAllowed:
                    
                    completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .parsingFailed)))
                    
                    
                case .serverError:
                    
                    completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .statusCodeError)))
                    
                default:
                    
                    completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .statusCodeError)))
                }
                
            }
            
        }
    }
    
}



struct SuccessResponse {
    
    enum SuccessType {
        case ok
        case normal(content: Codable)
    }
    
    let statusCode: Int?
    let type: SuccessType
    
    let description: String?
    let detail: String?
    
    init(statusCode: Int?, type: SuccessType, description: String? = nil, detail: String? = nil) {
        self.statusCode = statusCode
        self.type = type
        self.description = description
        self.detail  = detail
    }
}

struct FailureResponse: Error {
    
    enum ErrorType {
        case httpError(HTTPError)
        case statusCodeError
        case noResponseBody
        case parsingFailed
        case incorrectResponse
        case missingParameter
        case other(Error)
    }
    
    let statusCode: Int?
    let type: ErrorType
    
    let description: String?
    let detail: String?
    
    init(statusCode: Int?, type: ErrorType, description: String? = nil, detail: String? = nil) {
        self.statusCode = statusCode
        self.type = type
        self.description = description
        self.detail  = detail
    }
}
