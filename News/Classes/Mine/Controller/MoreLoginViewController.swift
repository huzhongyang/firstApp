//
//  MoreLoginViewController.swift
//  News
//
//  Created by huzhongyang on 2018/12/3.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable
import SwiftTheme

class MoreLoginViewController: AnimatableModalViewController {
    /// 关闭 button
    @IBOutlet weak var loginCloseButton: UIButton!
    /// 顶部标题
    @IBOutlet weak var topLabel: UILabel!
    /// 手机号 view
    @IBOutlet weak var mobileView: AnimatableView!
    /// 验证码 view
    @IBOutlet weak var passwordView: AnimatableView!
    /// 发送验证码 view
    @IBOutlet weak var sendVerifyView: UIView!
    /// 找回密码 view
    @IBOutlet weak var findPasswordView: UIView!
    /// 手机号输入框
    @IBOutlet weak var mobileTextField: UITextField!
    /// 发送验证码 button
    @IBOutlet weak var sendVerifyButton: UIButton!
    /// 验证码输入框
    @IBOutlet weak var passwordTextField: UITextField!
    /// 找回密码 button
    @IBOutlet weak var findpasswordButton: UIButton!
    /// 未注册提示 label
    @IBOutlet weak var middleTipLabel: UILabel!
    /// 进入头条 button
    @IBOutlet weak var enterToutiaoButton: AnimatableButton!
    /// 阅读条款 label
    @IBOutlet weak var readLabel: UILabel!
    /// 阅读条款 button
    @IBOutlet weak var readButton: UIButton!
    /// 账号密码登录
    @IBOutlet weak var loginModeButton: UIButton!
    
    /// 微信登录 button
    @IBOutlet weak var wechatLoginButton: UIButton!
    /// QQ登录 button
    @IBOutlet weak var qqLoginButton: UIButton!
    /// 天翼登录 button
    @IBOutlet weak var tianyiLoginButton: UIButton!
    /// mail登录 button
    @IBOutlet weak var mailLoginButton: UIButton!
    
    /// 账号密码登录 按钮点击
    @IBAction func loginModeButtonClicked(_ sender: UIButton) {
        /**
         默认: 手机号、发送验证码
              输入验证码
              账号密码登录
         
         点击按钮后: 手机号
                   密码、找回密码
                   免密码登录
         */
        loginModeButton.isSelected = !sender.isSelected
        sendVerifyView.isHidden = sender.isSelected
        findPasswordView.isHidden = !sender.isSelected
        middleTipLabel.isHidden = sender.isSelected
        passwordTextField.placeholder = sender.isSelected ? "密码" : "请输入验证码"
        topLabel.text = sender.isSelected ? "账号密码登录" : "登录你的头条，精彩永不消失"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModeButton.setTitle("免密码登录", for: .selected)
        
        // 设置夜间主题
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        topLabel.theme_textColor = "colors.black"
        middleTipLabel.theme_textColor = "colors.cellRightTextColor"
        readLabel.theme_textColor = "colors.black"
        enterToutiaoButton.theme_backgroundColor = "colors.enterToutiaoBackgroundColor"
        enterToutiaoButton.theme_setTitleColor("colors.enterToutiaoTextColor", forState: .normal)
        /*********************************************
         设置这个按钮的选中状态图片时 错误
         */
//        readButton.theme_setImage("images.loginReadButtonSelected", forState: .normal)
//        readButton.theme_setImage("images.loginReadButton", forState: .selected)
        mobileView.theme_backgroundColor = "colors.loginMobileViewBackgroundColor"
        passwordView.theme_backgroundColor = "colors.loginMobileViewBackgroundColor"
        loginCloseButton.theme_setImage("images.loginCloseButtonImage", forState: .normal)
        wechatLoginButton.theme_setImage("images.moreLoginWechatButton", forState: .normal)
        qqLoginButton.theme_setImage("images.moreLoginQQButton", forState: .normal)
        tianyiLoginButton.theme_setImage("images.moreLoginTianyiButton", forState: .normal)
        mailLoginButton.theme_setImage("images.moreLoginMailButton", forState: .normal)
    }
 
    @IBAction func readButton(_ sender: UIButton) {
        print("点击前" + "\(sender.isSelected)" + "\(String(describing: sender.imageView?.image))")
        sender.isSelected = !sender.isSelected
        print("点击前" + "\(sender.isSelected)" + "\(String(describing: sender.imageView?.image))")
    }
    
    // 关闭更多界面控制器界面
    @IBAction func moreLoginCloseButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
