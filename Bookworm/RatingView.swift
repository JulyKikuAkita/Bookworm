//
//  RatingView.swift
//  Bookworm
//
//  Created by Ifang Lee on 11/4/21.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int

    var label = ""
    var maximumRaing = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offcolor = Color.gray
    var onColor = Color.yellow

    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRaing + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offcolor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
                // Way1: Voice over: x star button is selected for selected; the rest is star button
//                    .accessibilityLabel("\(number == 1 ? "1 start" : "\(number) starts")")
//                    .accessibilityRemoveTraits(.isImage)
//                    .accessibilityAddTraits(number > rating ? .isButton : [.isButton, .isSelected])
            }
        }
        //Way2: use Hstack as a whole rating element
        .accessibilityElement()
        .accessibilityLabel(label)
        .accessibilityValue(rating == 1 ? "1 start" : "\(rating) stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if rating < maximumRaing { rating += 1 }
            case .decrement:
                if rating > 1 {rating -= 1 }
            default:
                break
            }
        }

    }

    /**
     If the number that was passed in is greater than the current rating,
        return the off image if it was set, otherwise return the on image.
     If the number that was passed in is equal to or less than the current rating, return the on image.
     */
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

/**
 constant bindings
 bindings that have fixed values, which on the one hand means they can’t be changed in the UI,
 but also means we can create them trivially – they are perfect for previews.
 */
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
