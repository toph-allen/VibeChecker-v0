//
//  Folder+Extensions.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 6/22/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation
import CoreData

extension Folder {
    var descendants: [Container] {
        var descendants: [Container] = []
        for child in children ?? [] {
            descendants.append(child as! Container)
            if let childFolder = child as? Folder {
                descendants.append(contentsOf: childFolder.descendants)
            }
        }
        return descendants
    }
    
    var containsVibes: Bool {
        get {
            for descendant in descendants {
                if descendant is Vibe {
                    return true
                }
            }
            return false
        }
    }
    
    var containsPlaylists: Bool {
        get {
            for descendant in descendants {
                if descendant is Playlist {
                    return true
                }
            }
            return false
        }
    }
}
