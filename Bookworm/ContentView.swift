//
//  ContentView.swift
//  Bookworm
//
//  Created by Ifang Lee on 11/1/21.
//
//@Binding, which lets us connect an @State property of one view to some underlying model data.

import SwiftUI
import CoreData

struct PushButton: View {
    let title: String
    @Binding var isOn: Bool

    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            self.isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct ContentView: View {
    @State private var rememberMe = false

    //XCode13
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // 2019 swift class
    // creates a fetch request for our “Student” entity, applies no sorting,
    // and places it into a property called students that has the the type FetchedResults<Student>
    @FetchRequest(entity: Student.entity(), sortDescriptors: []) var students: FetchedResults<Student>
    //We access the managed object context by calling the @Environment property wrapper
    @Environment(\.managedObjectContext) private var moc  //a managed object context

    var body: some View {
        VStack {
            VStack {
                PushButton(title: "Remember Me", isOn: $rememberMe)
                Text(rememberMe ? "On" : "Off")
                List {
                    ForEach(students, id: \.id) { student in
                        Text(student.name ?? "Unknown") // Core Data always generate optional Swift properties
                    }
                    .onDelete(perform: deleteStudents)
                }

                Button("Add") {
                    let firstNames = ["Noodles", "Aki", "Kiku", "Banana", "Noonoo", "Darth"]
                    let lastNames = ["Lee", "Ta", "Li", "Vander"]

                    let chosenFirstName = firstNames.randomElement()! //if not unwrap, the type will be optional string
                    let chosenLastName = lastNames.randomElement()!

                    //attach to a managed object context, where it should be stored.
                    let student = Student(context: self.moc)
                    student.id = UUID()
                    student.name = "\(chosenFirstName) \(chosenLastName)"
                    try? moc.save()
                }
            }

            NavigationView {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            VStack {
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                NavigationLink(destination: ScreenSizeView()) {
                                    Text("show sizeClass")
                                }
                            }
                        } label: {
                            Text(item.timestamp!, formatter: itemFormatter)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                Text("Select an item")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteStudents(offsets: IndexSet) {
        withAnimation {
            offsets.map { students[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
