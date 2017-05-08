//
//  Utils.swift
//  ComicStripApp
//
//  Created by Sethi, Pinkesh on 5/6/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    class func getImageFromView(view:UIView) -> UIImage{
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
    
    class func saveImageAsPNGToPhotos(name:String, image: UIImage){
       if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent(name+".png")
            try? data.write(to: filename)
        }
    }

    class func saveImageAsJPEGToPhotos(name:String, image: UIImage){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name+".jpeg")
            try? data.write(to: filename)
        }
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getImageFromPhotos(filePath:String) -> UIImage?{
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: filePath)
        if image == nil {
            print("missing image at: \(filePath)")
        }
        print("Loading image from path: \(filePath)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
    }
    
}
