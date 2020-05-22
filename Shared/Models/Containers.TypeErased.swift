////
////  Playlist.swift
////  VibeChecker-macOS
////
////  Created by Toph Allen on 5/18/20.
////  Copyright © 2020 Toph Allen. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//
//// Parent class for VibeChecker containers
//class Container: Object, Identifiable {
//    @objc dynamic var id = UUID().uuidString
//    @objc dynamic var name = ""
//    @objc dynamic var iTunesPersistentID: String? = nil
//
//
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}
//
//// Folders contain Containers
//class Folder: Container {
//    let children = List<AnyContainer>()
//}
//
//// Playlists contain Tracks
//class Playlist: Container {
//    let tracks = List<Track>()
//}
//
//
//// Following example on GitHub: https://github.com/realm/realm-cocoa/issues/1109#issuecomment-228144729
//class AnyContainer: Object, OutlineRepresentable {
//    @objc dynamic var typeName: String = ""
//    @objc dynamic var primaryKey: String = ""
//    
//    @objc dynamic var containingFolder: Folder? = nil
//
//    // A list of all subclasses that this wrapper can store
//    static let supportedClasses: [Container.Type] = [
//        Folder.self,
//        Playlist.self
//    ]
//
//    // Construct the type-erased container from any supported subclass
//    convenience init(_ container: Container) {
//        self.init()
//        typeName = String(describing: type(of: container))
//        guard let primaryKeyName = type(of: container).primaryKey() else {
//            fatalError("`\(typeName)` does not define a primary key")
//        }
//        guard let primaryKeyValue = container.value(forKey: primaryKeyName) as? String else {
//            fatalError("`\(typeName)`'s primary key `\(primaryKeyName)` is not a `String`")
//        }
//        primaryKey = primaryKeyValue
//    }
//
//    // Dictionary to look up subclass type from its name
//    static let methodLookup: [String: Container.Type] = {
//        var dict: [String: Container.Type] = [:]
//        for method in supportedClasses {
//            dict[String(describing: method)] = method
//        }
//        return dict
//    }()
//
//    // Use to access the *actual* Container value, using `as` to upcast
//    var value: Container {
//        guard let type = AnyContainer.methodLookup[typeName] else {
//            fatalError("Unknown container `\(typeName)`")
//        }
//        guard let value = try! Realm().object(ofType: type, forPrimaryKey: primaryKey) else {
//            fatalError("`\(typeName)` with primary key `\(primaryKey)` does not exist")
//        }
//        return value
//    }
//}
///// Caveats
///// - Inverse relationships on Container will not work properly. As a workaround, place the inverse relationship on AnyContainer.
///// - Containers will not be recursively added to Realm when an object containing an AnyPaymentMethod is added to Realm. Make sure you add each PaymentMethod individually.
///// - All subclasses supported by AnyPaymentMethod must use the same type of primary key (though it does not need to be String).
//
//
//extension AnyContainer: OutlineRepresentable {
//    var name: String {
//        return value.name
//    }
//    
//    var parent:
//    
//    var children {
//        LinkingObjects(fromType: Folder.self, property: "parent")
//    }
//    
//    var hasContent: Bool
//}
//
//
//// For use if I go with a different solution
//enum PlaylistKind: String {
//    case folder, regular, smart, other
//
//    func imageName() -> String {
//        switch self {
//        case .folder:
//            return "folder"
//        default:
//            return "music.note.list"
//        }
//    }
//}
