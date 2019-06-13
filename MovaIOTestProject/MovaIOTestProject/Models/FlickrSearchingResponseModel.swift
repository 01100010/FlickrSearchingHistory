//
//  FlickrSearchingResponseModel.swift
//  MovaIOTestProject
//
//  Created by Oleksii on 6/13/19.
//  Copyright © 2019 Self Organization. All rights reserved.
//

import Foundation

final class Photo: Codable {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
}

final class SearchingResponse: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo: [Photo]?
}

final class FlickrSearchingResponseModel: Codable {
    var photos: SearchingResponse?
}
