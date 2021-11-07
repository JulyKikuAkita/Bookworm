//
//  DetailView.swift
//  Bookworm
//
//  Created by Ifang Lee on 11/5/21.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false

    let book: Book

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Doge")
                        .frame(maxWidth: geometry.size.width)

                    Text(self.book.genre?.uppercased() ?? "DOGE")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }

                Text(book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(book.date ?? Date(timeIntervalSinceReferenceDate: 0), formatter: bookDateFormatter)
                    .font(.footnote)

                Text(book.review ?? "No review")
                    .padding()

                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                Spacer()
            }
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                deleteBook()
            }, secondaryButton: .cancel())
        }
    }

    func deleteBook() {
        moc.delete(book)

        // uncomment this line if you want to make the deletion permanent
        // try? self.moc.save()
        presentationMode.wrappedValue.dismiss()
    }
}

private let bookDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.timeZone = .current
    return formatter
}()

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Noodle's younger sister"
        book.author = "Aki Noodle"
        book.genre = "Doge"
        book.rating = 4
        book.review = "This was a great book; I tested it."
        book.date = Date()
        return NavigationView {
            DetailView(book: book)
        }
    }
}
