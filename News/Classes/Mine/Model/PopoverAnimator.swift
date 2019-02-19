//
//  PopoverAnimator.swift
//  News
//
//  Created by huzhongyang on 2019/2/5.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    /// 要展现的视图大小
    var presentFrame: CGRect?
    /// 记录当前是否打开
    var isPresent: Bool = false
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = MyPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame!
        return pc
    }
    
    /// 展开 关闭
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent { // 展开
            // 拿到展开的视图
            let toView = transitionContext.view(forKey: .to)
            toView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            transitionContext.containerView.addSubview(toView!)
            // 执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView?.transform = .identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        } else { // 关闭
            // 拿到关闭的视图
            let fromView = transitionContext.view(forKey: .from)
            // 执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                // 关闭
                fromView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    /// 只要实现了这个方法, 系统默认的动画就消失了, 所有的设置都要我们自己实现
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    /// 告诉系统谁来负责 Modal 的消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    /// 返回动画的时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
}
