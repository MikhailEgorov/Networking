//
//  CoursesViewController.swift
//  Networking
//
//  Created by Егоров Михаил on 26.08.2022.
//

import UIKit
import Alamofire

class CoursesViewController: UITableViewController {
    
    // array for show table view courses
    private var courses: [Course] = []
    private var coursesV2: [CourseV2] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }*/
    // count of table cells  fetch from JSON
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.isEmpty ? coursesV2.count : courses.count
    }

    // fill table cells with data from JSON
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseCell
        
        if courses.isEmpty {
            let courseV2 = coursesV2[indexPath.row]
            cell.configure(with: courseV2)
        } else {
            //create an instance of the course model
            let course = courses[indexPath.row]
            //passing an instance of the course model to func cell.configure
            cell.configure(with: course)
        }
        return cell
    }

}

// MARK: - Networking
// Show JSON in CoursesTableView
extension CoursesViewController {
    // example with show json ourCourses link
    func fetchCourses() {
        NetworkManager.shared.fetch(dataType: [Course].self, from: Link.exampleTwo.rawValue) { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    // example with ahow json capital link
    func fetchCoursesV2() {
        NetworkManager.shared.fetch(dataType: [CourseV2].self,
                                    from: Link.exampleFive.rawValue,
                                    convertFromSnakeCase: false) { result in
            switch result {
            case .success(let courses):
                self.coursesV2 = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alamofireGetButtonPressed() {
        NetworkManager.shared.fetchDataWithAlamofire(Link.exampleTwo.rawValue) { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alamofirePostButtonPressed() {
        let course = CourseV3(name: "Networking",
                              imageUrl: Link.courseImageURL.rawValue,
                              numberOfLessons: "10",
                              numberOfTests: "5")
        NetworkManager.shared.postDataWithAlamofire(Link.postRequest.rawValue, data: course) { result in
            switch result {
            case .success(let courses):
                self.courses.append(courses)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
