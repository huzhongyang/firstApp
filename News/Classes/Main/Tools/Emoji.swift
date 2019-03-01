//
//  Emoji.swift
//  News
//
//  Created by huzhongyang on 2019/3/1.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import Foundation
import HandyJSON

struct Emoji: HandyJSON {
    var name = ""
    var id = ""
    var png = ""
}

struct EmojiManger {
    /// emoji 数组
    var emojis = [Emoji]()
    
    init() {
        // 获取 emoji.plist 文件的路径
        let path = Bundle.main.path(forResource: "emojis.plist", ofType: nil)
        // 根据 plist 文件，读取数据
        let array = NSArray(contentsOfFile: path!) as! [[String: String]]
        // 字典转模型
        emojis = array.compactMap({ Emoji.deserialize(from: $0 as NSDictionary) })
    }
    
    /// 显示 emoji 表情
    func showEmoji(content: String, font: UIFont) -> NSMutableAttributedString {
        // 将 content 转成 attributedString
        let attributedString = NSMutableAttributedString(string: content)
        // emoji 表情的正则表达式
        let emojiPattern = "\\[.*?\\]"
        // 创建正则表达式对象，匹配 emoji 表情
        let regex = try! NSRegularExpression(pattern: emojiPattern, options: [])
        // 开始匹配并返回结果
        let results = regex.matches(in: content, options: [], range: NSRange(location: 0, length: attributedString.length))
        if results.count != 0 {
            // 倒序遍历，从最后一个开始替换。若从第一个开始替换，字符串的长度变化会影响替换结果
            for index in stride(from: results.count - 1, through: 0, by: -1) {
                // 取出结果的范围
                let result = results[index]
                // 从传入的内容 content 中取出 emoji 的名字
                let emojiName = (content as NSString).substring(with: result.range)
                // 取出对应的 emoji 模型
                let emoji = emojis.filter({ $0.name == emojiName }).first!
                // 设置图片
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: emoji.png)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                let attributedImageStr = NSAttributedString(attachment: attachment)
                // 将文字替换为 emoji 图片
                attributedString.replaceCharacters(in: result.range, with: attributedImageStr)
            }
        }
        return attributedString
    }
}
