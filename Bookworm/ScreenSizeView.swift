//
//  screensize.swift
//  Bookworm
//
//  Created by Ifang Lee on 11/2/21.
//
// Function declares an opaque return type, but the return statements in its body do not have matching underlying types
// -> meaning the some View return type of body requires that one single type is returned
// we can't return HStack in one path and VStack in another
// AnyView, a type erased wrapper, can solve the issue but impacts performance
//
import SwiftUI

struct ScreenSizeView: View {
    @Environment(\.presentationMode) var presentationMode //first use of env var binding
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        if sizeClass == .compact {
            return AnyView(VStack { // wrapped both our stacks in AnyView, a type erased wrapper
                Text("Active size class:")
                Text("COMPACT")
            }
            .font(.largeTitle))
        } else {
            return AnyView(HStack {
                Text("Active size class:")
                Text("Regular")
//                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                    .onTapGesture {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }
            }
            .font(.largeTitle))
        }
    }
}

struct screensize_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ScreenSizeView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
