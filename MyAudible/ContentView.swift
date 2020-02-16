//
//  ContentView.swift
//  MyAudible
//
//  Created by Keanu Interone on 2/12/20.
//  Copyright © 2020 Keanu Interone. All rights reserved.
//

import SwiftUI
import Firebase


struct Course: Identifiable, Decodable {
    let id = UUID()
    let name, imageUrl: String
}


class CoursesViewModel: ObservableObject {
    
    @Published var courses = [Course]()
    
    func fetchCourses() {
                
        guard let url = URL(string: "https://api.letsbuildthatapp.com/jsondecodable/courses") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Check for error
            if let error = error {
                print(error.localizedDescription)
            }
            
            // Check response
            if let response = response as? HTTPURLResponse {
                // handle any response checking here
                if (response.statusCode == 200) {
                    print("Thats a good response")
                }
            }
            
            // Pull out data
            if let data = data {
                if let courses = try? JSONDecoder().decode([Course].self, from: data) {
                    DispatchQueue.main.async {
                        self.courses = courses
                    }
                } else {
                    print("There was an error parsing the json")
                }
            } else {
                print("data was nil")
            }
            
        }.resume()
    }
    
}

struct Book: Identifiable, Decodable {
    let id, name, author: String
}

class BooksViewModel: ObservableObject {
    @Published var books = [Book]()
    
    func getBooks() {
        let db = Firestore.firestore()
        

        db.collection("books").getDocuments { (snapShot, error) in
            if let error = error {
                // handle error
                print(error.localizedDescription)
                return
            }
            
            if let snapShot = snapShot {
                var books = [Book]()
                for bookSnapShot in snapShot.documents {
                    if let book = try? JSONDecoder().decode(Book.self, fromJSONObject: bookSnapShot.prepareForDecoding()) {
                        books.append(book)
                    }
                }
                
                DispatchQueue.main.async {
                    self.books = books
                }
            }
        }
    }
}

extension QueryDocumentSnapshot {

    func prepareForDecoding() -> [String: Any] {
        var data = self.data()
        data["id"] = self.documentID

        return data
    }

}

extension JSONDecoder {
    func decode<T>(_ type: T.Type, fromJSONObject object: Any) throws -> T where T: Decodable {
        return try decode(T.self, from: try JSONSerialization.data(withJSONObject: object, options: []))
    }
}

struct ContentView: View {
    
    @ObservedObject var coursesVM = CoursesViewModel()
    @ObservedObject var booksVM = BooksViewModel()
    
    
    var body: some View {
        NavigationView {
            List(booksVM.books) { book in
                NavigationLink(destination: CourseView(course: Course(name: "", imageUrl: ""))) {
                    Text(book.name)
                }
                
            }
            .navigationBarTitle(Text("Books"))
            .navigationBarItems(
                trailing: Button(action: {
                    print("Clicked me")
                    self.booksVM.getBooks()
                }, label: {
                    Text("Click Me")
                })
            )
        }
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

