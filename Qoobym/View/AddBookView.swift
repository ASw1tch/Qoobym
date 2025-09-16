//
//  AddBookView.swift
//  Qoobym
//
//  Created by Anatoliy Petrov on 11. 5. 2025..
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title = ""
    @State private var author = ""
    @State private var coverImage: UIImage?
    @State private var showImagePicker = false
    
    @State private var quoteList: [String] = []
    @State private var newQuote: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Информация о книге")) {
                    TextField("Название", text: $title)
                    TextField("Автор", text: $author)
                }
                
                Section(header: Text("Обложка")) {
                    if let coverImage = coverImage {
                        Image(uiImage: coverImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                    }
                    
                    Button("Выбрать изображение") {
                        showImagePicker = true
                    }
                }
                
                Section(header: Text("Цитаты")) {
                    ForEach(Array(zip(quoteList.indices, quoteList)), id: \.0) { index, _ in
                        HStack {
                            TextField("Цитата", text: Binding(
                                get: { quoteList[index] },
                                set: { quoteList[index] = $0 }
                            ))
                            Button(role: .destructive) {
                                quoteList.remove(at: index)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    
                    HStack {
                        TextField("Новая цитата", text: $newQuote)
                        Button {
                            guard !newQuote.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            quoteList.append(newQuote)
                            newQuote = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                
                Section {
                    Button("💾 Сохранить") {
                        saveBook()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Новая книга")
            .navigationBarItems(leading: Button("Отмена") {
                dismiss()
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $coverImage)
            }
        }
    }
    
    private func saveBook() {
        let newBook = BookStorageModel(context: viewContext)
        newBook.title = title
        newBook.author = author
        newBook.quoteList = quoteList
        newBook.cover = coverImage?.jpegData(compressionQuality: 0.8)
        
        try? viewContext.save()
    }
}
#Preview {
    AddBookView()
}
