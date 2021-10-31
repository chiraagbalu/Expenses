//
//  ContentView.swift
//  Expenses
//
//  Created by Chiraag Balu on 10/29/21.
//

import SwiftUI


//creates struct for expense item type
struct ExpenseItem : Identifiable, Codable {
    //allows for dynamic ID creation and assignment
    let id = UUID()
    //each expense has a name, type of expense, and amount
    let name : String
    let type: String
    let amount : Int
}

//class for expenses list
class Expenses: ObservableObject {
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var listRowColor = Color.white
    var body: some View {
        NavigationView{
            List {
                ForEach(expenses.items) { item in
                    if(item.type=="business") {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text("$\(item.amount)")
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius:5).foregroundColor(Color(red: 0.5, green: 0.7, blue: 0.9)))

                    } else {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text("$\(item.amount)")
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius:5).foregroundColor(Color(red: 0.99, green: 0.5, blue: 0.5)))
                        
                    }
                    
                }
                .onDelete(perform: removeItems)
                .listRowBackground(listRowColor)

            }
            .navigationBarTitle("Expenses")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingAddExpense = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
            })
            
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
