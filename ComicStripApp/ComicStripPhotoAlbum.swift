//
//  ComicStripPhotoAlbum.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/10/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation

import Foundation
import Photos


class ComicStripPhotoAlbum: NSObject {
    static let albumName = "Comic strips"
    static let sharedInstance = ComicStripPhotoAlbum()
    
    var assetCollection: PHAssetCollection!
    
    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: ComicStripPhotoAlbum.albumName)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(error!)")
            }
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", ComicStripPhotoAlbum.albumName)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    func getAllComicsFromAlbum() ->[UIImage] {
        var imgArry = [UIImage]()
        let imageManager = PHCachingImageManager()
        if let result = fetchAssetCollectionForAlbum(){
            let photoAssets = PHAsset.fetchAssets(in: result, options: nil)
            photoAssets.enumerateObjects({ (object, count, stop) in
                if object is PHAsset{
                    let asset = object 
                    print("Inside  If object is PHAsset, This is number 1")
                    
                    let imageSize = CGSize(width: asset.pixelWidth,
                                           height: asset.pixelHeight)
                    
                    /* For faster performance, and maybe degraded image */
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .fastFormat
                    options.isSynchronous = true
                    
                    imageManager.requestImage(for: asset,
                                                      targetSize: imageSize,
                                                      contentMode: .aspectFill,
                                                      options: options,
                                                      resultHandler: {
                                                        (image, info) -> Void in
                                                        print("enum for image, This is number 2")
                                                        print(info ?? "No info for photo")
                                                       imgArry.append(image!)
                                                        
                    })
                    
                }
            })
        }
        return imgArry
    }
    
    func save(image: UIImage, sucess:@escaping (Bool) ->()) {
        if assetCollection == nil {
            return // if there was an error upstream, skip the save
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)
            
        }){ success, error in
            if success {
                sucess(true)
            } else {
                print("error \(error!)")
                sucess(false)
            }
        }
    }
}
