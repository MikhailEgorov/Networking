//
//  MainViewController.swift
//  Networking
//
//  Created by Егоров Михаил on 18.08.2022.
//

import UIKit

// set count and names CollectionViewCells
enum UserAction: String, CaseIterable {
    case downloadImage = "Download Image"
    case exampleOne = "Example One"
    case exampleTwo = "Example Two"
    case exampleThree = "Example Three"
    case exampleFour = "Example Four"
    case ourCourses = "Our Courses"
    case capitalToLowcase = "Capital To Lowcase"
    case postRqstWithDict = "POST RQST With Dict"
    case postRqstWithModel = "POST RQST With Model"
    case alamofireGet = "Alamofire GET"
    case alamofirePost = "Alamofire POST"
}

class MainViewController: UICollectionViewController {
    
    // array CollectionViewCells for func numberOfItemsInSection
    let userActions = UserAction.allCases
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }
    
    /*
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }*/

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        
        //show names cells
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    // open view by segue ID
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
    // set actions for press CollectionViewCells
        switch userAction {
        case .downloadImage: performSegue(withIdentifier: "showImage", sender: nil)
        case .exampleOne: exampleOneButtonPressed()
        case .exampleTwo: exampleTwoButtonPressed()
        case .exampleThree: exampleThreeButtonPressed()
        case .exampleFour: exampleFourButtonPressed()
        case .ourCourses: performSegue(withIdentifier: "showCourses", sender: nil)
        case .capitalToLowcase: performSegue(withIdentifier: "showCapital", sender: nil)
        case .postRqstWithDict: examplePostRqstWithDict()
        case .postRqstWithModel: examplePostRqstWithModel()
        case .alamofireGet: performSegue(withIdentifier: "showAlamofireGet", sender: nil)
        case .alamofirePost: performSegue(withIdentifier: "showAlamofirePost", sender: nil)
        }
        
    }
    // MARK: - Navigation
    // func choose Button method for show tableview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Created a condition for the transition segue showCourses
        if segue.identifier == "showCourses" {
            guard let coursesVC = segue.destination as? CoursesViewController else { return }
            coursesVC.fetchCourses()
        } else if segue.identifier == "showCapital" {
            guard let coursesVC = segue.destination as? CoursesViewController else { return }
            coursesVC.fetchCoursesV2()
        } else if segue.identifier == "showAlamofireGet" {
            guard let coursesVC = segue.destination as? CoursesViewController else { return }
            coursesVC.alamofireGetButtonPressed()
        } else if segue.identifier == "showAlamofirePost" {
            guard let coursesVC = segue.destination as? CoursesViewController else { return }
            coursesVC.alamofirePostButtonPressed()
        }
    }
    
    // MARK: - Private Methods
    // alert window
    private func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Success",
                message: "You can see the results in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "You can see error in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

//I set the automatic CollectionViewCell size depending on the screen
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: - Networking
// Buttons actions for CollectionViewCells (switch userAction)
extension MainViewController {
private func exampleOneButtonPressed() {
    NetworkManager.shared.fetch(dataType: Course.self, from: Link.exampleOne.rawValue) { result in
        switch result {
        case .success(let course):
            self.successAlert()
            print(course)
        case .failure(let error):
            print(error)
            self.failedAlert()
        }
    }
}
private func exampleTwoButtonPressed() {
    NetworkManager.shared.fetch(dataType: [Course].self, from: Link.exampleTwo.rawValue) { result in
        switch result {
        case .success(let courses):
            self.successAlert()
            print(courses)
        case .failure(let error):
            print(error)
            self.failedAlert()
        }
    }
}
private func exampleThreeButtonPressed() {
    NetworkManager.shared.fetch(dataType: WebsiteDescription.self, from: Link.exampleThree.rawValue) { result in
        switch result {
        case .success(let websiteDescription):
            self.successAlert()
            print(websiteDescription)
        case .failure(let error):
            print(error)
            self.failedAlert()
        }
    }
}
private func exampleFourButtonPressed() {
    NetworkManager.shared.fetch(dataType: WebsiteDescription.self, from: Link.exampleFour.rawValue) { result in
        switch result {
        case .success(let websiteDescription):
            self.successAlert()
            print(websiteDescription)
        case .failure(let error):
            print(error)
            self.failedAlert()
        }
    }
}
    private func examplePostRqstWithDict() {
        let course = [
            "name": "Networking",
            "imageUrl": "image url",
            "numberOfLessons": "10",
            "numberOfTests": "8"
        ]
        NetworkManager.shared.postRequest(with: course, to: Link.postRequest.rawValue) { result in
            switch result {
            case .success(let course):
                self.successAlert()
                print(course)
            case .failure(let error):
                self.failedAlert()
                print(error)
            }
        }
    }
    
   private func examplePostRqstWithModel() {
       let course = CourseV3(name: "Networking",
                             imageUrl: Link.courseImageURL.rawValue,
                             numberOfLessons: "10",
                             numberOfTests: "5")
       NetworkManager.shared.postRequest(with: course, to: Link.postRequest.rawValue) { result in
           switch result {
               case .success(let course):
                   self.successAlert()
                   print(course)
               case .failure(let error):
                   self.failedAlert()
                   print(error)
           }
       }
    }

    /*private func exampleAlamoFireGet() {
        
    }
    
    private func exampleAlamoFirePost() {
        
    }*/

}
