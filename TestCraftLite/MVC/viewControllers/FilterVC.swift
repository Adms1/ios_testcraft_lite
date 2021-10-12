//
//  FilterVC.swift
//  TestCraft
//
//  Created by ADMS on 18/06/19.
//  Copyright © 2019 ADMS. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import SwiftyJSON
//import SJSwiftSideMenuController

class FilterVC: UIViewController, ActivityIndicatorPresenter {
    var activityIndicatorView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var imgView = UIImageView()

    @IBOutlet var lblTitle:UILabel!
    
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var tblDashbord:UITableView!
    
    @IBOutlet var SliderView:UIView!
    var MinPrice: Int = 0
    var MaxPrice: Int = 5000
    var curMinPrice: Int = 0
    var curMaxPrice: Int = 5000
    @IBOutlet var lblMin:UILabel!
    @IBOutlet var lblMax:UILabel!
    
    @IBOutlet var imgBoard:UIImageView!
    @IBOutlet var imgExam:UIImageView!
    @IBOutlet var btnApply:UIButton!
    @IBOutlet var btnClearAll:UIButton!
    @IBOutlet var btnClearAll_Down:UIButton!

    var arrCourseTypeFilter = [SubCategory1ListModal]()
    var arrBoardFilter = [SubCategory1ListModal]()
    var arrCompetitiveExamFilter = [SubCategory1ListModal]()
    var arrStandardFilter = [SubCategory1ListModal]()
    var arrSubjectFilter = [SubCategory1ListModal]()
    var arrTutorFilter = [SubCategory1ListModal]()
    //    var arrSubFilterTitle = [SubCategory1ListModal]()
    var strtempCategoryID = ""
    var arrFilterTitle = [String]() // Main Array
    var selectedIndex = 0
    
    var temp_strCategoryID1 = ""
    var temp_strCategoryID2 = ""
    var temp_strCategoryID3 = ""
    var temp_curMinPrice = 0
    var temp_curMaxPrice = 5000
    var temp_strTutorsId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lblTitle.text = "Filter"
        //        arrFilterTitle = ["Course Type", "Boards", "Course", "Standard", "Subjects", "Popular", "Price", "Reviews & Ratings", "Discount", "Promoted"]
        strtempCategoryID = strCategoryID
        btnApply.addShadowWithRadius(0,btnApply.frame.width/9,0,color: UIColor.white)
        btnClearAll_Down.addShadowWithRadius(0,20,0,color: UIColor.white)
        btnClearAll_Down.backgroundColor = GetColor.lightGray
        btnClearAll_Down.setTitleColor(GetColor.whiteColor, for: .normal)
        Get_CourseType_ListApi()
        temp_strCategoryID1 = strCategoryID1
        temp_strCategoryID2 = strCategoryID2
        temp_strCategoryID3 = strCategoryID3
        temp_curMinPrice = curMinPrice
        temp_curMaxPrice = curMaxPrice
        temp_strTutorsId = strTutorsId
        redioCourse(strCategoryID: strtempCategoryID)
        setupSliderView()
        if isFilterApply == ""
        {
            strtempCategoryID = "1"
            ClearFilter()
            redioCourse(strCategoryID: strtempCategoryID)
        }
        btnClearAll.isHidden = true
        btnClearAll_Down.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        lblTitle.text = "" + arrPath.joined(separator:",")
        self.tabBarController?.tabBar.isHidden = true
        api_Activity_Action(Type: "1", gameid: "", gamesessionid: "\(UserDefaults.standard.value(forKey: "TrackTokenID") ?? "")", actionid: "1000", comment: "Filter Screen", isFirstTime: "0")
    }
    
    @IBAction func backTapped(_ sender: AnyObject) {
        //        SJSwiftSideMenuController.toggleLeftSideMenu()
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }

    var strClearAll = ""
    @IBAction func ClearAllClicked(_ sender: AnyObject) {
        selectedIndex = 0
        tblDashbord.isHidden = false
        SliderView.isHidden = true
        ClearFilter()
    }
    
    func ClearFilter() {
        strClearAll = ""
        let strSelectedTemp = "0"

        for var i in (0..<arrBoardFilter.count){arrBoardFilter[i].selected = strSelectedTemp}
        for var i in (0..<arrCompetitiveExamFilter.count){arrCompetitiveExamFilter[i].selected = strSelectedTemp}
        for var i in (0..<arrStandardFilter.count){arrStandardFilter[i].selected = strSelectedTemp}
        for var i in (0..<arrSubjectFilter.count){arrSubjectFilter[i].selected = strSelectedTemp}
        for var i in (0..<arrTutorFilter.count){arrTutorFilter[i].selected = strSelectedTemp}
        //        selectedIndex = 0
        temp_strCategoryID1 = ""
        temp_strCategoryID2 = ""
        temp_strCategoryID3 = ""
        temp_curMinPrice = MinPrice
        temp_curMaxPrice = MaxPrice
        temp_strTutorsId = ""

        lblMin.text = "\(temp_curMinPrice)"
        lblMax.text = "\(temp_curMaxPrice)"

        self.changeSliderValue()
        self.collectionView.reloadData()
        self.tblDashbord.reloadData()
    }
    func Clear_Std() {
        for var i in (0..<arrStandardFilter.count){arrStandardFilter[i].selected = "0"}
        temp_strCategoryID2 = ""
        self.collectionView.reloadData()
        self.tblDashbord.reloadData()
    }
    func Clear_Sub() {
        for var i in (0..<arrSubjectFilter.count){arrSubjectFilter[i].selected = "0"}
        temp_strCategoryID3 = ""
        self.collectionView.reloadData()
        self.tblDashbord.reloadData()
    }
    func Clear_Tutor() {
        for var i in (0..<arrTutorFilter.count){arrTutorFilter[i].selected = "0"}
        temp_strTutorsId = ""
        self.collectionView.reloadData()
        self.tblDashbord.reloadData()
    }

    func redioCourse(strCategoryID: String) {
        selectedIndex = 0
        tblDashbord.isHidden = false
        SliderView.isHidden = true

        if strCategoryID == "1"
        {
            arrFilterTitle = ["Boards", "Standard", "Subjects", "Tutors", "Price"]
            imgBoard.image = UIImage(named: "checked.png")
            imgExam.image = UIImage(named: "unchecked.png")
            Get_Course_ListApi(strCourseTypeId: "1")
            if temp_strCategoryID1 != ""
            {Get_Std_ListApi(strStd: "1", BoardID: temp_strCategoryID1)}
            if temp_strCategoryID1 != "" && temp_strCategoryID2 != ""
            {
                Get_Sub_ListApi(strSub: "2", BoardID: temp_strCategoryID1, StandardID: temp_strCategoryID2)
                apiGet_Tutor_ListApi(Board_Course_ID: temp_strCategoryID1, StandardID: temp_strCategoryID2, SubjectID: temp_strCategoryID3)
            }
            else
            {
                //                Get_Std_ListApi(strStd: "1", BoardID: temp_strCategoryID1)
                //            Get_Sub_ListApi(strSub: "2", BoardID: temp_strCategoryID1, StandardID: temp_strCategoryID2)
                //            apiGet_Tutor_ListApi(Board_Course_ID: temp_strCategoryID1, StandardID: temp_strCategoryID2, SubjectID: temp_strCategoryID3)
            }
            //            apiGet_Tutor_ListApi(Board_Course_ID: temp_strCategoryID1, StandardID: temp_strCategoryID2, SubjectID: temp_strCategoryID3)
        }
        else
        {
            //            arrFilterTitle = ["Course", "Subjects", "Price", "Tutors"] // old
            arrFilterTitle = ["Course", "Tutors", "Price"]
            imgBoard.image = UIImage(named: "unchecked.png")
            imgExam.image = UIImage(named: "checked.png")
            Get_Course_ListApi(strCourseTypeId: "2")
            //            Get_Sub_ListApi(strSub: "2")
            if temp_strCategoryID1 != ""
            {
                apiGet_Tutor_ListApi(Board_Course_ID: temp_strCategoryID1, StandardID: temp_strCategoryID2, SubjectID: temp_strCategoryID3)
            }
        }
        //            else if arrFilterTitle[selectedIndex] == "Boards" {
        //                Get_Course_ListApi(strCourseTypeId: "1")
        //            }
        //            else if arrFilterTitle[selectedIndex] == "Course" {
        //                Get_Course_ListApi(strCourseTypeId: "2")
        //            }
        //            else if arrFilterTitle[selectedIndex] == "Standard" {
        //                Get_Std_ListApi(strStd_Sub: "1")
        //            }
        //            else if arrFilterTitle[selectedIndex] == "Subjects" {
        //                Get_Sub_ListApi(strStd_Sub: "2")
        //            }
        //            else if arrFilterTitle[selectedIndex] == "Tutors"
        //            {
        //                apiGet_Tutor_ListApi()
        //
        //            }

        self.collectionView.reloadData()
        
    }
    @IBAction func BoardsClicked(_ sender: AnyObject) {
        strtempCategoryID = "1"
        ClearFilter()
        redioCourse(strCategoryID: strtempCategoryID)
    }

    @IBAction func ExamClicked(_ sender: AnyObject) {
        strtempCategoryID = "2"
        ClearFilter()
        redioCourse(strCategoryID: strtempCategoryID)
    }

    
    func setupSliderView()
    {
        //        SliderView.addSubview(self.ageLabel)
        //
        //        SliderView.addSubview(self.ageTipsLabel)
        SliderView.addSubview(self.doubleSliderView)
        
        //        self.ageLabel.centerY = 156
        //        self.ageLabel.x = 52
        //
        //        self.ageTipsLabel.centerY = self.ageLabel.centerY
        //        self.ageTipsLabel.x = self.ageLabel.right + 7
        //        if ((UserDefaults.standard.value(forKey: "filter_price")) != nil)
        //        {
        //            let dic_filter_price = UserDefaults.standard.value(forKey: "filter_price")! as! NSDictionary
        //            //Bhargav Hide
        ////print("dic_filter_price__:",dic_filter_price)
        self.temp_curMinPrice = Int("\(strMinPrice)") ?? 0
        self.temp_curMaxPrice = Int("\(strMaxPrice)") ?? 0
        //        }
        //        else
        //        {
        ////            self.curMinPrice = Int("0") ?? 0
        ////            self.curMaxPrice = Int("5000") ?? 0
        //        }

        self.doubleSliderView.x = 10
        self.doubleSliderView.y = self.lblMax.bounds.origin.y + self.lblMax.bounds.size.height + 30
        //        self.doubleSliderView.maxTintColor = GetColor.themeBlueColor
        //        self.doubleSliderView.minTintColor = GetColor.themeBlueColor
        self.doubleSliderView.tintColorDidChange()
        lblMin.text = "\(temp_curMinPrice)"
        lblMax.text = "\(temp_curMaxPrice)"
        SliderView.isHidden = true
        self.changeSliderValue()

    }
    //MARK: - private func
    
    private func fetchInt(from value: CGFloat) -> CGFloat {
        var newValue: CGFloat = floor(value)
        let changeValue = value - newValue
        if changeValue >= 0.5 {
            newValue = newValue + 1
        }
        return newValue
    }
    
    private func sliderValueChangeAction(isLeft: Bool, finish: Bool) {
        if isLeft {
            let age = CGFloat(self.MaxPrice - self.MinPrice) * self.doubleSliderView.curMinValue
            let tmpAge = self.fetchInt(from: age)
            self.temp_curMinPrice = Int(tmpAge) + self.MinPrice
            self.changeAgeTipsText()
        }else {
            let age = CGFloat(self.MaxPrice - self.MinPrice) * self.doubleSliderView.curMaxValue
            let tmpAge = self.fetchInt(from: age)
            self.temp_curMaxPrice = Int(tmpAge) + self.MinPrice
            self.changeAgeTipsText()
        }
        if finish {
            self.changeSliderValue()
        }
    }
    
    private func changeSliderValue() {
        let finishMinValue = CGFloat(self.temp_curMinPrice - self.MinPrice)/CGFloat(self.MaxPrice - self.MinPrice)
        let finishMaxValue = CGFloat(self.temp_curMaxPrice - self.MinPrice)/CGFloat(self.MaxPrice - self.MinPrice)
        self.doubleSliderView.curMinValue = finishMinValue
        self.doubleSliderView.curMaxValue = finishMaxValue
        
        
        //        self.temp_curMinPrice = self.curMinPrice
        //        self.temp_curMaxPrice = self.curMaxPrice

        
        
        self.doubleSliderView.changeLocationFromValue()
    }
    
    private func changeAgeTipsText() {
        if self.temp_curMinPrice == self.temp_curMaxPrice {
            self.lblMin.text = "\(self.temp_curMinPrice)"
        }else {
            // self.ageTipsLabel.text = "\(self.curMinPrice)~\(self.curMaxPrice)岁"
            self.lblMin.text = "\(self.temp_curMinPrice)"
            self.lblMax.text = "\(self.temp_curMaxPrice)"
            
            
        }
        //        self.ageTipsLabel.sizeToFit()
        //        self.ageTipsLabel.centerY = self.ageLabel.centerY
        //        self.ageTipsLabel.x = self.ageLabel.right + 7
    }
    
    //MARK:- setter & getter
    
    //    private lazy var ageLabel: UILabel = {
    //        let label = UILabel.init()
    //        label.textColor = UIColor.black
    //        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    //        label.text = "年龄 age"
    //        label.sizeToFit()
    //        return label
    //    }()
    //
    //    private lazy var ageTipsLabel: UILabel = {
    //        let label = UILabel.init()
    //        label.textColor = UIColor.black
    //        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    //        label.text = "\(self.MinPrice)           \(self.MaxPrice)"
    //        label.sizeToFit()
    //        return label
    //    }()
    
    private lazy var doubleSliderView: DoubleSliderView = {
        let view = DoubleSliderView.init(frame: CGRect.init(x: 10, y: 0, width: self.view.width - 60 * 2, height: 35 + 20))
        view.needAnimation = true
        if self.MaxPrice > self.MinPrice {
            view.minInterval = 1.0/CGFloat(self.MaxPrice - self.MinPrice)
        }
        view.midTintColor = GetColor.lightGray
        view.sliderBtnLocationChangeBlock = { [weak self] isLeft,finish in
            self?.sliderValueChangeAction(isLeft: isLeft, finish: finish)
        }
        return view
    }()
    
    @IBAction func ApplyClicked(_ sender: AnyObject) {
        //        //Bhargav Hide
        ////print(self.arrHeaderSubTitle)
        var arrData0 = [String]()
        var arrData1 = [String]()
        var arrData2 = [String]()
        var arrData3 = [String]()
        
        var arrDataTitle0 = [String]()
        var arrDataTitle1 = [String]()
        var arrDataTitle2 = [String]()
        var arrDataTitle3 = [String]()
        arrPath.removeAll()
        if strtempCategoryID == "1"
        {
            for value in arrBoardFilter{if value.selected == "1" { arrData0.append(value.id ?? "")
                arrPath.append(value.title ?? ""); arrDataTitle0.append(value.title ?? "")}}
            if (arrStandardFilter.count > 1)
            {for value in arrStandardFilter{if value.selected == "1" { arrData1.append(value.id ?? "")
                arrPath.append(value.title ?? ""); arrDataTitle1.append(value.title ?? "")}}}
            if (arrSubjectFilter.count > 2)
            {for value in arrSubjectFilter{if value.selected == "1" { arrData2.append(value.id ?? "")
                arrPath.append(value.title ?? ""); arrDataTitle2.append(value.title ?? "")}}}
        }
        else
        {
            for value in arrCompetitiveExamFilter{if value.selected == "1" { arrData0.append(value.id ?? "")
                arrPath.append(value.title ?? ""); arrDataTitle0.append(value.title ?? "")}}
            //            if arrSubjectFilter.count > 1 {for value in arrSubjectFilter {if value.selected == "1" { arrData2.append(value.id ?? ""); arrPath.append(value.title ?? ""); arrDataTitle2.append(value.title ?? "")}}}
        }
        for value in arrTutorFilter{if value.selected == "1" { arrData3.append(value.id ?? "");arrPath.append(value.title ?? ""); arrDataTitle3.append(value.title ?? "")}}
        //        let dictPrice:[String:Any] = ["minPrice":"\(lblMin.text ?? "")", "maxPrice":"\(lblMax.text ?? "")"]
        //        UserDefaults.standard.set(dictPrice, forKey: "filter_price")
        strMinPrice = "\(temp_curMinPrice)"
        strMaxPrice = "\(temp_curMaxPrice)"
        
        //        lblMin.text = "\(curMinPrice)"
        //        lblMax.text = "\(curMaxPrice)"
        
        //        if arrData0.count == 0
        //        {
        //            if strtempCategoryID == "1"
        //            {
        //                self.view.makeToast("Please Select Board.", duration: 2.0, position: .bottom)
        //            }
        //            else
        //            {
        //                self.view.makeToast("Please Select strCategoryTitle.", duration: 2.0, position: .bottom)
        //            }
        //
        //            return
        //        }
        //        if strtempCategoryID == "1"
        //        {
        //            if arrData1.count == 0
        //            {
        //                self.view.makeToast("Please Select Standard.", duration: 2.0, position: .bottom)
        //                return
        //            }
        //        }
        //        if arrData2.count == 0
        //        {
        //            self.view.makeToast("Please Select Subject.", duration: 2.0, position: .bottom)
        //            return
        //        }
        //        else
        //        {
        //            arrPath.removeAll()
        //            arrPath.app
        var type_exam = "Course"
        if strtempCategoryID == "1"
        {
            type_exam = "Board"
        }

        if arrData0.count == 0
        {self.view.makeToast("Please Select \(type_exam)", duration: 3.0, position: .bottom)}
        else if arrData1.count == 0 && strtempCategoryID == "1"
        {self.view.makeToast("Please Select Standard", duration: 3.0, position: .bottom)}
        else
        {
            if strtempCategoryID == "1" //Bord
            {
                //                if(arrData0.count>0){strCategoryID1 = arrData0.joined(separator:",")}//Board
                if(arrData0.count>0){strCategoryID1 = arrData0.joined(separator:",")}else{strCategoryID1 = ""}//Board
                if(arrData1.count>0){strCategoryID2 = arrData1.joined(separator:",")}else{strCategoryID2 = ""}//Standard
                if(arrData2.count>0){strCategoryID3 = arrData2.joined(separator:",")}else{strCategoryID3 = ""}//Subject
                if(arrDataTitle0.count>0){strCategoryTitle1 = arrDataTitle0.joined(separator:", ")}else{strCategoryTitle1 = ""}//Board
                if(arrDataTitle1.count>0){strCategoryTitle2 = arrDataTitle1.joined(separator:", ")}else{strCategoryTitle2 = ""}//Standard
                if(arrDataTitle2.count>0){strCategoryTitle3 = arrDataTitle2.joined(separator:", ")}else{strCategoryTitle3 = ""}//Subject
            }
            else
            {
                if(arrData0.count>0){strCategoryID1 = arrData0.joined(separator:",")}else{strCategoryID1 = ""}//Exam
                //                strCategoryID2 = ""//Standard
                //                if(arrData2.count>0){strCategoryID3 = arrData2.joined(separator:",")}else{strCategoryID3 = ""}//Subject
                if(arrDataTitle0.count>0){strCategoryTitle1 = arrDataTitle0.joined(separator:", ")}else{strCategoryTitle1 = ""}//Exam
                //                strCategoryTitle2 = ""//Standard
                //                if(arrDataTitle2.count>0){strCategoryTitle3 = arrDataTitle2.joined(separator:", ")}else{strCategoryTitle3 = ""}//Subject
            }
            if(arrData3.count>0){strTutorsId = arrData3.joined(separator:",")}else{strTutorsId = ""}//Tutors
            if(arrDataTitle3.count>0){strTutorsTitle = arrDataTitle3.joined(separator:", ")}else{strTutorsTitle = ""}//Tutors
            
            //            strTutorsId = ""
            //            strTutorsTitle = ""
            self.view.makeToast("Filter update successfully", duration: 2.0, position: .bottom)
            //            "\(self.curMinPrice)"
            //            "\(self.curMaxPrice)"
            strCategoryID = strtempCategoryID
            //            let dict:[String:Any] = ["CategoryID":strCategoryID, "CategoryID1":strCategoryID1, "CategoryID2":strCategoryID2, "CategoryID3":strCategoryID3, "CategoryTitle":strCategoryTitle, "CategoryTitle1":strCategoryTitle1, "CategoryTitle2":strCategoryTitle2, "CategoryTitle3":strCategoryTitle3, "TutorID":strTutorsId,"TutorTitle":strTutorsTitle , "arrPath":arrPath] // arrDataTitle0
            //            //Bhargav Hide
            ////print("exam_preferences____________________________________: \n",dict)
            //                        UserDefaults.standard.set(dict, forKey: "exam_preferences")
            isFilterApply = "1"

            UserDefaults.standard.set(true, forKey: "isFilterApply")
            //            strPackageType = "-1"
            self.navigationController?.popViewController(animated: true)
        }
    }
}
var isFilterApply = ""
extension FilterVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    // MARK: - UICollectionViewDataSource protocol
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width/1.6);
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFilterTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.displayData("Main",arrFilterTitle[indexPath.row])
        var strSelectedImg = ""
        cell.imgIcon.addShadowWithRadius(0,cell.imgIcon.frame.width/2,0,color: UIColor.white)
        if selectedIndex == indexPath.row
        {
            cell.bgView.backgroundColor = GetColor.themeBlueColor
            cell.lblTitle.textColor = UIColor.white
            strSelectedImg = "white-dot.png"

            //            let image : UIImage = UIImage(named:"true-sign-icon-blue")!
            //            cell.imgIcon.image = image
            //            cell.imgIcon.tintColor = UIColor.lightGray
            //            userHeader.imgDerctionIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        }
        else
        {
            cell.bgView.backgroundColor = UIColor.clear
            cell.lblTitle.textColor = UIColor(rgb: 0x838283)
            strSelectedImg = "blue-dot.png"

            //            let image : UIImage = UIImage(named:"true-sign-icon-blue")!
            //            cell.imgIcon.image = image//UIImageView(image: <#T##UIImage?#>)
            //                self.DashButton.imageView.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
            
        }
        cell.imgIcon.image = UIImage(named: "")
        //["Boards", "Standard", "Subjects", "Price", "Tutors"]...["Course", "Subjects", "Price", "Tutors"]
        if strtempCategoryID == "1"
        {
            if arrFilterTitle[indexPath.row] == "Boards" && temp_strCategoryID1 != ""{cell.imgIcon.image = UIImage(named: strSelectedImg)}
        }else
        {
            if arrFilterTitle[indexPath.row] == "Course" && temp_strCategoryID1 != ""{cell.imgIcon.image = UIImage(named: strSelectedImg)}
        }
        if arrFilterTitle[indexPath.row] == "Standard" && temp_strCategoryID2 != ""{cell.imgIcon.image = UIImage(named: strSelectedImg)}
        if arrFilterTitle[indexPath.row] == "Subjects" && temp_strCategoryID3 != ""{cell.imgIcon.image = UIImage(named: strSelectedImg)}
        if arrFilterTitle[indexPath.row] == "Price" && (temp_curMinPrice != MinPrice || temp_curMaxPrice != MaxPrice){cell.imgIcon.image = UIImage(named: strSelectedImg)}
        if arrFilterTitle[indexPath.row] == "Tutors" && temp_strTutorsId != ""{cell.imgIcon.image = UIImage(named: strSelectedImg)}

        //        if strtempCategoryID == "1" //Exam
        //        {
        //            //                if(arrData0.count>0){strCategoryID1 = arrData0.joined(separator:",")}//Board
        //            if(arrData0.count>0){strCategoryID1 = arrData0.joined(separator:",")}else{strCategoryID1 = ""}//Board
        //            if(arrData1.count>0){strCategoryID2 = arrData1.joined(separator:",")}else{strCategoryID2 = ""}//Standard
        //            if(arrData2.count>0){strCategoryID3 = arrData2.joined(separator:",")}else{strCategoryID3 = ""}//Subject
        //            if(arrDataTitle0.count>0){strCategoryTitle1 = arrDataTitle0.joined(separator:", ")}else{strCategoryTitle1 = ""}//Board
        //            if(arrDataTitle1.count>0){strCategoryTitle2 = arrDataTitle1.joined(separator:", ")}else{strCategoryTitle2 = ""}//Standard
        //            if(arrDataTitle2.count>0){strCategoryTitle3 = arrDataTitle2.joined(separator:", ")}else{strCategoryTitle3 = ""}//Subject
        //        }
        //        else
        //        {
        //            if(arrData0.count>0){strCategoryID1 = arrData0.joined(separator:",")}else{strCategoryID1 = ""}//Exam
        //            strCategoryID2 = ""//Standard
        //            if(arrData2.count>0){strCategoryID3 = arrData2.joined(separator:",")}else{strCategoryID3 = ""}//Subject
        //            if(arrDataTitle0.count>0){strCategoryTitle1 = arrDataTitle0.joined(separator:", ")}else{strCategoryTitle1 = ""}//Board
        //            strCategoryTitle2 = ""//Standard
        //            if(arrDataTitle2.count>0){strCategoryTitle3 = arrDataTitle2.joined(separator:", ")}else{strCategoryTitle3 = ""}//Subject
        //        }

        //        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(expandCollapseSection(_:)))
        //        cell.contentView.tag = indexPath.section
        //        cell.contentView.addGestureRecognizer(tapGesture)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedIndex = indexPath.item
        criteria_update()
        if arrFilterTitle[indexPath.row] == "Price"
        {
            tblDashbord.isHidden = true
            SliderView.isHidden = false
        }
        else
        {
            tblDashbord.isHidden = false
            SliderView.isHidden = true
            var type_exam = "Course"
            if strtempCategoryID == "1"
            {
                type_exam = "Board"
            }
            if arrFilterTitle[selectedIndex] == "Course Type" {
                //                Get_CourseType_ListApi()
                //                if strtempCategoryID == "1"
                //                {
                //                    strtempCategoryID = "2"
                //                    arrFilterTitle = ["Boards", "Standard", "Subjects", "Price", "Tutors"]
                //                }
                //                else
                //                {
                //                    strtempCategoryID = "1"
                //                    arrFilterTitle = ["Course", "Subjects", "Price", "Tutors"]
                //                }

            }
            else if arrFilterTitle[selectedIndex] == "Boards" {
                //                Get_Course_ListApi(strCourseTypeId: "1")
                tblDashbord.reloadData()
            }
            else if arrFilterTitle[selectedIndex] == "Course" {
                //                Get_Course_ListApi(strCourseTypeId: "2")
                tblDashbord.reloadData()
            }
            else if arrFilterTitle[selectedIndex] == "Standard" {
                arrStandardFilter.removeAll()
                //                var arrData1 = [String]()
                //                var arrDataTitle1 = [String]()
                //                if (arrStandardFilter.count > 1)
                //                {for value in arrStandardFilter{if value.selected == "1" { arrData1.append(value.id ?? "")
                //                    arrDataTitle1.append(value.title ?? "")}}}
                ////                var temp_strCategoryID2 = ""
                //                if(arrData1.count>0){temp_strCategoryID2 = arrData1.joined(separator:",")}else{temp_strCategoryID2 = ""}//Standard
                if temp_strCategoryID1 == ""
                {self.view.makeToast("Please Select Board", duration: 3.0, position: .bottom)}
                else{ Get_Std_ListApi(strStd: "1", BoardID: temp_strCategoryID1)}
            }
            else if arrFilterTitle[selectedIndex] == "Subjects" {
                arrSubjectFilter.removeAll()
                if temp_strCategoryID1 == ""
                {self.view.makeToast("Please Select \(type_exam)", duration: 3.0, position: .bottom)}
                else if temp_strCategoryID2 == ""
                {self.view.makeToast("Please Select Standard", duration: 3.0, position: .bottom)}
                else
                {
                    
                    Get_Sub_ListApi(strSub: "2", BoardID: temp_strCategoryID1, StandardID: temp_strCategoryID2)
                }
            }
            else if arrFilterTitle[selectedIndex] == "Tutors"
            {
                arrTutorFilter.removeAll()

                if temp_strCategoryID1 == ""
                {self.view.makeToast("Please Select \(type_exam)", duration: 3.0, position: .bottom)}
                else //if temp_strCategoryID2 == ""
                    //                {self.view.makeToast("Please Select Standard", duration: 3.0, position: .bottom)}
                    //                else
                {
                    apiGet_Tutor_ListApi(Board_Course_ID: temp_strCategoryID1, StandardID: temp_strCategoryID2, SubjectID: temp_strCategoryID3)
                }
            }
            
        }
        tblDashbord.reloadData()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        //        let animation = CABasicAnimation(keyPath: "cornerRadius")
        //        animation.fromValue = cell.frame.size.width
        //        cell.layer.cornerRadius = 0
        //        animation.toValue = 0
        //        animation.duration = 1
        //        cell.layer.add(animation, forKey: animation.keyPath)
        
    }
    
    
    func criteria_update() {
        var arrData0 = [String]()
        var arrDataTitle0 = [String]()
        //  var temp_strCategoryID1 = ""
        if strtempCategoryID == "1"
        {
            if (arrBoardFilter.count > 0)
            {for value in arrBoardFilter{if value.selected == "1" { arrData0.append(value.id ?? "")
                arrDataTitle0.append(value.title ?? "")}}}
            if(arrData0.count>0){temp_strCategoryID1 = arrData0.joined(separator:",")}else{temp_strCategoryID1 = ""}//Board
        }
        else
        {
            if (arrCompetitiveExamFilter.count > 0)
            {for value in arrCompetitiveExamFilter{if value.selected == "1" { arrData0.append(value.id ?? "")
                arrDataTitle0.append(value.title ?? "")}}}
            if(arrData0.count>0){temp_strCategoryID1 = arrData0.joined(separator:",")}else{temp_strCategoryID1 = ""}//Course
            
        }
        
        var arrData1 = [String]()
        var arrDataTitle1 = [String]()
        if (arrStandardFilter.count > 0)
        {for value in arrStandardFilter{if value.selected == "1" { arrData1.append(value.id ?? "")
            arrDataTitle1.append(value.title ?? "")}}}
        //                var temp_strCategoryID2 = ""
        if(arrData1.count>0){temp_strCategoryID2 = arrData1.joined(separator:",")}else{temp_strCategoryID2 = ""}//Standard
        
        var arrData2 = [String]()
        var arrDataTitle2 = [String]()
        if (arrSubjectFilter.count > 0)
        {for value in arrSubjectFilter{if value.selected == "1" { arrData2.append(value.id ?? "")
            arrDataTitle2.append(value.title ?? "")}}}
        if(arrData2.count>0){temp_strCategoryID3 = arrData2.joined(separator:",")}else{temp_strCategoryID3 = ""}//Subject
        
        var arrData3 = [String]()
        var arrDataTitle3 = [String]()
        if (arrTutorFilter.count > 0)
        {for value in arrTutorFilter{if value.selected == "1" { arrData3.append(value.id ?? "");arrPath.append(value.title ?? ""); arrDataTitle3.append(value.title ?? "")}}}
        if(arrData3.count>0){temp_strTutorsId = arrData3.joined(separator:",")}else{temp_strTutorsId = ""}//Tutors

    }
}
extension FilterVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return 5//arrSubFilterTitle.count
        if arrFilterTitle[selectedIndex] == "Course Type" {
            return arrCourseTypeFilter.count
        }
        else if arrFilterTitle[selectedIndex] == "Boards" {
            return arrBoardFilter.count
        }
        else if arrFilterTitle[selectedIndex] == "Course" {
            return arrCompetitiveExamFilter.count
        }
        else if arrFilterTitle[selectedIndex] == "Standard" {
            return arrStandardFilter.count
        }
        else if arrFilterTitle[selectedIndex] == "Subjects" {
            return arrSubjectFilter.count
        }
        else if arrFilterTitle[selectedIndex] == "Tutors" {
            return arrTutorFilter.count
        }
        return 5
    }
    //My heightForRowAtIndexPath method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60//UITableView.automaticDimension//indexPath.section == selectedIndex ? UITableViewAutomaticDimension : 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "DashBordTableViewCell"
        var cell: DashBordTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? DashBordTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "DashBordTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? DashBordTableViewCell
        }
        //        cell.lblTitle.text = "test"//arrSubFilterTitle[indexPath.row].title ?? ""

        var tempSelected = ""
        if arrFilterTitle[selectedIndex] == "Course Type" {
            cell.lblTitle.text =  arrCourseTypeFilter[indexPath.row].title ?? ""
            tempSelected =  arrCourseTypeFilter[indexPath.row].selected ?? ""
        }
        else if arrFilterTitle[selectedIndex] == "Boards" {
            cell.lblTitle.text =  arrBoardFilter[indexPath.row].title ?? ""
            tempSelected =  arrBoardFilter[indexPath.row].selected ?? ""
        }
        else if arrFilterTitle[selectedIndex] == "Course" {
            cell.lblTitle.text =  arrCompetitiveExamFilter[indexPath.row].title ?? ""
            tempSelected =  arrCompetitiveExamFilter[indexPath.row].selected ?? ""
        }
        else if arrFilterTitle[selectedIndex] == "Standard" {
            cell.lblTitle.text =  arrStandardFilter[indexPath.row].title ?? ""
            tempSelected =  arrStandardFilter[indexPath.row].selected ?? ""
        }
        else if arrFilterTitle[selectedIndex] == "Subjects" {
            cell.lblTitle.text =  arrSubjectFilter[indexPath.row].title ?? ""
            tempSelected =  arrSubjectFilter[indexPath.row].selected ?? ""
        }
        else if arrFilterTitle[selectedIndex] == "Tutors" {
            cell.lblTitle.text =  arrTutorFilter[indexPath.row].title ?? ""
            tempSelected =  arrTutorFilter[indexPath.row].selected ?? ""
        }

        else
        {
            cell.lblTitle.text =  "test"
            tempSelected =  "0"
        }
        
        //Bhargav Hide
        ////print(tempSelected,indexPath.row)
        //        cell.imgIcon.tintColor = UIColor.clear
        //        cell.imgIcon.backgroundColor = UIColor.clear

        if arrFilterTitle[selectedIndex] == "Standard" || arrFilterTitle[selectedIndex] == "Boards" || arrFilterTitle[selectedIndex] == "Course"
        {
            if tempSelected == "1"
            {
                //                let image : UIImage = UIImage(named:"blue-circle")!
                cell.imgIcon.image = nil //image
                //                cell.imgIcon.tintColor = UIColor.lightGray
                cell.imgIcon.backgroundColor = GetColor.themeBlueColor
                cell.imgIcon.addShadowWithRadius(2,cell.imgIcon.frame.width/2,1.1,color: UIColor.lightGray)

                //            cell.imgIcon.tintColor = UIColor.lightGray
                //                userHeader.imgDerctionIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            }
            else
            {
                //                let image : UIImage = UIImage(named:"true-sign-icon-white_NEW")!
                cell.imgIcon.image = nil
                cell.imgIcon.tintColor = UIColor.lightGray
                cell.imgIcon.backgroundColor = UIColor.white
                //                self.DashButton.imageView.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
                cell.imgIcon.addShadowWithRadius(2,cell.imgIcon.frame.width/2,1.1,color: UIColor.lightGray)

            }
        }
        else
        {
            if tempSelected == "1"
            {
                let image : UIImage = UIImage(named:"true-sign-icon-white_NEW")!
                cell.imgIcon.image = image
                cell.imgIcon.backgroundColor = GetColor.themeBlueColor
                cell.imgIcon.addShadowWithRadius(2,3,1.1,color: UIColor.lightGray)
                
                //            cell.imgIcon.tintColor = UIColor.lightGray
                //                userHeader.imgDerctionIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
                
            }
            else
            {
                let image : UIImage = UIImage(named:"true-sign-icon-black")!
                cell.imgIcon.tintColor = UIColor.lightGray
                cell.imgIcon.image = nil//image//UIImageView(image: <#T##UIImage?#>)
                cell.imgIcon.backgroundColor = UIColor.white
                //                self.DashButton.imageView.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
                cell.imgIcon.addShadowWithRadius(2,3,1.1,color: UIColor.lightGray)
                
            }
        }
        //        cell.topbgView1.addShadowWithRadius(2,10,1,color: UIColor.lightGray)
        //        cell.topbgView1.backgroundColor = UIColor(rgb: 0xF8FCFF)
        //        cell.imgBackGround.image = UIImage(named: arrDashbord_img[indexPath.row])
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubCategory3VC") as? SubCategory3VC
        //        ////        vc!.arrPackageDetail = [self.arrHeaderSub3Title[indexPath.row]]
        //        //        //        strCategoryID2 = arrHeaderSub1Title[indexPath.item].id ?? ""
        //        //        //        strCategoryTitle2 = arrHeaderSub1Title[indexPath.item].title ?? ""
        //        //        //        arrPath.append(arrHeaderSub1Title[indexPath.item].title ?? "")
        //        //
        //        vc!.strDisplayPackages = "\(indexPath.row)"
        //        self.navigationController?.pushViewController(vc!, animated: true)
        // arrCourseTypeFilter , arrBoardFilter , arrCompetitiveExamFilter , arrStandardFilter , arrSubjectFilter

        if arrFilterTitle[selectedIndex] == "Course Type"
        {
            if arrCourseTypeFilter[indexPath.row].selected == "1"
            {arrCourseTypeFilter[indexPath.row].selected = "0"}else{arrCourseTypeFilter[indexPath.row].selected = "1"}
        }
        else if arrFilterTitle[selectedIndex] == "Boards"
            //        {
            //            if arrBoardFilter[indexPath.row].selected == "1"
            //            {arrBoardFilter[indexPath.row].selected = "0"}else{arrBoardFilter[indexPath.row].selected = "1"}
            //        }
        {
            var oldvalue = -1//arrQueAns[strSelectedIndex].que_ans[indexPath.row].selected
            for var i in (0..<arrBoardFilter.count)
            {
                if arrBoardFilter[i].selected == "1"
                {
                    arrBoardFilter[i].selected = "0"
                    oldvalue = i
                }
                else
                {
                    arrBoardFilter[i].selected = "0"
                }
                i += 1
            }
            
            if oldvalue == -1
            {
                collectionView.reloadData()
                arrBoardFilter[indexPath.row].selected = "1"
            }
            else{
                arrBoardFilter[indexPath.row].selected = "1"
            }
            Clear_Std()
            Clear_Sub()
            Clear_Tutor()
        }
        else if arrFilterTitle[selectedIndex] == "Course"
            //        {
            //            if arrCompetitiveExamFilter[indexPath.row].selected == "1"
            //            {arrCompetitiveExamFilter[indexPath.row].selected = "0"}else{arrCompetitiveExamFilter[indexPath.row].selected = "1"}
            //        }
        {
            var oldvalue = -1//arrQueAns[strSelectedIndex].que_ans[indexPath.row].selected
            for var i in (0..<arrCompetitiveExamFilter.count)
            {
                if arrCompetitiveExamFilter[i].selected == "1"
                {
                    arrCompetitiveExamFilter[i].selected = "0"
                    oldvalue = i
                }
                else
                {
                    arrCompetitiveExamFilter[i].selected = "0"
                }
                i += 1
            }
            
            if oldvalue == -1
            {
                collectionView.reloadData()
                arrCompetitiveExamFilter[indexPath.row].selected = "1"
            }
            else{
                arrCompetitiveExamFilter[indexPath.row].selected = "1"
            }
            Clear_Tutor()

        }
        else if arrFilterTitle[selectedIndex] == "Standard"
        {
            var oldvalue = -1//arrQueAns[strSelectedIndex].que_ans[indexPath.row].selected
            for var i in (0..<arrStandardFilter.count)
            {
                if arrStandardFilter[i].selected == "1"
                {
                    arrStandardFilter[i].selected = "0"
                    oldvalue = i
                }
                else
                {
                    arrStandardFilter[i].selected = "0"
                }
                i += 1
            }
            
            
            //            strCategoryID1 = arrHeaderSubTitle[indexPath.section].arrType[indexPath.row].id ?? ""
            //            strCategoryTitle1 = arrHeaderSubTitle[indexPath.section].arrType[indexPath.row].title ?? ""
            //            if self.arrStandardFilter.count == 3
            //            {
            //                self.arrStandardFilter.remove(at: indexPath.section + 2)
            //            }
            //            if self.arrStandardFilter.count == 2
            //            {
            //                self.arrStandardFilter.remove(at: indexPath.section + 1)
            //            }
            //            if oldvalue == -1
            //            {
            //            }
            //            else{
            if oldvalue == -1
            {
                //                arrHeaderSubTitle[indexPath.section].arrType[oldvalue].selected = "0"
                collectionView.reloadData()
                arrStandardFilter[indexPath.row].selected = "1"
            }
            else{
                arrStandardFilter[indexPath.row].selected = "1"
                //                apiGet_Course_Sub_ListApi()
            }
            Clear_Sub()
            Clear_Tutor()
        }
            //        {
            ////            if arrStandardFilter[indexPath.row].selected == "1"
            ////            {arrStandardFilter[indexPath.row].selected = "0"}else{arrStandardFilter[indexPath.row].selected = "1"}
            //            for var i in (0..<arrFilterTitle.count)
            //            {
            //                arrStandardFilter[i].selected = "0"
            ////                if arrStandardFilter[i].selected == "1"
            ////                {arrStandardFilter[i].selected = "0"}else{arrStandardFilter[i].selected = "0"}
            //                i += 1
            //            }
            //            arrStandardFilter[indexPath.row].selected = "1"
            //        }
        else if arrFilterTitle[selectedIndex] == "Subjects" {
            if arrSubjectFilter[indexPath.row].selected == "1"
            {arrSubjectFilter[indexPath.row].selected = "0"}else{arrSubjectFilter[indexPath.row].selected = "1"}
        }
        else if arrFilterTitle[selectedIndex] == "Tutors" {
            if arrTutorFilter[indexPath.row].selected == "1"
            {arrTutorFilter[indexPath.row].selected = "0"}else{arrTutorFilter[indexPath.row].selected = "1"}
        }
        else
        {
        }
        tblDashbord.reloadData()
    }
}

extension FilterVC
{
    func Get_CourseType_ListApi()
    {
        showActivityIndicator()
        self.arrCourseTypeFilter.removeAll()
        let params = ["":""]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        //Bhargav Hide
        print("API, Params: \n",API.Get_CourseType_ListApi,params)
                       if !Connectivity.isConnectedToInternet() {
                    self.AlertPopupInternet()

                           // show Alert
                           self.hideActivityIndicator()
                           print("The network is not reachable")
                           self.tblDashbord.reloadData()
                           // self.view.makeToast("The network is not reachable", duration: 3.0, position: .bottom)
                           return
                       }

        Alamofire.request(API.Get_CourseType_ListApi, method: .post, parameters: params, headers: headers).validate().responseJSON { response in
            self.hideActivityIndicator()
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                //Bhargav Hide
                ////print("a",json)

                if(json["Status"] == "true" || json["Status"] == "1") {
                    let arrData = json["data"].array
                    for value in arrData! {
                        var preSelectedValues = [String]()
                        preSelectedValues = self.strtempCategoryID.components(separatedBy: ",")
                        let filtered = preSelectedValues.filter { $0 == "\(value["CourseTypeID"].stringValue)" }
                        var strSelectedTemp = "0"
                        if filtered.count > 0{strSelectedTemp = "1"}
                        
                        let TempModel:SubCategory1ListModal = SubCategory1ListModal.init(id: "\(value["CourseTypeID"].stringValue)", title: "\(value["CourseTypeName"].stringValue)", subTitle: "", image: "\(API.imageUrl)\(value["Icon"].stringValue)", selected: strSelectedTemp)
                        
                        self.arrCourseTypeFilter.append(TempModel)
                    }
                    self.collectionView.reloadData()
                }
                else
                {
                    //                    self.view.makeToast("Data not available.", duration: 3.0, position: .bottom)
                }
            case .failure(let error):
                self.view.makeToast("Somthing wrong...", duration: 3.0, position: .bottom)
                
            }
            self.tblDashbord.reloadData()
        }

    }
    
    func Get_Course_ListApi(strCourseTypeId: String)
    {
        let params = ["CourseTypeID":strCourseTypeId]
        
        var strSet_Title = ""
        if strCourseTypeId == "1"
        {
            self.arrBoardFilter.removeAll()
            strSet_Title = "Step 1 - Select Board"
        }
        else
        {
            self.arrCompetitiveExamFilter.removeAll()
            strSet_Title = "Step 1 - Select Course"//\(strCategoryTitle)"
        }
        self.tblDashbord.reloadData()
        showActivityIndicator()

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        //Bhargav Hide
        print("API, Params: \n",API.Get_Course_ListApi,params)
                       if !Connectivity.isConnectedToInternet() {
                    self.AlertPopupInternet()

                           // show Alert
                           self.hideActivityIndicator()
                           print("The network is not reachable")
                           self.tblDashbord.reloadData()
                        // self.view.makeToast("The network is not reachable", duration: 3.0, position: .bottom)
                           return
                       }

        Alamofire.request(API.Get_Course_ListApi, method: .post, parameters: params, headers: headers).validate().responseJSON { response in
            self.hideActivityIndicator()
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                //Bhargav Hide
                ////print("b",json)
                
                if(json["Status"] == "true" || json["Status"] == "1") {
                    let arrData = json["data"].array
                    if strCourseTypeId == "1"
                    {
                        self.arrBoardFilter.removeAll()
                    }
                    else
                    {
                        self.arrCompetitiveExamFilter.removeAll()
                    }

                    
                    for value in arrData! {
                        var preSelectedValues = [String]()
                        //                        //Bhargav Hide
                        ////print(strCategoryTitle1)
                        preSelectedValues = self.temp_strCategoryID1.components(separatedBy: ",")
                        let filtered = preSelectedValues.filter { $0 == "\(value["CourseID"].stringValue)" }
                        var strSelectedTemp = "0"
                        if filtered.count > 0{if self.strClearAll == "" {strSelectedTemp = "1"}}
                        
                        let TempModel:SubCategory1ListModal = SubCategory1ListModal.init(id: "\(value["CourseID"].stringValue)", title: "\(value["CourseName"].stringValue)", subTitle: "", image: "\(API.imageUrl)\(value["Icon"].stringValue)", selected: strSelectedTemp)
                        
                        if strCourseTypeId == "1" {
                            self.arrBoardFilter.append(TempModel)
                        }else
                        {self.arrCompetitiveExamFilter.append(TempModel)}

                    }
                    //                    let PerentModel:YourPreferencesModal = YourPreferencesModal.init(id: "", Headertitle: strSet_Title, subTitle: "", image: "", selected: "1", arrType: arrChild)
                    
                    //                    if strCourseTypeId == "1" {
                    //                        self.Get_Std_ListApi(strStd: "1")
                    //                    }else{}
                    


                    //                    self.arrHeaderSubTitle[0].selected = "0"
                    
                    //                    self.collectionView.reloadData()
                }
                else
                {
                    //                    self.view.makeToast("\(json["Msg"].stringValue)", duration: 3.0, position: .bottom)
                }
            case .failure(let error):
                self.view.makeToast("Somthing wrong...", duration: 3.0, position: .bottom)
            }
            self.tblDashbord.reloadData()
        }
    }
    
    func Get_Sub_ListApi(strSub: String, BoardID:String, StandardID:String)
    {
        var params = ["":""]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var strSet_Title = ""
        var api = ""
        //        if strStd_Sub == "1"
        //        {
        //            api = API.Get_StandardApi
        //            strSet_Title = "Step 2 - Select Standard"
        //            arrStandardFilter.removeAll()
        //        }
        //        else
        //        {
        //        if temp_strCategoryID1 == "" || temp_strCategoryID2 == ""
        //        {
        //            if temp_strCategoryID1 == ""
        //            {
        //                self.view.makeToast("Please Select Board", duration: 3.0, position: .bottom)
        //            }
        //            else
        //            {
        //                self.view.makeToast("Please Select Standard", duration: 3.0, position: .bottom)
        //            }
        //            self.tblDashbord.reloadData()
        //            return
        //        }
        showActivityIndicator()

        //            api = API.Get_SubjectApi
        api = API.Get_BoardStandardSubject_ListApi
        params = ["BoardID":BoardID,"StandardID":StandardID]
        strSet_Title = "Step 3 - Select Subject"
        arrSubjectFilter.removeAll()
        //        }
        //Bhargav Hide
        print("API, Params: \n",api,params)
        self.tblDashbord.reloadData()
                       if !Connectivity.isConnectedToInternet() {
                    self.AlertPopupInternet()

                           // show Alert
                           self.hideActivityIndicator()
                           print("The network is not reachable")
                           self.tblDashbord.reloadData()
                        // self.view.makeToast("The network is not reachable", duration: 3.0, position: .bottom)
                           return
                       }

        Alamofire.request(api, method: .post, parameters: params, headers: headers).validate().responseJSON { response in
            self.hideActivityIndicator()
            
            switch response.result {
            case .success(let value):
                //                self.arrHeaderSubTitle.removeAll()
                let json = JSON(value)
                //Bhargav Hide
                ////print("c",json)

                if(json["Status"] == "true" || json["Status"] == "1") {
                    let arrData = json["data"].array
                    //                    var arrChild = [YourPreferencesModal]()
                    
                    for value in arrData! {
                        //                        if strStd_Sub == "1"
                        //                        {
                        ////                            //Bhargav Hide
                        ////print(strCategoryTitle2)
                        //                            var preSelectedValues = [String]()
                        //                            preSelectedValues = strCategoryID2.components(separatedBy: ",")
                        //                            let filtered = preSelectedValues.filter { $0.contains("\(value["StandardID"].stringValue)") }
                        //                            var strSelectedTemp = "0"
                        //                              if filtered.count > 0{if self.strClearAll == "" {strSelectedTemp = "1"}}

                        //
                        //                            let ChildModel:SubCategory1ListModal = SubCategory1ListModal.init(id: value["StandardID"].stringValue, title: value["StandardName"].stringValue, subTitle: "", image: "\(API.imageUrl)\(value["Icon"].stringValue)", selected: strSelectedTemp)
                        //
                        //                            self.arrStandardFilter.append(ChildModel)
                        //                        }
                        //                        else
                        //                        {
                        //                            //Bhargav Hide
                        ////print(strCategoryTitle3)
                        var preSelectedValues = [String]()
                        preSelectedValues = self.temp_strCategoryID3.components(separatedBy: ",")
                        let filtered = preSelectedValues.filter { $0 == "\(value["SubjectID"].stringValue)" }
                        var strSelectedTemp = "0"
                        if filtered.count > 0{if self.strClearAll == "" {strSelectedTemp = "1"}}

                        let ChildModel:SubCategory1ListModal = SubCategory1ListModal.init(id: value["SubjectID"].stringValue, title: value["SubjectName"].stringValue, subTitle: "", image: "\(API.imageUrl)\(value["Icon"].stringValue)", selected: strSelectedTemp)

                        self.arrSubjectFilter.append(ChildModel)
                        //                        }
                    }
                }
                else
                {
                    //  self.view.makeToast("\(json["Msg"].stringValue)", duration: 3.0, position: .bottom)
                    //  self.collectionView.reloadData()
                }
            case .failure(let error):
                self.view.makeToast("Somthing wrong...", duration: 3.0, position: .bottom)
            }
            self.tblDashbord.reloadData()
        }
    }
    func Get_Std_ListApi(strStd: String, BoardID: String)
    {
        var params = ["":""]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var strSet_Title = ""
        var api = ""
        //        if strStd_Sub == "1"
        //        {
        //            api = API.Get_StandardApi
        //            //            params = ["BoardID":strCategoryID1]

        //        if temp_strCategoryID1 == ""
        //        {
        //            self.view.makeToast("Please Select Board", duration: 3.0, position: .bottom)
        //            self.tblDashbord.reloadData()
        ////            return
        //        }
        showActivityIndicator()

        api = API.Get_BoardStandard_ListApi
        params = ["BoardID":BoardID]
        strSet_Title = "Step 2 - Select Standard"
        arrStandardFilter.removeAll()
        //        }
        //        else
        //        {
        //            api = API.Get_SubjectApi
        //            strSet_Title = "Step 3 - Select Subject"
        //            //            params = ["CourseTypeID":strCategoryID]
        //            arrSubjectFilter.removeAll()
        //            //            api =  API.Get_CourseSubject_ListApi
        //            //            params = ["CourseID":strCategoryID1]
        //            //            strSet_Title = "Step 2 - Select Subject"
        //        }
        //Bhargav Hide
        print("API, Params: \n",api,params)
        self.tblDashbord.reloadData()
                       if !Connectivity.isConnectedToInternet() {
                    self.AlertPopupInternet()

                           // show Alert
                           self.hideActivityIndicator()
                           print("The network is not reachable")
                           self.tblDashbord.reloadData()
                        // self.view.makeToast("The network is not reachable", duration: 3.0, position: .bottom)
                           return
                       }

        Alamofire.request(api, method: .post, parameters: params, headers: headers).validate().responseJSON { response in
            self.hideActivityIndicator()
            
            switch response.result {
            case .success(let value):
                //                self.arrHeaderSubTitle.removeAll()
                let json = JSON(value)
                //Bhargav Hide
                ////print("d",json)

                if(json["Status"] == "true" || json["Status"] == "1") {
                    let arrData = json["data"].array
                    //                    var arrChild = [YourPreferencesModal]()
                    
                    for value in arrData! {
                        //                        if strStd_Sub == "1"
                        //                        {
                        //                            //Bhargav Hide
                        ////print(strCategoryTitle2)
                        var preSelectedValues = [String]()
                        preSelectedValues = self.temp_strCategoryID2.components(separatedBy: ",")
                        //                            let filtered = preSelectedValues.filter { $0.contains("\(value["StandardID"].stringValue)") }
                        let filtered = preSelectedValues.filter { $0 == "\(value["StandardID"].stringValue)" }
                        //                        let filtered = preSelectedValues.map { $0.contains("\(value["StandardID"].stringValue)") }
                        //                        let indexOfA : String = "\(preSelectedValues.firstIndex(of: "\(value["StandardID"].stringValue)") ?? 0)"

                        var strSelectedTemp = "0"
                        if filtered.count > 0{if self.strClearAll == "" {strSelectedTemp = "1"}}

                        let ChildModel:SubCategory1ListModal = SubCategory1ListModal.init(id: value["StandardID"].stringValue, title: value["StandardName"].stringValue, subTitle: "", image: "\(API.imageUrl)\(value["Icon"].stringValue)", selected: strSelectedTemp)

                        self.arrStandardFilter.append(ChildModel)
                        //                        }
                        //                        else
                        //                        {
                        //                            //                            //Bhargav Hide
                        ////print(strCategoryTitle3)
                        //                            var preSelectedValues = [String]()
                        //                            preSelectedValues = strCategoryID3.components(separatedBy: ",")
                        //                            let filtered = preSelectedValues.filter { $0.contains("\(value["SubjectID"].stringValue)") }
                        //                            var strSelectedTemp = "0"
                        //                         if filtered.count > 0{if self.strClearAll == "" {strSelectedTemp = "1"}}

                        //
                        //                            let ChildModel:SubCategory1ListModal = SubCategory1ListModal.init(id: value["SubjectID"].stringValue, title: value["SubjectName"].stringValue, subTitle: "", image: "\(API.imageUrl)\(value["Icon"].stringValue)", selected: strSelectedTemp)
                        //
                        //                            self.arrSubjectFilter.append(ChildModel)
                        //                        }
                    }
                    //                    self.Get_Sub_ListApi(strSub: "2")

                }
                else
                {
                    //                    self.view.makeToast("\(json["Msg"].stringValue)", duration: 3.0, position: .bottom)
                    //                    self.collectionView.reloadData()
                }
            case .failure(let error):
                self.view.makeToast("Somthing wrong...", duration: 3.0, position: .bottom)
            }
            self.tblDashbord.reloadData()
        }
    }

    func apiGet_Tutor_ListApi(Board_Course_ID: String, StandardID: String, SubjectID: String)
    {
        //        if self.arrHeaderSubTitle.count == 3
        //        {
        //            self.arrHeaderSubTitle.remove(at: 2) //change when position of target
        //        }
        showActivityIndicator()
        var params = ["":""]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var api = ""
        if strtempCategoryID == "1"
        {
            //            api = API.Get_Tutor_By_TutorIDApi
            //            params = ["TutorID":strCategoryID1]
            params = ["CourseTypeID":strtempCategoryID,"BoardID":Board_Course_ID,"CourseID":"","StandardID":StandardID,"SubjectID":SubjectID]

        }
        else
        {
            //            api = API.Get_Tutor_By_TutorIDApi
            //            params = ["TutorID":strCategoryID1]
            params = ["CourseTypeID":strtempCategoryID,"BoardID":"","CourseID":Board_Course_ID,"StandardID":"","SubjectID":""]

        }
        api = API.Get_TutorNameBy_CriteriaApi//Get_TutorApi

        //        params = ["TutorID":strCategoryID1]
        self.arrTutorFilter.removeAll()

        //Bhargav Hide
        print("API, Params: \n",api,params)
                       if !Connectivity.isConnectedToInternet() {
                    self.AlertPopupInternet()

                           // show Alert
                           self.hideActivityIndicator()
                           print("The network is not reachable")
                           self.tblDashbord.reloadData()
                        // self.view.makeToast("The network is not reachable", duration: 3.0, position: .bottom)
                           return
                       }
        
        Alamofire.request(api, method: .post, parameters: params, headers: headers).validate().responseJSON { response in
            self.hideActivityIndicator()
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                //Bhargav Hide
                ////print("e",json)

                if(json["Status"] == "true" || json["Status"] == "1") {
                    let arrData = json["data"].array
                    //                    var arrChild = [TutorListModal]()
                    
                    for value in arrData! {
                        //                        if strCategoryID == "1"
                        //                        {
                        var preSelectedValues = [String]()
                        preSelectedValues = self.temp_strTutorsId.components(separatedBy: ",")
                        let filtered = preSelectedValues.filter { $0 == "\(value["TutorID"].stringValue)" }
                        var strSelectedTemp = "0"
                        if filtered.count > 0{if self.strClearAll == "" {strSelectedTemp = "1"}}

                        let ChildModel:SubCategory1ListModal = SubCategory1ListModal.init(id: value["TutorID"].stringValue, title: value["TutorName"].stringValue, subTitle: value["InstituteName"].stringValue, image: "\(API.imageUrl)\(value["Icon"].stringValue)", selected: strSelectedTemp)

                        self.arrTutorFilter.append(ChildModel)

                        //                            let ChildModel:TutorListModal = TutorListModal.init(TutorID: value["TutorID"].stringValue, TutorName: value["TutorName"].stringValue, TutorEmail: value["TutorEmail"].stringValue, TutorPhoneNumber: value["TutorPhoneNumber"].stringValue, InstituteName: value["InstituteName"].stringValue)//(id: value["SubjectID"].stringValue, title: value["SubjectName"].stringValue, subTitle: "", image: "\(API.imageUrl)\(value["Icon"].stringValue)", selected: "0")
                        //
                        //                            self.arrTutorList.append(ChildModel)
                        //                        }
                        //                        else
                        //                        {
                        //                            //                            let ChildModel:YourPreferencesModal = YourPreferencesModal.init(id: value["SubjectID"].stringValue, title: value["SubjectName"].stringValue, subTitle: "", image: "", selected: "0")
                        //                            //
                        //                            //                            arrChild.append(ChildModel)
                        //                        }
                    }
                    //                    let PerentModel:YourPreferencesModal = YourPreferencesModal.init(id: "", Headertitle: "Tutors", subTitle: "", image: "", selected: "1", arrType: arrChild)
                    //                    self.arrHeaderSubTitle.append(PerentModel)
                    //                    if  self.arrHeaderSubTitle.count >= 2
                    //                    {self.arrHeaderSubTitle[0].selected = "0";self.arrHeaderSubTitle[1].selected = "0"}
                    //                    self.collectionView.reloadData()
                }
                else
                {
                    self.view.makeToast("\(json["Msg"].stringValue)", duration: 3.0, position: .bottom)
                    //                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                self.view.makeToast("Somthing wrong...", duration: 3.0, position: .bottom)
            }
            self.tblDashbord.reloadData()

        }
    }
}
