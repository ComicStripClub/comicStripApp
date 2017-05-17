//
//  FilterElement.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/13/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class FilterElement: ComicFrameElement {
    var actions: [UIBarButtonItem]? = nil
    lazy var effectFunc: (ComicFrame) -> Void = { (comicFrame) in
        comicFrame.currentFilter = self.filter
    }
    var icon: UIImage
    var type: ComicElementType = .style
    var view: UIView!
    var name: String?
    var filter: (key: String, value: () -> ImageProcessingOperation)
    init(filterIconName: String, filter: (key: String, value: () -> ImageProcessingOperation)) {
        self.filter = filter
        self.icon = UIImage(named: filterIconName)!
        self.name = filter.key
    }
}
