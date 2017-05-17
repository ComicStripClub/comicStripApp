//
//  ComicFrameElement.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

// Represents an element that is part of a comic strip frame,
// such as a dialog bubble, sound effect, or style
protocol ComicFrameElement {
    
    var type: ComicElementType { get }
    
    // The icon to use for this element (for example, when presenting
    // a list of possible ComicFrameElements to the user)
    var icon: UIImage { get }
    
    // User-friendly of the element
    var name: String? { get }
    
    // The view associated with the element, if applicable
    var view: UIView! { get }
    
    // A list of possible actions that can be taken on this element.
    // These action buttons will be placed in a toolbar alongside
    // the element when it's selected.
    var actions: [UIBarButtonItem]? { get }
    
    // Each ComicFrameElement can decide what action to take when it's
    // applied to the frame.  In most cases, this will just be a call
    // to ComicFrame.addElement.
    var effectFunc: (_ frame: ComicFrame) -> Void { get }
}
