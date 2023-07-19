//
//  NewToDoView.swift
//  ToDoList
//
//  Created by Scholar on 7/18/23.
//

import SwiftUI

struct NewToDoView: View {
    
    @State private var promptRandom = "What's on your mind?"
    @State private var name = ""
    
        let prompts = ["Think about one thing that made you feel productive today", "What made you smile today?", "What's a practice, place, or person that helps you reduce stress in your life?", "Write a letter to your younger self", "What do you look forward for", "What is something you learned recently"]
    
    @Environment(\.managedObjectContext) var context
    @Binding var showNewTask : Bool
    @State var title: String
    @State var isImportant: Bool
    var body: some View {
        ZStack{
            Color(hex: "#F6EFE8")
            .ignoresSafeArea()
            
            VStack{
                
                VStack {
                    
                    
                    Text (promptRandom)
                        .font(.title)
                }
                
                
                Button("New Prompt"){
                    
                    let random = Int.random (in:1..<6)
                    let prompt = prompts[random]
                    promptRandom = prompt
                }//button
                .foregroundColor(.black)
                
                
                
                
                .padding()
                TextField("Thoughts...", text: $title, axis: .vertical)
                    .lineLimit(5, reservesSpace:true)
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(15)
                    .padding()
                Toggle(isOn: $isImportant) {
                    Text("Pinned?")
                    
                }
                .padding()
                
                Button(action: {
                    self.addTask(title: self.title, isImportant: self.isImportant)
                    self.showNewTask = false
                }) {
                    Text("Add")
                }
                .padding()
            }
        }
        
        
        
    }
    private func addTask(title: String, isImportant: Bool = false) {
            
        let task = ToDo(context: context)
        task.id = UUID()
        task.title = title
        task.isImportant = isImportant
                
        do {
                    try context.save()
        } catch {
                    print(error)
        }
        
    }
}

struct NewToDoView_Previews: PreviewProvider {
    static var previews: some View {
        NewToDoView(showNewTask: .constant(true), title: "", isImportant: false)
    }
}


extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}
