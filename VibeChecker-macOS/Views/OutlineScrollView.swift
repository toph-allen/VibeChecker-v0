//
//  OutlineScrollView.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 6/17/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

/// This is all taken from [this StackOverflow answer](https://stackoverflow.com/questions/58416242/swiftui-scrollview-with-content-frame-update-closure/58416243#58416243) and I'm going to use it to try and make my scroll view anchor at the top.

import Foundation
import SwiftUI

struct ViewFrame: Equatable {
    
    /// A given identifier for the View to faciliate processing
    /// of frame updates
    let viewId : String
    
    
    /// An `Anchor` representation of the View
    let frameAnchor: Anchor<CGRect>
    
    // Conformace to Equatable is required for supporting
    // view udpates via `PreferenceKey`
    static func == (lhs: ViewFrame, rhs: ViewFrame) -> Bool {
        // Since we can currently not compare `Anchor<CGRect>` values
        // without a Geometry reader, we return here `false` so that on
        // every change on bounds an update is issued.
        return false
    }
}


/// A `PreferenceKey` to provide View frame updates in a View tree
struct FramePreferenceKey: PreferenceKey {
    typealias Value = [ViewFrame] // The list of view frame changes in a View tree.
    
    static var defaultValue: [ViewFrame] = []
    
    /// When traversing the view tree, Swift UI will use this function to collect all view frame changes.
    static func reduce(value: inout [ViewFrame], nextValue: () -> [ViewFrame]) {
        value.append(contentsOf: nextValue())
    }
}


/// Adds an Anchor preference to notify of frame changes
struct ProvideFrameChanges: ViewModifier {
    var viewId : String
    
    func body(content: Content) -> some View {
        content
            .transformAnchorPreference(key: FramePreferenceKey.self, value: .bounds) {
                $0.append(ViewFrame(viewId: self.viewId, frameAnchor: $1))
        }
    }
}

extension View {
    
    /// Adds an Anchor preference to notify of frame changes
    /// - Parameter viewId: A `String` identifying the View
    func provideFrameChanges(viewId : String) -> some View {
        ModifiedContent(content: self, modifier: ProvideFrameChanges(viewId: viewId))
    }
}




typealias ViewTreeFrameChanges = [String : CGRect]

/// Provides a block to handle internal View tree frame changes
/// for views using the `ProvideFrameChanges` in own coordinate space.
struct HandleViewTreeFrameChanges: ViewModifier {
    /// The handler to process Frame changes on this views subtree.
    /// `ViewTreeFrameChanges` is a dictionary where keys are string view ids
    /// and values are the updated view frame (`CGRect`)
    var handler : (ViewTreeFrameChanges)->Void
    
    func body(content: Content) -> some View {
        GeometryReader { contentGeometry in
            content
                .onPreferenceChange(FramePreferenceKey.self) {
                    self._updateViewTreeLayoutChanges($0, in: contentGeometry)
            }
        }
    }
    
    private func _updateViewTreeLayoutChanges(_ changes : [ViewFrame], in geometry : GeometryProxy) {
        let pairs = changes.map({ ($0.viewId, geometry[$0.frameAnchor]) })
        handler(Dictionary(uniqueKeysWithValues: pairs))
    }
}

extension View {
    /// Adds an Anchor preference to notify of frame changes
    /// - Parameter viewId: A `String` identifying the View
    func handleViewTreeFrameChanges(_ handler : @escaping (ViewTreeFrameChanges)->Void) -> some View {
        ModifiedContent(content: self, modifier: HandleViewTreeFrameChanges(handler: handler))
    }
}




enum TestEnum : String, CaseIterable, Identifiable {
    case one, two, three, four, five, six, seven, eight, nine, ten
    
    var id: String {
        rawValue
    }
}

struct TestView: View {
    private let _listHeaderViewId = "testView_ListHeader"
    
    var body: some View {
        ScrollView {
            // Header View
            Text("This is some Header")
                .provideFrameChanges(viewId: self._listHeaderViewId)
            
            // List of test values
            ForEach(TestEnum.allCases) {
                Text($0.rawValue)
                    .padding(60)
            }
        }
        .handleViewTreeFrameChanges {
            self._updateViewTreeLayoutChanges($0)
        }
    }
    
    private func _updateViewTreeLayoutChanges(_ changes : ViewTreeFrameChanges) {
        print(changes)
    }
}

