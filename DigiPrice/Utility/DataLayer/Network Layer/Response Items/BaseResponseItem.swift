//
//  BaseResponseItem.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

/**
 A generic response model that contains the response data, success status, response code, and message.
 This struct is used as a base response structure to provide a common format for different response models.
 Use this struct to decode and parse the response received from a network API call that using shared structure.
 */
struct BaseResponseItem<T: Decodable> {
    let data: T?
    let success: Bool
    let code: Int
    let message: String?
    
    private enum CodingKeys : String, CodingKey {
        case data, success, code, message
    }
}

extension BaseResponseItem: Decodable  {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            data = try container.decode(T.self, forKey: .data)
        } catch {
            data = nil
        }
        
        success = try container.decode(Bool.self, forKey: .success)
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
