//
//  Networking.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 17.02.2021.
//

import Foundation
import Alamofire
class NetworkingManager🌐 {
    
    var apiToken = "3218002cba480879a142fda0c47cfbaa"
    let requestGroup = DispatchGroup()
    
    typealias NewsCallBack = ( news:[FeedModel]?, status: Bool, message: String)
    typealias ScheduleDataCallBack = (scheduleData:ScheduleData?, status: Bool, message:String)
    typealias AuthCallBack = (authStatus: Bool,message:String?)
    
    
    var newsCallBack: NewsCallBack?
    var scheduleDataCallBack: ScheduleDataCallBack?
    public var authStatus: AuthCallBack?
    
    public func auth(login:String,password:String){
        requestGroup.enter()
        AF.request("https://ies.unitech-mo.ru/api?token=\(apiToken)&query=AUTH&login=\(login)&password=\(password)").authenticate(username: login, password: password).response{ response in
            
            guard let data = response.data else {
                self.requestGroup.leave()
                return
            }
            do{
                let parsedJsonData = try JSONDecoder().decode(AuthData.self, from: data)
                let success = parsedJsonData.success
                self.authStatus = (success, nil)
            } catch{
                self.authStatus = (false,error.localizedDescription)
                print(error.localizedDescription)
            }
            self.requestGroup.leave()

        }
   
    }
    public func getSubjectsInfo(firstDate:Date,secondDate:Date){
        requestGroup.enter()
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withDay,.withMonth,.withYear]
        let fstDate = dateFormatter.string(from: firstDate)
        let scndDate = dateFormatter.string(from: secondDate)
        
        AF.request("https://ies.unitech-mo.ru/api?token=\(apiToken)&query=SCHEDULE&d=\(fstDate)-\(scndDate)").responseJSON { (responce) in
            guard let data = responce.data else{
                self.scheduleDataCallBack = ScheduleDataCallBack(nil,false,"Error: Unable to reach the data!")
                self.requestGroup.leave()
                return
            }
            do{
                let jsonDecoder = JSONDecoder()
                let scheduleData = try jsonDecoder.decode(ScheduleData.self, from: data)
                self.scheduleDataCallBack = ScheduleDataCallBack(scheduleData,true,"No error")
                
            } catch{
                self.scheduleDataCallBack = ScheduleDataCallBack(nil,false,error.localizedDescription)
            }
            self.requestGroup.leave()
        }
    }
    public func getNews(offset: Int, limit: Int){
        
        AF.request("https://ies.unitech-mo.ru/api?token=3218002cba480879a142fda0c47cfbaa&query=NEWS&offset=\(offset)&limit=\(limit)",method: .get).responseJSON { (response) in
            guard let data = response.data else{
                self.newsCallBack = NewsCallBack(nil,false,"Error: Unable to reach the data!")
                return
            }
            do {
                let news = try JSONDecoder().decode([FeedModel].self, from: data)
                self.newsCallBack = NewsCallBack(news,true,"")
            } catch {
                print(error.localizedDescription)
                self.newsCallBack = NewsCallBack(nil,false,error.localizedDescription)
            }
        }
        
        
        
    }
}
