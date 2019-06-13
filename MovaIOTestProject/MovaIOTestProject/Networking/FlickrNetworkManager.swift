//
//  FlickrNetworkManager.swift
//  MovaIOTestProject
//
//  Created by Oleksii on 6/13/19.
//  Copyright © 2019 Self Organization. All rights reserved.
//

import UIKit

final class FlickrNetworkManager {
    // MARK: - Types
    typealias FlickrSearchingImageResponse = ((Result<FlickrSearchingResponseModel, Error>) -> Void)
    typealias FlickrDownloadingImageResponse = ((Result<UIImage, Error>) -> Void)
    
    static let shared = FlickrNetworkManager()
    private init() { }
    
    private func generateFlickrUrl(with searchString: String) -> URL {
        var component = URLComponents()
        
        component.scheme = Constants.Api.FlickrApiScheme
        component.host = Constants.Api.FlickrApiHost
        component.path = Constants.Api.FlickrApiPath
        
        component.queryItems = [
            .init(name: Constants.Api.SearchMethodKey, value: Constants.Api.SearchMethod),
            .init(name: Constants.Api.APIKey, value: Constants.Api.Key),
            .init(name: Constants.Api.TextKey, value: searchString),
            .init(name: Constants.Api.ResponseFormatKey, value: Constants.Api.ResponseFormat),
            .init(name: Constants.Api.DisableJSONCallbackKey, value: Constants.Api.DisableJSONCallback)
        ]
        
        return component.url!
    }
    
    private func generatePhotoUrl(_ photo: Photo) -> URL? {
        guard
            let farm = photo.farm,
            let server = photo.server,
            let id = photo.id,
            let secret = photo.secret
        else {
            return nil
        }
        
        var host = Constants.Api.PhotoHost
        var path = Constants.Api.PhotoPath
        
        var component = URLComponents()
        
        component.scheme = Constants.Api.FlickrApiScheme
        
        host = host.replacingOccurrences(of: Constants.Api.Farm, with: String(farm))
        path = path.replacingOccurrences(of: Constants.Api.Server, with: String(server))
        path = path.replacingOccurrences(of: Constants.Api.Id, with: id)
        path = path.replacingOccurrences(of: Constants.Api.Secret, with: String(secret))
        
        component.host = host
        component.path = path
        
        return component.url!
    }
    
    public func fetchPhotosFromFlickr(by searchTerm: String?, complitionHandler: @escaping FlickrSearchingImageResponse) {
        guard let searchingString = searchTerm else {
            return
        }
        
        let url = self.generateFlickrUrl(with: searchingString)
        
        _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                complitionHandler(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    complitionHandler(.success(
                        try JSONDecoder().decode(FlickrSearchingResponseModel.self, from: data))
                    )
                } catch {
                    complitionHandler(.failure(error))
                }
            } else {
                complitionHandler(.failure(NetworkingError.invalidData))
            }
        }.resume()
    }
    
    public func downloadPhoto(_ photo: Photo, complitionHandler: @escaping FlickrDownloadingImageResponse) {
        guard let photoUrl = self.generatePhotoUrl(photo) else {
            return
        }
        
        _ = URLSession.shared.dataTask(with: photoUrl) { (data, response, error) in
            if let error = error {
                complitionHandler(.failure(error))
                return
            }
            
            if
                let data = data,
                let image = UIImage(data: data)
            {
                complitionHandler(.success(image))
            } else {
                complitionHandler(.failure(NetworkingError.invalidImageData))
            }
        }.resume()
    }
}
