//
//  Constants.swift
//  MovaIOTestProject
//
//  Created by Oleksii on 6/13/19.
//  Copyright © 2019 Self Organization. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case invalidData
    case invalidImageData
    
    var localizedDescription: String {
        switch self {
        case .invalidData:
            return "Invalid Data"
        case .invalidImageData:
            return "Invalid Image Data"
        }
    }
}

enum Constants {
    enum Api {
        // url params
        static let FlickrApiScheme = "https"
        static let FlickrApiHost = "www.flickr.com"
        static let FlickrApiPath = "/services/rest/"
        static let PhotoHost = "farm<FARM>.staticflickr.com"
        static let PhotoPath = "/<SERVER>/<ID>_<SECRET>_m.jpg"
        
        // api keys
        static let SearchMethodKey = "method"
        static let APIKey = "api_key"
        static let TextKey = "text"
        static let ResponseFormatKey = "format"
        static let DisableJSONCallbackKey = "nojsoncallback"
        
        // api values
        static let SearchMethod = "flickr.photos.search"
        static let Key = "095d440972e3731091ee80fdf6a79e59"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        
        // photo url components
        static let Farm = "<FARM>"
        static let Server = "<SERVER>"
        static let Id = "<ID>"
        static let Secret = "<SECRET>"
    }
}
