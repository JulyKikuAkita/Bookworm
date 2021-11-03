//
//  ContentView.swift
//  Bookworm
//
//  Created by Ifang Lee on 11/1/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: []) var books: FetchedResults<Book>

    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            Text("Count: \(books.count)")
                .navigationBarTitle("Bookworm")
                .navigationBarItems(trailing: Button(action: {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
