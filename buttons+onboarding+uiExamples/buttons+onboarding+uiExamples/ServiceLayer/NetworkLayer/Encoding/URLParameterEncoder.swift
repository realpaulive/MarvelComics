//
//  URLParameterEncoder.swift
//  buttons+onboarding+uiExamples
//
//  Created by Paul Ive on 29.05.23.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    public static func encode (urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.badURL }
        if var urlComponents = URLComponents (url: url,
                                              resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItems = URLQueryItem(name: key,
                                              value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItems)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue ("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
