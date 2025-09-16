//
//  MainView.swift
//  Qoobym
//
//  Created by Anatoliy Petrov on 10. 5. 2025..
//

import SwiftUI
import CoreData

struct MainView: View {
    @State private var showAddBookSheet = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BookStorageModel.title, ascending: true)],
        animation: .default)
    private var books: FetchedResults<BookStorageModel>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cyan.opacity(0.5)
                VStack {
                    VStack(alignment: .leading) {
                        HStack{
                            Button{
                                showAddBookSheet.toggle()
                            }label: {
                                Text("Add a new book")
                                    .foregroundStyle(.black)
                                Image("Add")
                            }.padding()
                                .sheet(isPresented: $showAddBookSheet) {
                                    AddBookView()
                                    Spacer()
                                }
                        }
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                ForEach(books, id: \.self) { book in
                                    NavigationLink(destination: BookDetailView(book: book)) {
                                        VStack(alignment: .leading) {
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(height: 120)
                                                    .cornerRadius(8)
                                                    .shadow(radius: 2)
                                                    .opacity(0.2)
                                                
                                                if let data = book.cover, let uiImage = UIImage(data: data) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 100)
                                                        .cornerRadius(8)
                                                        .shadow(radius: 2)
                                                        .padding(5)
                                                } else {
                                                    Rectangle()
                                                        .fill(Color.white)
                                                        .frame(height: 120)
                                                        .cornerRadius(8)
                                                        .shadow(radius: 2)
                                                        .opacity(0.2)
                                                    Image("yellowBook")
                                                    Text("☔️")
                                                        .offset(x: 5, y: -10)
                                                }
                                            }
                                            Text(book.title ?? "No Title")
                                                .font(.headline)
                                            Text(book.author ?? "No Autor")
                                                .font(.caption)
                                                .opacity(0.5)
                                        }
                                    }
                                    
                                }
                                .padding()
                            }
                        }
                    }
                    Spacer()
                    
                }.safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 100)
                }
                
            }.ignoresSafeArea()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Image("Logo")
                            Text("Hello Anatolii!")
                                .font(.headline)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Button tapped")
                        } label: {
                            Image("Profile")
                        }
                    }
                }
        }
    }
}

#Preview {
    MainView()
}
