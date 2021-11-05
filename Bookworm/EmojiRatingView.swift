//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Ifang Lee on 11/4/21.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16

    var body: some View {
        switch rating {
        case 1:
            return Text("💩")
        case 2:
            return Text("😵‍💫")
        case 3:
            return Text("😶")
        case 4:
            return Text("🙂")
        default:
            return Text("😍")
3        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
