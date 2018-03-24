//
//  TableViewDelegateDatasourse.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 28.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.

/// Displays the result (bad or good quality)

import UIKit

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let count: Int = dataArray[indexPath.row].count
        
        return count > 28 ? 50 : 20
    }
}
