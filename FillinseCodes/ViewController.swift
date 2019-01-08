//
//  ViewController.swift
//  FillinseCodes
//
//  Created by Fillinse on 16/10/20.
//  Copyright © 2016年 Fillinse. All rights reserved.
//

import UIKit
let KScreen_width = UIScreen.main.bounds.width;
let KScreen_width_scale = UIScreen.main.bounds.width/320.0;
let KScreen_height = UIScreen.main.bounds.height;
let KScreen_height_scale = UIScreen.main.bounds.height/568.0;
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var tableView :UITableView!
    var dataSourceArray : NSArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      self.title = "知识点代码合集新";
        
        //内容
       self.dataSourceArray = ["Animations","CircleFlowBanner"]
        self.loadSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // program MARK -- tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.textLabel?.text = self.dataSourceArray.object(at: indexPath.row) as? String
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
        case 0:
            let animationVC = AnimationsAndGesturesViewController.init()
            self.navigationController?.pushViewController(animationVC, animated: true)
            break
        case 1:
            let circleVC = CircleFlowBannerController.init()
            self.navigationController?.pushViewController(circleVC, animated: true)
            break
        default:
            break
            
        }
    }
    private func loadSubViews()
    {
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: KScreen_width, height: KScreen_height - 64), style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }
    
}

