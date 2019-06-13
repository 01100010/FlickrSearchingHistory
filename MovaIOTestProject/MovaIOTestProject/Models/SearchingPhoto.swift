//
//  SearchingPhoto.swift
//  MovaIOTestProject
//
//  Created by Oleksii on 6/13/19.
//  Copyright © 2019 Self Organization. All rights reserved.
//

import Foundation
import RealmSwift

final class SearchingPhoto: Object {
    @objc dynamic var searchingTerm: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var imageSize: Int = 0
    @objc dynamic var createdAt: Date?
}
