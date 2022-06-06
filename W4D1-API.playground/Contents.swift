import UIKit
import Foundation


struct Person:Decodable {
    var name: String
    var films: [URL]
}

struct Film:Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        //Prepare URL
        
        guard let baseURL = baseURL else{return completion(nil)}
        let component = "people/"+"\(id)"
        let finalURL = baseURL.appendingPathComponent(component)
        print(finalURL)
        
        //Contact Server
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            //Error Handling
            if let error = error {
                print(error,error.localizedDescription)
                return completion(nil)
            }
            
            
            //Check for Data
            guard let data = data else {
                return completion(nil)
            }
            
            //Decode Person From JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
                
            } catch {
                print(error,error.localizedDescription)
                return completion(nil)
            }
            
            
        }.resume()
        
    }
    
    static func fetchMovies(url: URL, completion: @escaping (Film?) -> Void) {
        print(url)
        
        // 1 - Contact server
        URLSession.shared.dataTask(with: url) { data, _, error in
            // 2 - Handle errors
            if let error = error {
                print(error,error.localizedDescription)
                return completion(nil)
            }
            
            // 3 - Check for data
            guard let data = data else {
                return completion(nil)
            }

            // 4 - Decode Film from JSON
            
            do {
            let decoder = JSONDecoder()
            let film = try decoder.decode(Film.self, from: data)
            return completion(film)
            } catch {
                print(error,error.localizedDescription)
                return completion(nil)
            }
            
            
        }.resume()

    }
    
}


func fetchFilm(url: URL) {
  SwapiService.fetchMovies(url: url) { film in
      if let film = film {
          print(film.title)
      }
  }
}

SwapiService.fetchPerson(id: 10) { person in
  if let person = person {

      let films = person.films
      for film in films {
          fetchFilm(url: film)
      }
      
      }
  }


