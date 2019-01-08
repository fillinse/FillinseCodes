//
//  CircleFlowBannerController.swift
//  FillinseCodes
//
//  Created by Fillinse on 16/11/3.
//  Copyright © 2016年 Fillinse. All rights reserved.
//

import Foundation
import UIKit

struct CirclePoint
{
    var x : CGFloat
    var y : CGFloat
    var z : CGFloat
}

class CircleFlowBannerController: UIViewController
{
    var dataSourceArray : NSMutableArray!
    var itemsArray : NSMutableArray!
    var lastPoint : CGPoint!
    var anglesArray : NSMutableArray!
    var autoLink :CADisplayLink?
    var decelerLink :CADisplayLink?
    var velocity : CGFloat!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        self.title = "旋转吧";
        
        //内容
        self.itemsArray = NSMutableArray.init()
        self.anglesArray = NSMutableArray.init()
        self.dataSourceArray = self.DataSourceArray()
        self.loadSubViews()
    }
    
    private func loadSubViews()
    {
        self.itemsArray = self.itemsArrayWithImageNames()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(gesture:)))
        self.view.addGestureRecognizer(gesture)
        self.startAutoDisplayLink()
    }
    
    private func itemsArrayWithImageNames() -> NSMutableArray
    {
        let itemsArr = NSMutableArray.init()
        for name in self.dataSourceArray
        {
            let imageItem = UIImageView.init(image: UIImage.init(named: name as! String))
            imageItem.center = CGPoint.init(x: KScreen_width/2, y: KScreen_height/2 + 100)
            imageItem.bounds = CGRect.init(x: 0, y: 0, width: 90, height: 160)
            self.view.addSubview(imageItem)
            itemsArr.add(imageItem)
            self.changePoint(item: imageItem, index: self.dataSourceArray.index(of: name))
        }
        return itemsArr
    }
    private func changePoint(item : UIImageView,index : NSInteger)
    {
        let angle = Float(CGFloat(CGFloat(index) * CGFloat(2 * M_PI))/12)
        let y = cosf(angle)
        let x = sinf(angle)
        let z = cosf(angle)
        let circlePoint = CirclePoint.init(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z))
        let angleString : NSString = NSString.init(format: "%f", angle)
        self.anglesArray.add(angleString)
        self.moveWithPointAndIndex(circlePoint: circlePoint, item: item)
    }
    private func moveWithPointAndIndex(circlePoint:CirclePoint,item:UIImageView)
    {
//        NSLog("%f", circlePoint.z)
        item.center = CGPoint.init(x: CGFloat(CGFloat(circlePoint.x) * 160 + KScreen_width/2), y: KScreen_height/2 + circlePoint.y * 100)
        let transform = (circlePoint.z + 3)/4
        item.transform = CGAffineTransform.init(scaleX: transform * transform, y: transform * transform)
        item.layer.zPosition = transform
        item.alpha = transform
    }
    private func DataSourceArray() -> NSMutableArray
    {
        let dataArray : NSMutableArray = NSMutableArray.init()
        for index in 1...12
        {
            let imageName = NSString.init(format: "%d.jpg", index)
            dataArray.add(imageName)
        }
        return dataArray
    }
    
    func handlePanGesture(gesture:UITapGestureRecognizer)
    {
        if gesture.state == .began
        {
            lastPoint = gesture.location(in: self.view)
            self.autoLinkStop()
            self.decelerLinkStop()
        }
        else if gesture.state == .changed
        {
            let currentPoint = gesture.location(in: self.view)
            let instance = currentPoint.x - lastPoint.x
            let angle = instance/320 * 2
            self.updateCenterWithAngle(changeAngles: angle)
            lastPoint = currentPoint
        }
        else if gesture.state == .ended
        {
            let velocityPoint = gesture.location(in: self.view)
            self.velocity = CGFloat(sqrtf(Float(CGFloat(velocityPoint.x * velocityPoint.x + velocityPoint.y * velocityPoint.y))))
            self.startDecelerationDisplayLick()
        }
    }
    private func updateCenterWithAngle(changeAngles : CGFloat)
    {
        for angle in self.anglesArray
        {
            let index = self.anglesArray.index(of: angle)
            let newAngle : CGFloat = CGFloat((angle as! NSString).floatValue) + changeAngles
            self.anglesArray.replaceObject(at: index, with: NSString.init(format: "%f", newAngle))
            self.updateItemsCenterWithAngle(angle: newAngle, index: index)
        }
    }
    private func updateItemsCenterWithAngle(angle : CGFloat,index : NSInteger)
    {
        let item = self.itemsArray[index] as! UIView
        let y = cosf(Float(angle))
        let x = sinf(Float(angle))
        let z = cosf(Float(angle))
        item.center = CGPoint.init(x: CGFloat(CGFloat(x) * 160 + KScreen_width/2), y: KScreen_height/2 + CGFloat(y) * 100)
        let transform = (CGFloat(z) + 3)/4.0 
        item.transform = CGAffineTransform.init(scaleX: transform * transform, y: transform * transform)
        item.layer.zPosition = transform
        item.alpha = transform
    }
    //默认刷新屏幕
    private func startAutoDisplayLink()
    {
        self.autoLink = CADisplayLink.init(target: self, selector: #selector(autoLinkStart))
        self.autoLink?.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
    }
     func autoLinkStart()
    {
      self.updateCenterWithAngle(changeAngles: -0.002)
    }
    func autoLinkStop()
    {
        self.autoLink?.invalidate()
        self.autoLink = nil
    }
    //衰减刷新屏幕
    func startDecelerationDisplayLick()
    {
        self.autoLinkStop()
        self.decelerLink = CADisplayLink.init(target: self, selector:#selector(decelerLinkStart))
    }
    func decelerLinkStart()
    {
        if self.velocity <= 0
        {
            self.decelerLinkStop();
        }
        else
        {
            self.velocity = self.velocity - 70
            let angle = self.velocity/320 * 0.01
            self.updateCenterWithAngle(changeAngles: angle)
        }
    }
    func decelerLinkStop()
    {
        self.decelerLink?.invalidate()
        self.decelerLink = nil
        self.startAutoDisplayLink()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
