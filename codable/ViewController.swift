//
//  ViewController.swift
//  dummy
//
//  Created by Adminstrator on 13/11/18.
//  Copyright © 2018 adminstrator. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var TableView: UITableView!
    
    let cellReuseIdentifier = "MyCustomCell"
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
        TableView.delegate = self
        TableView.dataSource = self
        
        TableView.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func parseData(){
        
        let jsonUrlString = "https://www.apakataorang.com/wp-json/wp/v2/posts?per_page=5"
        guard let url = URL(string: jsonUrlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let coursess = try? JSONDecoder().decode([Course].self, from: data){
                    self.courses = coursess
                    DispatchQueue.main.async {
                        self.TableView.reloadData()
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomCell
        // create a new cell if needed or reuse an old one
        let course = courses[indexPath.row]
        print(course.title.rendered as Any)
        cell.lbltext?.text = "Does not work"
        
        if course.title.rendered != nil {
            print("Contains a value!")
            cell.lbltext?.text = course.title.rendered
        } else {
            print("Doesn’t contain a value.")
            cell.lbltext?.text = "Does not work"
        }
        
        
        
        //cell.textLabel!.text = course.title!.rendered
        
        
        if let imageURL = URL(string: course.jetpackFeaturedMediaURL){
            DispatchQueue.global().async{
                let data = try? Data(contentsOf: imageURL)
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgView?.image = image
                    }
                }
            }
        }
        
        return cell
    }
}

