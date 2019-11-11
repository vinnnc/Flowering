//
//  ActivityViewController.swift
//  Flowering
//
//  Created by 冷禹彤 on 10/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import CVCalendar
import CoreData

class ActivityViewController: UIViewController {
    
    private var menuView: CVCalendarMenuView!
     
    // The main view of calendar
    private var calendarView: CVCalendarView!
     
    var currentCalendar: Calendar!
    
    var currentDate: Date!
    
    var farmDate: FarmDate?
    
    var dates: [FarmDate] = []
    
    var appDelegate: AppDelegate?
    
    var water: UIButton = UIButton(frame: CGRect(x: 40, y: 600, width: 150, height: 50))
    
    var fert: UIButton = UIButton(frame: CGRect(x: 190, y: 600, width: 150, height: 50))
    
    var state: FarmDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentCalendar = Calendar.init(identifier: .gregorian)
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let new = dateFormatter.string(from: today)
        currentDate = dateFormatter.date(from: new)
        print(currentDate!)
        // Navigate to current year and month when initialisation
        self.title = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        
        // Initial the current menu
        self.menuView = CVCalendarMenuView(frame: CGRect(x:0, y:90, width:self.view.frame.width, height:15))
         
        // Initial the main calendar view
        self.calendarView = CVCalendarView(frame: CGRect(x:0, y:120, width:self.view.frame.width, height:450))
         
        // The delegate of week menu
        self.menuView.menuViewDelegate = self
         
        // The delegate of calendar
        self.calendarView.calendarDelegate = self
        
        
        // Add menu and calendar into the main view
        self.view.addSubview(menuView)
        self.view.addSubview(calendarView)
        
        water = UIButton(frame: CGRect(x: 40, y: 600, width: 150, height: 50))
        // set the title of button
        water.setTitle("Watering", for: .normal)
        // set the colour of button
        water.setTitleColor(UIColor.white, for: .normal)
        // set the shadow of button
        water.setTitleShadowColor(UIColor.black, for: .normal)
        water.setTitle("Watered", for: .selected)
        
        // set the font style of button
        water.titleLabel!.font = UIFont.systemFont(ofSize: 18)
        // set the line of button
        water.titleLabel!.lineBreakMode = .byTruncatingTail
        // set the background of button
        water.backgroundColor = UIColor(red: 200.0/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.9)
        water.layer.cornerRadius = 25
        // set the frame of button
        water.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        water.adjustsImageWhenHighlighted = true

        water.adjustsImageWhenDisabled = false
        // set the highlight of button when tap
        water.showsTouchWhenHighlighted  = true
        water.tag = 1
        water.addTarget(self, action: #selector(ActivityViewController.buttonClick(sender:)), for: .touchUpInside)
        
        self.view.addSubview(water)
        
        fert = UIButton(frame: CGRect(x: self.view.frame.width - 190, y: 600, width: 150, height: 50))
        // set the title of button
        fert.setTitle("Fertilizing", for: .normal)
        fert.setTitle("Fertilized", for: .selected)
        // set the colour of button title
        fert.setTitleColor(UIColor.white, for: .normal)
        // set the shadow of button title
        fert.setTitleShadowColor(UIColor.black, for: .normal)
        // set the font style
        fert.titleLabel!.font = UIFont.systemFont(ofSize: 18)
        // set the line style of title button
        fert.titleLabel!.lineBreakMode = .byTruncatingTail
        // set the background of button
        fert.backgroundColor = UIColor(red: 200.0/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.9)
        fert.layer.cornerRadius = 25
        // set the inner frame of button
        fert.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        fert.adjustsImageWhenHighlighted = true

        fert.adjustsImageWhenDisabled = false
        // set the highlight when tap the button
        fert.showsTouchWhenHighlighted  = true
        
        fert.tag = 2
        fert.addTarget(self, action: #selector(ActivityViewController.buttonClick(sender:)), for: .touchUpInside)
        
        self.view.addSubview(fert)
        
        loadData()
    }
    
    func loadData() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        
        
        do {
            try dates = context.fetch(FarmDate.fetchRequest()) as [FarmDate]
            if dates.count == 0 {
                farmDate = NSEntityDescription.insertNewObject(forEntityName: "FarmDate", into: context) as? FarmDate
                let dformatter = DateFormatter()
                dformatter.dateFormat = "yyyy"
                farmDate?.year = Int16(dformatter.string(from: currentDate)) ?? 0
                dformatter.dateFormat = "MM"
                farmDate?.month = Int16(dformatter.string(from: currentDate)) ?? 0
                dformatter.dateFormat = "dd"
                farmDate?.day = Int16(dformatter.string(from: currentDate)) ?? 0
                farmDate?.fert = false
                farmDate?.water = false
                do{
                // save the context
                    try context.save()
                    print("Success to save data.")
                    } catch{
                            print("Failed to save data.")
                    }
            }
            else{
                farmDate = dates.last
                print(farmDate!)
            }
        } catch {
            print("Failed to load plant data from database.")
        }
        self.calendarView.contentController.refreshPresentedMonth()
    }
    
    func updateView() {
       
    }
    
    @IBAction func todayButtonTapoed(_ sender: Any) {
        let today = Date()
            currentDate = today
            self.calendarView.toggleViewWithDate(today)
        }
         
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
             
            //更新日历frame
            self.menuView.commitMenuViewUpdate()
            self.calendarView.commitCalendarViewUpdate()
        }
         
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    }

     
    extension ActivityViewController: CVCalendarViewDelegate,CVCalendarMenuViewDelegate {
        // view mode
        func presentationMode() -> CalendarMode {
            //使用月视图
            return .monthView
        }
         
        // the first day of week
        func firstWeekday() -> Weekday {
            // start from Monday
            return .monday
        }
         
        func presentedDateUpdated(_ date: CVDate) {
            // show the current date on the navigation bar
            self.title = date.globalDescription
        }
         
        // add separate line on each week
        func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
            return true
        }
         
        // set date when select month (current day if current month, the first day if others)
        func shouldAutoSelectDayOnMonthChange() -> Bool {
            return false
        }
         
        // the reaction of date select
        func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
            //获取日期appDelegate = UIApplication.shared.delegate as? AppDelegate
            currentDate = dayView.date.convertedDate()
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy"
            let year = Int16(dformatter.string(from: currentDate)) ?? 0
            dformatter.dateFormat = "MM"
            let month = Int16(dformatter.string(from: currentDate)) ?? 0
            dformatter.dateFormat = "dd"
            let day = Int16(dformatter.string(from: currentDate)) ?? 0
            print(year)
            print(day)
            print(month)
            let context = appDelegate!.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "FarmDate", in: context)
                    
            //        add a data request
                    let request = NSFetchRequest<FarmDate>(entityName: "FarmDate")
            //        set the offset
                    request.fetchOffset = 0
            //        set the amount of data
                    request.fetchLimit = 1
            //        set the entity
                    request.entity = entity
                    
            print("\(year)\(month)\(day)")
            let predicate = NSPredicate(format: "year= '\(year)' ", "month= '\(month)' ","day= '\(day)' ")
            print(predicate)
                    request.predicate = predicate
            
            do {
                let results:[AnyObject]? = try context.fetch(request)
                //            对提取结果进行遍历
                for test: FarmDate in results as! [FarmDate]{
                    print("year=\(String(describing: test.year))")
                    print("year=\(String(describing: test.month))")
                    print("year=\(String(describing: test.day))")
                    state = test
                    
                    print("year=\(String(describing: state?.year))")
                    print("year=\(String(describing: state?.month))")
                    print("year=\(String(describing: state?.day))")
                    if farmDate?.fert ?? false{
                        fert.isSelected = false
                        fert.backgroundColor = UIColor(red: 200.0/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.9)
                    }
                    else{
                        fert.isSelected = true
                        fert.backgroundColor = UIColor(red: 125/255.0, green: 201/255.0, blue: 83/255.0, alpha: 1.0)
                    }
                    if farmDate?.water ?? false{
                        water.isSelected = false
                        water.backgroundColor = UIColor(red: 200.0/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.9)
                    }
                    else{
                        water.isSelected = true
                        water.backgroundColor = UIColor(red: 56/255.0, green: 104/255.0, blue: 184/255.0, alpha: 1.0)
                    }
                    print(test)
                }
                
                try context.save()
                
            } catch {
                print("Failed to load plant data from database.")
            }
            self.calendarView.contentController.refreshPresentedMonth()
            
            
            
        }
        
        func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
            if !dayView.isHidden && dayView.date != nil {
                // get the year, month, day of date
                let year = dayView.date.year
                let month = dayView.date.month
                let day = dayView.date.day
                // check if data is available
                for farm in dates{
                    if year == farm.year && month == farm.month && day == farm.day {
                    return true
                    }
                }
            }
            return false
        }
         
        func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
            for farm in dates{
                if dayView.date.day == farm.day && dayView.date.month == farm.month {
                    if farm.fert && !farm.water{
                        return [UIColor.green]
                    }
                    else if !farm.fert && farm.water{
                        return [UIColor.blue]
                    }
                    else if farm.fert && farm.water{
                        return [UIColor.green, UIColor.blue]
                    }
                    else
                    {
                        return [UIColor.white]
                    }
                }
            }
            return [UIColor.white]
        }
        // set the size of mark
        func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
            return 5
        }
}
extension ActivityViewController{
    @objc fileprivate func buttonClick(sender: UIButton!) {
        self.calendarView.contentController.refreshPresentedMonth()
        sender.isSelected = !sender.isSelected
        if sender.tag == 1{
            if !sender.isSelected{
                sender.backgroundColor = UIColor(red: 200.0/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.9)
                farmDate?.water = false
                print(farmDate!.fert, farmDate!.water, farmDate!.day, farmDate!.month, farmDate!.year)
            }
            else{
                sender.backgroundColor = UIColor(red: 56/255.0, green: 104/255.0, blue: 184/255.0, alpha: 1.0)
                farmDate?.water = true
                print(farmDate!.fert, farmDate!.water, farmDate!.day, farmDate!.month, farmDate!.year)
            }
        }
        else{
            if !sender.isSelected{
                sender.backgroundColor = UIColor(red: 200.0/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.9)
                farmDate?.fert = false
                print(farmDate!.fert, farmDate!.water, farmDate!.day, farmDate!.month, farmDate!.year)
            }
            else{
                sender.backgroundColor = UIColor(red: 125/255.0, green: 201/255.0, blue: 83/255.0, alpha: 1.0)
                farmDate?.fert = true
                print(farmDate!.fert, farmDate!.water, farmDate!.day, farmDate!.month, farmDate!.year)
            }
        }
        self.calendarView.contentController.refreshPresentedMonth()
    }
    
    
}


