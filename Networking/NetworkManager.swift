//
//  NetworkManager.swift
//  Networking
//
//  Created by Егоров Михаил on 28.09.2022.
//

import Foundation
import Alamofire

// links for CollectionViewCells
enum Link: String {
    case imageURL = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    case exampleOne = "https://swiftbook.ru/wp-content/uploads/api/api_course"
    case exampleTwo = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
    case exampleThree = "https://swiftbook.ru/wp-content/uploads/api/api_website_description"
    case exampleFour = "https://swiftbook.ru/wp-content/uploads/api/api_missing_or_wrong_fields"
    case exampleFive = "https://swiftbook.ru/wp-content/uploads/api/api_courses_capital"
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
    case courseImageURL = "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: String?, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    func fetch<T: Decodable>(dataType: T.Type, from url: String, convertFromSnakeCase: Bool = true, complition: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            complition(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                complition(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
            return
            }
            do {
                let decoder = JSONDecoder()
                if convertFromSnakeCase {
                    decoder.keyDecodingStrategy = .convertFromSnakeCase                    
                }
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(type))
                }
            } catch {
                complition(.failure(.decodingError))
            }
        }.resume()
    }
    
    // Post Request with dictionary
    func postRequest(with data: [String: Any], to url: String, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        // wrap dictionary to data
        guard let courseData = try? JSONSerialization.data(withJSONObject: data) else {
            completion(.failure(.noData))
            return
        }
        // wrap data to request
        var request = URLRequest(url: url)
        // set type of request method
        request.httpMethod = "POST"
        // set rules forming post header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = courseData
        // request Created.
        
        // create session
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                print (error?.localizedDescription ?? "No error description")
                return
            }
            //print answer from server
            print(response)
            
            // decoding answer from server
            do {
                let course = try JSONSerialization.jsonObject(with: data)
                completion(.success(course))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    // Post Request with model
    func postRequest(with data: CourseV3, to url: String, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        // wrap (encode) model to data
        guard let courseData = try? JSONEncoder().encode(data) else {
            completion(.failure(.noData))
            return
        }
        // wrap data to request
        var request = URLRequest(url: url)
        // set type of request method
        request.httpMethod = "POST"
        // set rules forming post header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = courseData
        // request Created.
        
        // create session
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                print (error?.localizedDescription ?? "No error description")
                return
            }
            //print answer from server
            print(response)
            
            // decoding answer from server
            // create model from data
            do {
                let course = try JSONDecoder().decode(CourseV3.self, from: data)
                completion(.success(course))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchDataWithAlamofire(_ url: String, complition: @escaping(Result<[Course], NetworkError>) -> Void) {
        AF.request(Link.exampleTwo.rawValue)
        // mandatory check status code 200-299 and header
            .validate()
        //Checked.
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let courses = Course.getCourses(from: value)
                    DispatchQueue.main.async {
                        complition(.success(courses))
                    }
                case .failure:
                    complition(.failure(.decodingError))
                }
            }
    }
    
    func postDataWithAlamofire(_ url: String, data: CourseV3, complition: @escaping(Result<Course, NetworkError>) -> Void) {
        AF.request(url, method: .post, parameters: data)
            .validate()
            .responseDecodable(of: CourseV3.self) { dataResponse in
                switch dataResponse.result {
                case .success(let coursesV3):
                    let course = Course(name: coursesV3.name,
                                        imageUrl: coursesV3.imageUrl,
                                        numberOfLessons: Int(coursesV3.numberOfLessons) ?? 0,
                                        numberOfTests: Int(coursesV3.numberOfTests) ?? 0)
                    DispatchQueue.main.async {
                        complition(.success(course))                        
                    }
                case .failure:
                    complition(.failure(.decodingError))
                }
            }
    }
}
