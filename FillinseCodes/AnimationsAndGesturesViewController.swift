//
//  AnimationsAndGesturesViewController.swift
//  FillinseCodes
//
//  Created by Fillinse on 16/10/20.
//  Copyright © 2016年 Fillinse. All rights reserved.
//

import UIKit
import Foundation
enum FAnimationStyle : NSInteger
{
    case MoveOne = 1                //右上角
    case MoveTwo                    //右下角
    case MoveThree                  //左下角
    case MoveFour                   //左上角
    case MoveUp                     //上
    case MoveRight                  //右
    case MoveDown                   //下
    case MoveLeft                   //左
    case ScaleIn                    //缩小
    case ScaleOut                   //放大
    case Alpha                      //透明度
    case RotationAndScaleIn         //旋转缩进
    case RotationAndScaleOut        //旋转展出
    case Spring                     //弹簧展出
    case SpringContinue             //弹簧展出优化后续
    case FlipFromLeft     //转场，从左向右旋转翻页
    case FlipFromRight    //转场，从右向左旋转翻页
    case FlipFromTop      //转场，从上向下旋转翻页
    case FlipFromBottom   //转场，从下向上旋转翻页
    case CurlUp           //转场，下往上卷曲翻页
    case CurlDown         //转场，从上往下卷曲翻页
    case CrossDissolve    //转场，交叉消失和出现
    case Fade             //
    case MoveIn           //
    case Push             //
    case Reveal           //
    case SuckEffect       //三角
    case RippleEffect     //水波抖动
    case PageCurl         //上翻页
    case PageUnCurl       //下翻页
    case OglFlip          //上下翻转
    case CameraIris       //
    case Cube_p           //立方体效果

}
//enum FAnimationStyle :NSInteger {
//    case MoveOne = 1,MoveTwo
//}
class AnimationsAndGesturesViewController: UIViewController
{
    var timer : Timer!
    var repeatSeconds = 0
    var animationImageView : UIImageView!
    var backGroudImageView : UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Animations";
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()

        self.backGroudImageView = UIImageView.init(frame: self.view.bounds)
        self.backGroudImageView.image = UIImage.init(named: "1")
        self.view.addSubview(self.backGroudImageView)
        self.animationImageView = UIImageView.init(frame: self.view.bounds)
        self.animationImageView.image = UIImage.init(named: "1")
        self.view.addSubview(self.animationImageView)
        self.repeatSeconds = 0;
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animationSteps()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func  viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
        self.timer = nil
    }
   private func animationSteps()
   {
    // 倒计时时间
    //取随机图片
    var lastPic = 1
    self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (Timer) in
        //计算动画类型
        let pic = arc4random()%5 + 1
        lastPic = Int(pic)
        let counts = (self.repeatSeconds % 11) + 22
        let style = self.typeForImageView(counts: counts)
        //处理图片变大的时候的闪动问题
       if style == FAnimationStyle.ScaleOut || style.rawValue == FAnimationStyle.RotationAndScaleOut.rawValue || style.rawValue == FAnimationStyle.Spring.rawValue || FAnimationStyle.SpringContinue.rawValue == style.rawValue
       {
        
        }
        else
       {
        self.backGroudImageView.image = UIImage.init(named: String.init(format: "%d", pic))
        }
        print(style.rawValue)

         switch style
        {
        case .MoveOne,.MoveTwo,.MoveThree,.MoveFour,.MoveUp,.MoveDown,.MoveLeft,.MoveRight :
            self.centerChangedAnimations(style: style, lastPic: lastPic)
        case .ScaleIn,.ScaleOut :
            self.boundsChangedAnimations(style: style, lastPic: lastPic)
        case .Alpha:
            self.alphaChangedAnimation(style: style, lastPic: lastPic)
        case .RotationAndScaleIn,.RotationAndScaleOut:
            self.rotationScaleAnimations(style: style, lastPic: lastPic)
        case .Spring,.SpringContinue:
            self.springAnimation(style: style, lastPic: lastPic)
        case .CurlUp,.CurlDown,.FlipFromRight,.FlipFromLeft,.FlipFromTop,.FlipFromBottom,.CrossDissolve:
            self.flipAndCurAnimations(style: style, lastPic: lastPic)
       case .Fade,.MoveIn,.Push,.Reveal,.SuckEffect,.RippleEffect,.PageUnCurl,.PageCurl,.OglFlip,.CameraIris,.Cube_p:
            self.CATransitionAnimations(style: style, lastPic: lastPic)
         default:
            break
        }
        self.repeatSeconds += 1
    })
    }
    //改变中心点动画
    private func centerChangedAnimations(style:FAnimationStyle,lastPic:NSInteger)
    {
        UIView.animate(withDuration: 1.0, animations:
            {
                switch style
                {
                case .MoveOne:
                    self.animationImageView.center = CGPoint.init(x: 1.5 * KScreen_width, y: -0.5 * KScreen_height)
                case .MoveTwo:
                    self.animationImageView.center = CGPoint.init(x: 1.5 * KScreen_width, y: 1.5 * KScreen_height)
                case .MoveThree:
                    self.animationImageView.center = CGPoint.init(x: -0.5 * KScreen_width, y: 1.5 * KScreen_height)
                case .MoveFour:
                    self.animationImageView.center = CGPoint.init(x: -0.5 * KScreen_width, y: -0.5 * KScreen_height)
                case .MoveUp:
                    self.animationImageView.center = CGPoint.init(x: 0.5 * KScreen_width, y: -0.5 * KScreen_height)
                case .MoveRight:
                    self.animationImageView.center = CGPoint.init(x: 1.5 * KScreen_width, y: 0.5 * KScreen_height)
                case .MoveDown:
                    self.animationImageView.center = CGPoint.init(x: 0.5 * KScreen_width, y: 1.5 * KScreen_height)
                case .MoveLeft:
                    self.animationImageView.center = CGPoint.init(x: -0.5 * KScreen_width, y: 0.5 * KScreen_height)
                default:
                    break
                }
            }, completion: { (Bool) in
                self.animationImageView.center = CGPoint.init(x: 0.5 * KScreen_width, y: 0.5 * KScreen_height)
                self.animationImageView.image = UIImage.init(named: String.init(format: "%d", lastPic))
        })
    }
    //改变bounds的动画
    private func boundsChangedAnimations(style:FAnimationStyle,lastPic:NSInteger)
    {
        UIView.animate(withDuration: 1.0, animations:
            {
            switch style
                {
                case .ScaleIn:
                    self.animationImageView.bounds = CGRect.init(origin: self.animationImageView.frame.origin, size: CGSize.init(width: 1, height: KScreen_height))
                case .ScaleOut:
                    self.animationImageView.bounds = CGRect.init(origin: self.animationImageView.frame.origin, size: CGSize.init(width: KScreen_width, height: KScreen_height))
                default:
                    break
                }
            }, completion: { (Bool) in
                if style == FAnimationStyle.ScaleIn
                {
                    self.animationImageView.image = UIImage.init(named: String.init(format: "%d", lastPic))
                }
            switch style
                {
                case .ScaleIn:
                    self.animationImageView.bounds = CGRect.init(origin: self.animationImageView.frame.origin, size: CGSize.init(width: KScreen_width, height: 1))
                case.ScaleOut:
                break

            default:
                break
                }
        })
    }
    //透明度动画
    private func alphaChangedAnimation(style:FAnimationStyle,lastPic:NSInteger)
    {
        UIView.animate(withDuration: 1, animations:
            {
                self.animationImageView.alpha = 0.01;
            }) { (Bool) in
                self.animationImageView.alpha = 1
                self.animationImageView.image = UIImage.init(named: String.init(format: "%d", lastPic))
        }
    }
    //旋转动画
    private func rotationScaleAnimations(style:FAnimationStyle,lastPic:NSInteger)
    {
      let animation = CABasicAnimation.init(keyPath: "transform.rotation")
        animation.duration = 0.8;
        animation.repeatCount = 1;
        animation.autoreverses = false
        animation.timingFunction = CAMediaTimingFunction.init(name:kCAMediaTimingFunctionLinear)
        animation.fromValue = 0;
        animation.toValue = M_PI * 4
        
        let animation2 = CABasicAnimation.init(keyPath: "transform.scale")
        animation2.duration = 0.8;
        animation2.repeatCount = 0;
        animation2.autoreverses = false
        animation2.timingFunction = CAMediaTimingFunction.init(name:kCAMediaTimingFunctionLinear)
        
        switch style
        {
        case .RotationAndScaleIn:
            animation2.fromValue = 1;
            animation2.toValue = 0.01
            self.animationImageView.image = UIImage.init(named: String.init(format: "%d", lastPic))
        case .RotationAndScaleOut:
            animation2.fromValue = 0.01;
            animation2.toValue = 1
        default:
            break
        }
        self.animationImageView.layer.add(animation2, forKey: "rotation2")
        self.animationImageView.layer.add(animation, forKey: "rotation")

    }
    //弹簧动画
    private func springAnimation(style:FAnimationStyle,lastPic:NSInteger)
    {
        if style.rawValue == FAnimationStyle.SpringContinue.rawValue
        {
            return
        }
        self.animationImageView.center = CGPoint.init(x: KScreen_width/2, y: -KScreen_height/2)
        UIView.animate(withDuration: 0.5, animations:
            {
                self.animationImageView.center = CGPoint.init(x: KScreen_width/2, y: -KScreen_height/2 - 80)
        }) { (Bool) in
            UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveLinear, animations:
                {
                    self.animationImageView.center = CGPoint.init(x: KScreen_width/2, y: KScreen_height/2)
            }) { (Bool) in
                
            }
        }
    }
    //仿真卷曲翻页动画
    private func flipAndCurAnimations(style:FAnimationStyle,lastPic:NSInteger)
    {
        var options : UIViewAnimationOptions!
        switch style
        {
        case .CurlUp:
            options = UIViewAnimationOptions.transitionCurlUp
        case .CurlDown:
            options = UIViewAnimationOptions.transitionCurlDown
        case .FlipFromTop:
            options = UIViewAnimationOptions.transitionFlipFromTop
        case .FlipFromBottom:
            options = UIViewAnimationOptions.transitionFlipFromBottom
        case .FlipFromLeft:
            options = UIViewAnimationOptions.transitionFlipFromLeft
        case .FlipFromRight:
            options = UIViewAnimationOptions.transitionFlipFromRight
        case .CrossDissolve:
            options = UIViewAnimationOptions.transitionCrossDissolve
        default:
            break
        }
        UIView.transition(with: self.animationImageView, duration: 1.0, options: options, animations:
            {
                self.animationImageView.image = UIImage.init(named: String.init(format: "%d", lastPic))
            }) { (Bool) in
        }
    }
    //CAT动画
    private func CATransitionAnimations(style:FAnimationStyle,lastPic:NSInteger)
    {
        let subTransitions : NSArray = [kCATransitionFromTop,kCATransitionFromRight,kCATransitionFromBottom,kCATransitionFromLeft];
        let index = arc4random()%4
        var transitions = ""
        let subTransiton = subTransitions.object(at: Int(index)) as! String
        switch style
        {
        case .Fade:
            transitions = kCATransitionFade
        case .MoveIn:
            transitions = kCATransitionMoveIn
        case .Push:
            transitions = kCATransitionPush
        case .Reveal:
            transitions = kCATransitionReveal
        case .SuckEffect:
            transitions = "suckEffect"
        case .RippleEffect:
            transitions = "rippleEffect"
        case .PageCurl:
            transitions = "pageCurl"
        case .PageUnCurl:
            transitions = "pageUnCurl"
        case .OglFlip:
            transitions = "oglFlip"
        case .CameraIris:
            transitions = "cameraIris"
        case .Cube_p:
            transitions = "cube"
        default:
            break
        }
        let animation = CATransition.init()
        animation.duration = 5.0
        animation.timingFunction = CAMediaTimingFunction.init(name: "easeIn")
//        animation.filter = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        animation.type = transitions
        animation.subtype = subTransiton
        self.animationImageView.layer.add(animation, forKey: "animation")
        self.animationImageView.image = UIImage.init(named: String.init(format: "%d", lastPic))
    }
    //处理枚举类型
    private func typeForImageView(counts:NSInteger) ->FAnimationStyle
    {
        var style : FAnimationStyle!
        switch counts
        {
        case 0:
            style = FAnimationStyle.MoveOne
            break
        case 1:
            style = FAnimationStyle.MoveTwo
            break
        case 2:
            style = FAnimationStyle.MoveThree
            break
        case 3:
            style = FAnimationStyle.MoveFour
            break
        case 4:
            style = FAnimationStyle.MoveUp
            break
        case 5:
            style = FAnimationStyle.MoveRight
            break
        case 6:
            style = FAnimationStyle.MoveDown
            break
        case 7:
            style = FAnimationStyle.MoveLeft
            break
        case 8:
            style = FAnimationStyle.ScaleIn
            break
        case 9:
            style = FAnimationStyle.ScaleOut
            break
        case 10:
            style = FAnimationStyle.Alpha
            break
        case 11:
            style = FAnimationStyle.RotationAndScaleIn
            break
        case 12:
            style = FAnimationStyle.RotationAndScaleOut
            break
        case 13:
            style = FAnimationStyle.Spring
            break
        case 14:
            style = FAnimationStyle.SpringContinue
            break
        case 15:
            style = FAnimationStyle.FlipFromLeft
            break
        case 16:
            style = FAnimationStyle.FlipFromRight
            break
        case 17:
            style = FAnimationStyle.FlipFromTop
            break
        case 18:
            style = FAnimationStyle.FlipFromBottom
            break
        case 19:
            style = FAnimationStyle.CurlUp
            break
        case 20:
            style = FAnimationStyle.CurlDown
            break
        case 21:
            style = FAnimationStyle.CrossDissolve
            break
        case 22:
            style = FAnimationStyle.Fade
            break
        case 23:
            style = FAnimationStyle.MoveIn
            break
        case 24:
            style = FAnimationStyle.Push
            break
        case 25:
            style = FAnimationStyle.Reveal
            break
        case 26:
            style = FAnimationStyle.SuckEffect
            break
        case 27:
            style = FAnimationStyle.RippleEffect
            break
        case 28:
            style = FAnimationStyle.PageCurl
            break
        case 29:
            style = FAnimationStyle.PageUnCurl
            break
        case 30:
            style = FAnimationStyle.OglFlip
            break
        case 31:
            style = FAnimationStyle.CameraIris
            break
        case 32:
            style = FAnimationStyle.Cube_p
            break
        default:
            break
        }
        return style
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
