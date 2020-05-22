//
//  SidebarContainer.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 5/21/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import Foundation

class SidebarContainer: OutlineRepresentable {
    var RealmContainer: Container
    
    var name: String
    
    var children: [OutlineRepresentable.Type]?
    
    var parent: OutlineRepresentable.Type?
    
    var hasContent: Bool
    
    static func == (lhs: SidebarContainer, rhs: SidebarContainer) -> Bool {
        <#code#>
    }
    
    
}
