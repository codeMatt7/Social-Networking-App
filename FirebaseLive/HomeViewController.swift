//
//  ViewController.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import UIKit
import HMSegmentedControl
import Firebase

class HomeViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
     var segmentedControl: HMSegmentedControl!
    
    var usersArray = [User]()
    
    var postsArray = [Post]()
    
    var networkService = NetworkingService()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.fetchAllUsers()
        self.fetchAllPosts()
        self.setSegmentedControl()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 555
        }
    }
    
    private func fetchAllUsers() {
        networkService.fetchAllUsers { (users) in
            self.usersArray = users
            self.tableView.reloadData()
        }
    }
    
    private func fetchAllPosts() {
        networkService.fetchPosts { (posts) in
            self.postsArray = posts
            self.tableView.reloadData()
        }
    }
    
    func setSegmentedControl() {
        segmentedControl = HMSegmentedControl(frame: CGRect(x: 0, y: 99, width: self.view.frame.size.width, height: 69))
        segmentedControl.sectionTitles = ["FEEDS", "USERS"]
        segmentedControl.backgroundColor = UIColor(colorWithHexValue: 0x305894)
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:1, green: 1, blue: 1, alpha: 0.5), NSFontAttributeName: UIFont(name:"AppleSDGothicNeo-Medium", size: 18)!]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentedControl.selectionIndicatorColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectionIndicatorLocation = .up
        segmentedControl.addTarget(self, action: #selector(HomeViewController.segmentedControlAction), for: UIControlEvents.valueChanged)
        self.view.addSubview(segmentedControl)
    }
    
    func segmentedControlAction() {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.fetchAllPosts()
            self.tableView.reloadData()
        } else {
            self.fetchAllUsers()
            self.tableView.reloadData()
        }
    }

    @IBAction func logOutAction(_ sender: Any) {
        networkService.logOut {
            let loginVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
            loginVC.modalTransitionStyle = .crossDissolve
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    //reverse segue //this is connected to the x button in the user profile controller
    @IBAction func unwindToHome(storyboardSegue: UIStoryboardSegue) {
        
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    struct CellIdentifiers {
        var userCell = "userCell"
        var postImageCell = "imageCell"
        var postTextCell = "textCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if segmentedControl.selectedSegmentIndex == 0 {
            
            if postsArray[indexPath.row].type == "Image" {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().postImageCell, for: indexPath) as! PostImageTableViewCell
                
                cell.configureCell(post: postsArray[indexPath.row], users: self.usersArray)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().postTextCell, for: indexPath) as! PostTextTableViewCell
                
                cell.configureCell(post: postsArray[indexPath.row], users: self.usersArray)
                
                return cell
            }
          
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().userCell, for: indexPath) as! UserTableViewCell
            
            cell.configureCellForUser(user: usersArray[indexPath.row])
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            rows = postsArray.count
        case 1:
            rows = usersArray.count
        default: break
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            height = 555
        case 1:
            height = 102
        default: break
        }

        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGuest", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true) //no gray selected state
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGuest" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let guestVC = segue.destination as! GuestUserViewController
                guestVC.ref = usersArray[indexPath.row].ref
            }
        }
    }
}











