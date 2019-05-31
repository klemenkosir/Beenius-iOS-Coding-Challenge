//
//  ImageDownloader.swift
//  Beenius-iOS-Challenge
//
//  Created by Klemen Košir on 31/05/2019.
//  Copyright © 2019 Klemen Košir. All rights reserved.
//

import UIKit

typealias ImageDownloaderCompletion = (_ image: UIImage?) -> Void

class ImageDownloader: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    static let shared = ImageDownloader()
    
    struct ImageSize: Hashable {
        static let `default` = ImageSize(width: 200, height: 200)
        let width: CGFloat
        let height: CGFloat
    }
    
    private var downloadSession: URLSession!
    private var urlCache: URLCache!
    
    private var taskQueue = [Int: (url: URL, block: ImageDownloaderCompletion, imageSize: ImageSize)]()
    
    private var taskDataCache = [Int: Data]()
    
    private var instanceCache = [URL : [ImageSize : UIImage]]()
    
    private override init() {
        super.init()
        let config = URLSessionConfiguration.default
        urlCache = URLCache(memoryCapacity: 10*1024*1024, diskCapacity: 50*1024*1024, diskPath: nil)
        config.urlCache = urlCache
        config.requestCachePolicy = .returnCacheDataElseLoad
        downloadSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    func downloadImage(url: URL, size: CGSize? = nil, completion: @escaping ImageDownloaderCompletion) {
        var imageSize: ImageSize!
        if let size = size {
            imageSize = ImageSize(width: size.width, height: size.height)
        }
        else {
            imageSize = ImageSize.default
        }
        if let instanceCacheImage = instanceCache[url]?[imageSize] {
            completion(instanceCacheImage)
        }
        else if let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url)) {
            if let cachedImage = UIImage(data: cachedResponse.data) {
                DispatchQueue.global(qos: .userInitiated).async {
                    let scaledImage = self.optimize(image: cachedImage, for: imageSize)
                    self.instanceCache[url] = [imageSize : scaledImage]
                    DispatchQueue.main.async {
                        completion(scaledImage)
                    }
                }
                return
            }
        }
        
        let imageDownloadTask = downloadSession.dataTask(with: url)
        taskQueue[imageDownloadTask.taskIdentifier] = (url, completion, imageSize)
        imageDownloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        var taskData = taskDataCache[dataTask.taskIdentifier] ?? Data()
        taskData.append(data)
        taskDataCache[dataTask.taskIdentifier] = taskData
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let taskIdentifier = task.taskIdentifier
        if error == nil {
            if  let data = taskDataCache[taskIdentifier],
                let image = UIImage(data: data) {
                let resizedImage = optimize(image: image)
                if let (url, block, imageSize) = taskQueue[taskIdentifier],
                    let originalUrl = task.originalRequest?.url {
                    if url.absoluteString == originalUrl.absoluteString {
                        // we manually add image to the url cache
                        storeDataToCache(response: task.response, data: data, url: originalUrl)
                        instanceCache[originalUrl] = [imageSize : resizedImage]
                        DispatchQueue.main.async {
                            block(resizedImage)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            block(nil)
                        }
                    }
                }
            }
            
        }
        else if let (_, block, _) = taskQueue[taskIdentifier] {
            DispatchQueue.main.async {
                block(nil)
            }
        }
        taskQueue.removeValue(forKey: taskIdentifier)
        taskDataCache.removeValue(forKey: taskIdentifier)
    }
    
    private func storeDataToCache(response: URLResponse? , data: Data, url: URL) {
        guard let response = response else { return }
        urlCache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: URLRequest(url: url))
    }
    
    private func optimize(image: UIImage, for size: ImageSize = ImageSize(width: 200, height: 200)) -> UIImage {
        let newImageSizeScale = size.width/max(image.size.width, image.size.height)
        let newImageSize = image.size.applying(.init(scaleX: newImageSizeScale, y: newImageSizeScale))
        return scaleImage(with: image, scaledTo: newImageSize)
    }
    
    private func scaleImage(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
