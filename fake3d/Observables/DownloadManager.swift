//
//  DownloadManager.swift
//  fake3d
//
//  Created by Antoine GERAUD on 20/11/2019.
//  Copyright © 2019 Antoine GERAUD. All rights reserved.
//

import SwiftUI

class DownloadManager:ObservableObject
{
    let NUMBER_OF_IMAGES = 72
    
    @Published var isLoading:Bool = true
    @Published var imagesFetched:Int = 0
    @Published var displayedText:String = "Loading assets (0/72)"
    var currentlyDownloading = 0;
    
    func getAllImages() {
        let urls = getURLList()
        
        refreshUI(imagesFetched: self.NUMBER_OF_IMAGES - urls.count)
        
        for url in urls {
            currentlyDownloading += 1
            getData(from: url) { data, response, error in
                self.currentlyDownloading -= 1
                if let data = data, error == nil {
                    
                    if self.saveImage(image: UIImage(data: data)!, fileName: response?.suggestedFilename ?? url.lastPathComponent) {
                        self.refreshUI(imagesFetched: self.imagesFetched + 1)
                    }
                }
                
                if (self.currentlyDownloading <= 0) {
                    self.getAllImages()
                }
            }
        }
    }
    
    func refreshUI(imagesFetched: Int) {
        DispatchQueue.main.async() {
             self.imagesFetched = imagesFetched
             self.displayedText = "Loading assets (\(self.imagesFetched)/\(self.NUMBER_OF_IMAGES))"
             if (self.imagesFetched >= self.NUMBER_OF_IMAGES) {
                 self.isLoading = false
             }
         }
    }
    
    func getURLList() -> [URL] {
        var urls = [URL]()
        for i in 1...NUMBER_OF_IMAGES {
            
            if getSavedImage(named: "\(i < 10 ? "0\(i)" : "\(i)").png") == nil {
                urls.append(URL(string:  "https://fge-dst-rotor-space.s3.ap-southeast-1.amazonaws.com/PHL/2015_Ranger_PH/1_Explore_Packages/1_Neutral/2015_Ranger_Base_2.2L_MT_4x2/Exterior/PH_Colours_010/\(i < 10 ? "0\(i)" : "\(i)").png")!)
            }
        }
        return urls
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func saveImage(image: UIImage, fileName: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(fileName)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    init() {
        getAllImages()
    }
}
