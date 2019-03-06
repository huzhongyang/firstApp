//
//  NetWorkTools.swift
//  News
//
//  Created by huzhongyang on 2018/11/20.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

protocol NetWorkToolProtocol {
    // MARK: - ------------------------------- 首页 home -------------------------------
    // MARK: - 首页顶部新闻标题的数据
    static func loadHomeNewsTitleData(completionHandler: @escaping (_ newsTitles: [HomeNewsTitle]) -> ())
    // MARK: - 首页顶部导航栏搜索内容数据
    static func loadHomeSearchSuggestInfo(completionHandler: @escaping (_ suggestInfo: String) -> ())
    
    // MARK: - ------------------------------- 我的 mine -------------------------------
    // MARK: - 我的界面 cell 的数据
    static func loadMyCellData(completionHandler: @escaping (_ setions: [[MyCellModel]]) -> ())
    // MARK: - 我的关注数据
    static func loadMyConcern(completionHandler: @escaping (_ concerns: [MyConcern]) -> ())
    // MARK: - 用户详情数据
    static func loadUserDetail(user_id: Int, completionHandler: @escaping (_ userDetail: UserDetail) -> ())
    // MARK: - (已关注用户) 取消关注
    static func loadRelationUnfollow(user_id: Int, completionHandler: @escaping (_ user: ConcernUser) -> ())
    // MARK: - 点击关注按钮，关注用户
    static func loadRelationFollow(user_id: Int, completionHandler: @escaping (_ user: ConcernUser) -> ())
    // MARK: - 点击了关注按钮, 就会出现相关推荐数据
    static func loadRelationUserRecommend(user_id: Int, completionHandler: @escaping (_ concerns: [UserCard]) -> ())
    // MARK: - 获取用户详情的动态列表数据
    static func loadUserDetailDongtaiList(user_id: Int, maxCursor: Int, completionHandler: @escaping (_ cursor: Int, _ dongtais: [UserDetailDongtai]) -> ())
    // MARK: - 获取用户详情的文章列表数据  (未使用)
    static func loadUserDetailArticleList(user_id: Int, completionHandler: @escaping (_ articles: [UserDetailDongtai]) -> ())
    // MARK: - 获取用户详情的问答列表数据
    static func loadUserDetailWendaList(user_id: Int, cursor: String, completionHandler: @escaping (_ cursor: String, _ wendas: [UserDetailWenda]) -> ())
}

extension NetWorkToolProtocol {
    
    // ------------------------------- 首页 home -------------------------------
    /// 首页顶部新闻标题的数据
    static func loadHomeNewsTitleData(completionHandler: @escaping (_ newsTitles: [HomeNewsTitle]) -> ()) {
        let url = BASE_URL + "/article/category/get_subscribed/v1/?"
        let params = ["device_id": device_id,
                      "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                // 网络错误 提示信息
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                if let dataDict = json["data"].dictionary {
                    if let data = dataDict["data"]?.arrayObject {
                        var titles = [HomeNewsTitle]()
                        let jsonString = "{\"category\": \"\", \"name\": \"推荐\"}"
                        let recommend = HomeNewsTitle.deserialize(from: jsonString)
                        titles.append(recommend!)
                        for item in data {
                            let newsTitle = HomeNewsTitle.deserialize(from: item as? Dictionary)
                            titles.append(newsTitle!)
                        }
                        completionHandler(titles)
                    }
                }
            }
        }
    }
    
    /// 首页顶部导航栏搜索内容数据
    static func loadHomeSearchSuggestInfo(completionHandler: @escaping (_ suggestInfo: String) -> ()) {
        let url = BASE_URL + "/search/suggest/homepage_suggest/?"
        let params = ["device_id": device_id,
                      "iid": iid]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                if let data = json["data"].dictionary {
                    completionHandler(data["homepage_search_suggest"]!.string!)
                }
            }
        }
    }
    
    // ------------------------------- 我的 mine -------------------------------
    /// 我的界面 cell 的数据
    static func loadMyCellData(completionHandler: @escaping (_ setions: [[MyCellModel]]) -> ()) {
        let url = BASE_URL + "/user/tab/tabs/?"
        let params = ["device_id": device_id]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                // 网络错误的提示信息
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                if let data = json["data"].dictionary {
                    if let sections = data["sections"]?.array {
                        var sectionArray = [[MyCellModel]]()
                        for item in sections {
                            var rows = [MyCellModel]()
                            for row in item.arrayObject! {
                                let myCellModel = MyCellModel.deserialize(from: row as? Dictionary)
                                rows.append(myCellModel!)
                            }
                            sectionArray.append(rows)
                        }
                        completionHandler(sectionArray)
                    }
                }
            }
        }
    }
    
    /// 我的关注数据
    static func loadMyConcern(completionHandler: @escaping (_ concerns: [MyConcern]) -> ()) {
        let url = BASE_URL + "/concern/v2/follow/my_follow/?"
        let params = ["device_id": device_id]
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                // 网络错误的提示信息
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                if let data = json["data"].arrayObject {
                    var concerns = [MyConcern]()
                    for data in data {
                        let myConcern = MyConcern.deserialize(from: data as? Dictionary)
                        concerns.append(myConcern!)
                    }
                    completionHandler(concerns)
                }
            }
        }
    }
    
    /// 用户详情数据
    static func loadUserDetail(user_id: Int, completionHandler: @escaping (_ userDetail: UserDetail) -> ()) {
        let url = BASE_URL + "/user/profile/homepage/v4/?"
        let params = ["user_id": user_id,
                      "device_id": device_id,
                      "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                // 网络错误信息
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                if let data = json["data"].dictionaryObject {
                    let userDetail = UserDetail.deserialize(from: data as Dictionary)
                    completionHandler(userDetail!)
                }
            }
        }
    } 
    
    /// (已关注用户) 取消关注
    static func loadRelationUnfollow(user_id: Int, completionHandler: @escaping (_ user: ConcernUser) -> ()) {
        let url = BASE_URL + "/2/relation/unfollow/?"
        let params = ["user_id": user_id,
                      "device_id": device_id,
                      "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else {
                // 网络错误信息
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else {
                    // 不能无限次取消关注用户，每天上限是 30 次
                    if let data = json["data"].dictionaryObject {
                        SVProgressHUD.showInfo(withStatus: data["description"] as? String)
                        SVProgressHUD.setForegroundColor(UIColor.white)
                        SVProgressHUD.setBackgroundColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.3))
                    }
                    return
                }
                if let data = json["data"].dictionaryObject {
                    let user = ConcernUser.deserialize(from: data["user"] as? Dictionary)
                    completionHandler(user!)
                }
            }
        }
    }
    
    /// 点击关注按钮，关注用户
    static func loadRelationFollow(user_id: Int, completionHandler: @escaping (_ user: ConcernUser) -> ()) {
        let url = BASE_URL + "/2/relation/follow/v2/?"
        let params = ["user_id": user_id,
                      "device_id": device_id,
                      "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard  response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                if let data = json["data"].dictionaryObject {
                    let user = ConcernUser.deserialize(from: data["user"] as? Dictionary)
                    completionHandler(user!)
                }
            }
        }
    }
    
    /// 点击了关注按钮, 就会出现相关推荐数据
    static func loadRelationUserRecommend(user_id: Int, completionHandler: @escaping (_ concerns: [UserCard]) -> ()) {
        let url = BASE_URL + "/user/relation/user_recommend/v1/supplement_recommends/?"
        let params = ["device_id": device_id,
                      "follow_user_id": user_id,
                      "iid": iid,
                      "scene": "follow",
                      "source": "follow"] as [String: Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["err_no"] == 0 else { return }
                if let user_cards = json["user_cards"].arrayObject {
                    completionHandler(user_cards.compactMap({
                        UserCard.deserialize(from: $0 as? Dictionary)
                    }))
                }
            }
        }
    }
    
    /// 获取用户详情的动态列表数据
    /// - parameter user_id: 用户id
    /// - parameter maxCursor: 刷新时间
    /// - parameter completionHandler: 返回动态数据
    /// - parameter dongtais:  动态数据的数组
    static func loadUserDetailDongtaiList(user_id: Int, maxCursor: Int, completionHandler: @escaping (_ cursor: Int, _ dongtais: [UserDetailDongtai]) -> ()) {
        let url = BASE_URL + "/dongtai/list/v15/?"
        let params = ["user_id": user_id,
                      "max_cursor": maxCursor,
                      "device_id": device_id,
                      "iid": iid]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else { completionHandler(maxCursor, []); return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { completionHandler(maxCursor, []); return }
                if let data = json["data"].dictionary {
                    let max_cursor = data["max_cursor"]!.int
                    if let datas = data["data"]?.arrayObject {
                        completionHandler(max_cursor!, datas.compactMap({
                            UserDetailDongtai.deserialize(from: $0 as? Dictionary)
                        }))
                    }
                }
            }
        }
    }
    
    /// 获取用户详情的文章列表数据
    static func loadUserDetailArticleList(user_id: Int, completionHandler: @escaping (_ articles: [UserDetailDongtai]) -> ()) {
        let url = BASE_URL + "/pgc/ma/?"
        let params = ["uid": user_id,
                      "page_type": 1,
                      "media_id": user_id,
                      "output": "json",
                      "is_json": 1,
                      "from": "user_profile_app",
                      "version": 2,
                      "as": "A1157AB297BEED7",
                      "cp": "59549FCDF1885E1"] as [String: Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else { return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["message"] == "success" else { return }
                if let data = json["data"].arrayObject {
                    completionHandler(data.compactMap({
                        UserDetailDongtai.deserialize(from: $0 as? Dictionary)
                    }))
                }
            }
        }
    }
    
    /// 获取用户详情的问答列表数据
    ///
    /// - Parameters:
    ///   - user_id: 用户 id
    ///   - cursor: 刷新时间
    ///   - completionHandler: 返回问答数剧数组
    static func loadUserDetailWendaList(user_id: Int, cursor: String, completionHandler: @escaping (_ cursor: String, _ wendas: [UserDetailWenda]) -> ()) {
        let url = BASE_URL + "/wenda/profile/wendatab/brow/?"
        let params = ["other_id": user_id,
                      "format": "json",
                      "device_id": device_id,
                      "iid": iid] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            guard response.result.isSuccess else { completionHandler(cursor, []); return }
            if let value = response.result.value {
                let json = JSON(value)
                guard json["err_no"] == 0 else { completionHandler(cursor, []); return }
                if let answerQuestions = json["answer_question"].arrayObject {
                    if answerQuestions.count == 0 {
                        completionHandler(cursor, [])
                    } else {
                        let cursor = json["cursor"].string
                        completionHandler(cursor!, answerQuestions.compactMap({
                            UserDetailWenda.deserialize(from: $0 as? NSDictionary)
                        }))
                    }
                }
            }
        }
    }
}

struct NetWorkTool: NetWorkToolProtocol { }

