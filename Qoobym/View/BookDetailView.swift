//
//  BookDetailView.swift
//  Qoobym
//
//  Created by Anatoliy Petrov on 11. 5. 2025..
//

import SwiftUI

struct BookDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var book: BookStorageModel
    
    @State private var editedTitle: String = ""
    @State private var editedAuthor: String = ""
    @State private var quoteList: [String] = []
    @State private var newQuote: String = ""
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    @State private var editingQuoteIndex: Int?
    @State private var editedQuoteText: String = ""
    @State private var showEditAlert = false
    @State private var showEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 180)
                            .clipped()
                            .cornerRadius(10)
                    } else if let data = book.cover, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 180)
                            .clipped()
                            .cornerRadius(10)
                    } else {
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 120, height: 180)
                            .cornerRadius(10)
                        
                    }
                }.overlay(
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                        .padding(6),
                    alignment: .bottomTrailing
                )
                
                VStack(alignment: .leading) {
                    TextField("Title", text: $editedTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Author", text: $editedAuthor)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("💾 Save Changes") {
                        saveChanges()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("🗑 Delete book", role: .destructive) {
                        viewContext.delete(book)
                        try? viewContext.save()
                    }
                }
            }.padding()
            
            HStack {
                TextField("Add new quote", text: $newQuote)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(4)
                Button {
                    guard !newQuote.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    quoteList.append(newQuote)
                    newQuote = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.gray)
                }
            }.padding(.horizontal, 15)
            Text("Quotes")
                .font(.headline)
                .padding(.horizontal, 15)
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(zip(quoteList.indices, quoteList)), id: \.0) { index, quote in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.secondary.opacity(0.1))
                            
                            Text(quote)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                        
                        .contextMenu {
                            Button("Редактировать") {
                                startEditingQuote(at: index)
                            }
                            
                            Button("Удалить", role: .destructive) {
                                quoteList.remove(at: index)
                            }
                        }
                    }
                }
            }.padding(.horizontal, 15)
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Edit quote")
                        .font(.headline)
                    
                    TextEditor(text: $editedQuoteText)
                        .padding()
                        .frame(minHeight: 200)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Button("Save") {
                        if let i = editingQuoteIndex {
                            quoteList[i] = editedQuoteText
                        }
                        showEditSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Cancel") {
                        showEditSheet = false
                    }
                    .padding(.top, 4)
                }
                .padding()
                .navigationBarHidden(true)
            }
        }        .navigationTitle("Edit \(book.title ?? "Untitled")")
            .onAppear {
                self.editedTitle = book.title ?? ""
                self.editedAuthor = book.author ?? ""
                self.quoteList = book.quoteList
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
    }
    private func startEditingQuote(at index: Int) {
        editingQuoteIndex = index
        editedQuoteText = quoteList[index]
        showEditSheet = true
    }
    
    private func saveChanges() {
        book.title = editedTitle
        book.author = editedAuthor
        book.quoteList = quoteList
        
        if let selectedImage = selectedImage {
            book.cover = selectedImage.jpegData(compressionQuality: 0.8)
        }
        
        try? viewContext.save()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let book = BookStorageModel(context: context)
    book.title = "SwiftUI Tips"
    book.author = "Анатолий Юрьевич"
    book.quoteList = [
        "Код пишется для людей, не для машин.",
        "Каждый View — это результат состояния. Каждый View — это результат состояния.",
        "Меньше — лучше."
    ]
    
    return NavigationView {
        BookDetailView(book: book)
            .environment(\.managedObjectContext, context)
    }
}

extension BookStorageModel {
    var quoteList: [String] {
        get {
            guard let data = self.quoteListData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            self.quoteListData = try? JSONEncoder().encode(newValue)
        }
    }
}


