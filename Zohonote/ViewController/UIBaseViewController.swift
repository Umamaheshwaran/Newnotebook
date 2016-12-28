//
//  UIBaseViewController.swift
//  Zohonote
//
//  Created by Uma Maheshwaran on 26/12/16.
//  Copyright © 2016 RajesSuku. All rights reserved.
//

import UIKit

class UIBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setNavigationBar()
    }
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 59.0/255.0, green: 181.0/255.0, blue: 58.0/255.0, alpha: 1)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func alert(_ title: String?, message: String!, okTitle: String! = "OK", okCallBack: (() -> Void)? = nil, cancelTitle:String? = nil,cancelCallBack: (()-> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
        alertController.addAction(UIAlertAction(title: okTitle, style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            okCallBack?();
        }));
        if (cancelTitle != nil)
        {
            alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) -> Void in
                cancelCallBack?();
            }));
        }
        self.present(alertController, animated: true, completion: nil);
    }
    func actionSheetAlert(_ title: String?, message: String!, btn1Title: String! = "OK", btn1CallBack: (() -> Void)? = nil, btn2Title:String? = nil,btn2CallBack: (()-> Void)? = nil , cancelTitle:String? = nil,cancelCallBack: (()-> Void)? = nil,_ selectedOption: SelectedActionSheetOption)  {
        
        let actionSheetController: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        actionSheetController.view.tintColor = UIColor(red: 59.0/255.0, green: 181.0/255.0, blue: 58.0/255.0, alpha: 1)
        

        if selectedOption == .Other{
            actionSheetController.addAction(UIAlertAction(title: btn1Title, style: UIAlertActionStyle.destructive, handler: { (action: UIAlertAction) -> Void in
                btn1CallBack?();
            }));

        }
        else{
            actionSheetController.addAction(UIAlertAction(title: btn1Title, style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
                btn1CallBack?();
            }));
        }
        actionSheetController.addAction(UIAlertAction(title: btn2Title, style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            btn2CallBack?();
        }));
        if (cancelTitle != nil)
        {
        actionSheetController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.destructive, handler: { (action: UIAlertAction) -> Void in
                cancelCallBack?();
            }));
        }
        
        present(actionSheetController, animated: true, completion: nil)

    }

    deinit {
        NotificationCenter.default.removeObserver(self);
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
