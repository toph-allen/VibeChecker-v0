//
//  VisualEffectView.swift
//  VibeChecker-macOS
//
//  Created by Toph Allen on 6/16/20.
//  Copyright © 2020 Toph Allen. All rights reserved.
//

import SwiftUI


struct VisualEffectView: NSViewRepresentable
{
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
    
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

struct VisualEffectView_Previews: PreviewProvider {
    static var previews: some View {
        VisualEffectView(material: .contentBackground, blendingMode: .behindWindow)
    }
}
