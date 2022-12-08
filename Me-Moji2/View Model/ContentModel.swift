//
//  ContentModel.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/4/22.
//

import Foundation
import Firebase
import SwiftUI

class ContentModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var item = [CustomizeItem]()
    
    init(){
        getRemoteData()
    }
    
    //Retrieve remote data from Github
    func getRemoteData() {
            
            //Need to get string for json
            let urlString = "https://eplfury91.github.io/learningApp-Data/data.json"
        
        
        
            let url = URL(string: urlString)
        
        guard url != nil else {
            
            //couldnt find site
            return
        }
        
        //create url request
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            //check if there is an error
            
            guard error == nil else {
                return
            }
            
            do {
                //create json decoder
                let decoder = JSONDecoder()
                
                let item = try decoder.decode([CustomizeItem].self, from: data!)
                
                DispatchQueue.main.async {
                    self.item += item
                }
                
            }
            catch {
                error
            }
            
            
        }
        //kick off data task
        dataTask.resume()
    }
    
}

