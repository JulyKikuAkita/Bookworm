//
//  ContentView.swift
//  Bookworm
//
//  Created by Ifang Lee on 11/1/21.
//

import SwiftUI
import CoreData

/**
 Challenge:
 1. Right now it’s possible to select no genre for books, which causes a problem for the detail view.
 Please fix this, either by forcing a default, validating the form, or showing a default picture for unknown genres – you can choose.
 2. Modify ContentView so that books rated as 1 star have their name shown in red.
 3. Add a new “date” attribute to the Book entity, assigning Date.now to it so it gets the current date and time, then format that nicely somewhere in DetailView.
 */
struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>

    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                .font(.headline)
                                .foregroundColor(book.rating == 1 ? Color.red : Color.primary)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }){
                    Image(systemName: "plus")
                })
            //when we present a new view as a sheet we need to explicitly pass in a managed object context for it to use.
            // sheet does not share ancestor's view's env
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView().environment(\.managedObjectContext, moc)
                }
        }
    }

    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]

            // delete it from the context
            moc.delete(book)
        }

        // save the context
        if moc.hasChanges {
            try? moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
