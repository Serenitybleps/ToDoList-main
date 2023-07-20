//
//  ContentView.swift
//  ToDoList
//
//  Created by Scholar on 7/18/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @State private var showNewTask = false
    @FetchRequest(
            entity: ToDo.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \ToDo.id, ascending: false) ])
        
    var toDoItems: FetchedResults<ToDo>
    var body: some View {
        ZStack{
            Color(hex: "#CDD7B6")
                .ignoresSafeArea()
            VStack {
                HStack{
                    Text("Journal")
                        
                        .fontWeight(.bold)
                        .font(.custom("KosugiMaru-Regular", size: 40))
                    Spacer()
        
                    
                    Button(action: {
                        self.showNewTask = true
                    }){
                        Text("+")
                            .font(.system(size:40))
                            .foregroundColor(Color.black)
                        
                    }
                    .buttonStyle(.borderedProminent)
                              .cornerRadius(300)
                              .tint(Color(hex:"8b9475"))
                              .controlSize(.regular)
                              .shadow(radius: 1)
                    
                    
                }
                .padding()
                Spacer()
                List {
                    ForEach (toDoItems) { toDoItem in
                        if toDoItem.isImportant == true {
                            Text("‼️" + (toDoItem.title ?? "No title"))
                                .font(.custom("KosugiMaru-Regular", size: 20))
                                
                        } else {
                            Text(toDoItem.title ?? "No title")
                                .font(.custom("KosugiMaru-Regular", size: 20))
                        }
                        
                    }
                    .onDelete(perform: deleteTask)
                }
                // .listStyle(.plain)
            }
            if showNewTask {
                NewToDoView(showNewTask: $showNewTask, title: "", isImportant: false)
            }
        }
        
    }
    private func deleteTask(offsets: IndexSet) {
            withAnimation {
            offsets.map { toDoItems[$0] }.forEach(context.delete)

            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


