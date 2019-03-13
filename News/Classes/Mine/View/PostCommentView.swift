//
//  PostCommentView.swift
//  News
//
//  Created by huzhongyang on 2019/3/13.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable

class PostCommentView: UIView, NibLoadable {

    /// 底部约束
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    /// 发布按钮
    @IBOutlet weak var postButton: UIButton!
    /// 同时转发
    @IBOutlet weak var forwardButton: UIButton!
    /// @ 按钮
    @IBOutlet weak var atButton: UIButton!
    /// emoji 按钮
    @IBOutlet weak var emojiButton: UIButton!
    /// 占位符
    @IBOutlet weak var placeholderLabel: UILabel!
    /// textView
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    /// 背景 View
    @IBOutlet weak var textViewBackgroundView: AnimatableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        forwardButton.isSelected = true
        textViewBackgroundView.theme_backgroundColor = "colors.grayColor240"
        forwardButton.theme_setImage("images.loginReadButton", forState: .normal)
        forwardButton.theme_setImage("images.loginReadButtonSelected", forState: .selected)
        atButton.theme_setImage("images.toolbar_icon_at_24x24_", forState: .normal)
        emojiButton.theme_setImage("images.toolbar_icon_emoji_24x24_", forState: .normal)
        emojiButton.theme_setImage("images.toolbar_icon_keyboard_24x24_", forState: .selected)
        
        // 第一响应者
        textView.becomeFirstResponder()
        
        // 添加监听, 监听键盘的 弹起 和 隐藏
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 键盘将要弹起
    @objc func keyboardWillShow(notification: Notification) {
        // 取出键盘的 frame
        let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        // 动画的持续时间
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration, animations: {
//            self.bottomViewBottom.constant = frame.size.height
            // 在 iPhoneX 上 键盘高度291, 如果有预测栏(42)高度就是 333. 这里如果不减去 57, 视图位置有问题
            // 之前的手机的高度是 216
            self.bottomViewBottom.constant = frame.size.height - (isIPhoneX ? 57 : 0)
            self.layoutIfNeeded()
        })
    }
    /// 键盘将要隐藏
    @objc func keyboardWillHiden(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration, animations: {
            self.bottomViewBottom.constant = 0
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    /// 移除键盘的响应
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 点击事件
extension PostCommentView {
    
    @IBAction func forwardButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    /// 发布按钮点击
    @IBAction func postButtonClicked(_ sender: UIButton) {
        
    }
    
    /// @ 按钮点击
    @IBAction func atButtonClicked(_ sender: UIButton) {
        
    }
    
    /// emoji 按钮点击
    @IBAction func emojiButtonClicked(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected { // 说明需要弹起的是表情
//            textView.resignFirstResponder()
//            isEmojiButtonSelected = true
//        } else {  // 说明需要弹起的是键盘
//            textView.becomeFirstResponder()
//        }
    }
}

// MARK: - textView 的代理
extension PostCommentView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        setup(textView.text)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setup(textView.text)
    }
    
    /// textView 输入文字的时候, 输入框的一些变化设置
    private func setup(_ text: String) {
        placeholderLabel.isHidden = text != ""
        postButton.setTitleColor((text != "") ? UIColor.blueFontColor() : UIColor.grayColor210(), for: .normal)
        let height = Calculate.textHeight(text: text, fontSize: 16, width: textView.width)
        textViewHeight.constant = height >= 80 ? 80 : height
    }
}
