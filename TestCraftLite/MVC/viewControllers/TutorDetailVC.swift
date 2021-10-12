//
//  TutorDetailVC.swift
//  TestCraftLite
//
//  Created by ADMS on 21/05/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import SDWebImage
import Cosmos


class TutorDetailVC: UIViewController,ActivityIndicatorPresenter,UITextFieldDelegate,UIScrollViewDelegate {

    var activityIndicatorView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var imgView = UIImageView()

    var tutorId:Int = -1
    var arrMyPackageList = [arrTestList]()

    var arrTutorList = [arrTutorModel]()
    
    @IBOutlet weak var tblTutorList:UITableView!
    @IBOutlet weak var lblTutorName:UILabel!
    @IBOutlet weak var lblTutorCount:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblTutorDesc:UILabel!
    @IBOutlet weak var vwStarRating:CosmosView!
    @IBOutlet weak var imgTutor:UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()


      //  tblTutorList.constant = self.view.frame.height-64
//            self.tblTutorList.isScrollEnabled = false
//            //no need to write following if checked in storyboard
//            self.scrollView.bounces = false
//            self.tblTutorList.bounces = true

        tblTutorList.register(UINib(nibName: "MyPackageCell", bundle: nil), forCellReuseIdentifier: "MyPackageCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        api_Call_Get_Tutor_Detail()
    }

    @IBAction func btnClickBack(){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            var contentRect = CGRect.zero

            for view in self.scrollView.subviews {
               contentRect = contentRect.union(view.frame)
            }

            self.scrollView.contentSize = contentRect.size

            self.tblTutorList.frame.size = self.tblTutorList.contentSize


            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrollView.contentSize.height + CGFloat(self.tableViewHeightConstraint.constant))

        }
    }

//    override func viewDidLayoutSubviews() {
//        // Dynamically resize the table to fit the number of cells
//        // Scrolling is turned off on the table in InterfaceBuilder
//        tblTutorList.frame.size = tblTutorList.contentSize
//        tableViewHeightConstraint.constant = tblTutorList.frame.height
//    }
    /// UIScrollViewDelegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // Disabling horizontal scrolling
//            scrollView.contentOffset.x = 0.0
//
//            print(scrollView.contentOffset.y)
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == self.scrollView {
//            tblTutorList.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
//        }
//
//        if scrollView == self.tblTutorList {
//            self.tblTutorList.isScrollEnabled = (tblTutorList.contentOffset.y > 0)
//        }
//    }

}
extension TutorDetailVC{

    func api_Call_TestPackageName_By_TutorID_New()
    {
        showActivityIndicator()
        self.arrTutorList.removeAll()

        // let params = [:]
        var params = ["":""]


        if strCategoryID1 != "" && strCategoryID1 != ""
        {
            if ((UserDefaults.standard.value(forKey: "logindata")) != nil)
            {
                //            result = UserDefaults.standard.value(forKey: "logindata") as! [String : String] //as! NSMutableDictionary
                //        }
                let result = UserDefaults.standard.value(forKey: "logindata")! as! NSDictionary


                if strCategoryID == "1" {
                    params = ["StudentID":"\(result["StudentID"] ?? "")","TutorID":"\(tutorId)","CourseTypeID":"1","BoardID":strCategoryID1,"CourseID":"","StandardID":strCategoryID2,"SubjectID":strCategoryID3]
                }else{
                    params = ["StudentID":"\(result["StudentID"] ?? "")","TutorID":"\(tutorId)","BoardID":"","StandardID":"","CourseTypeID": "2","SubjectID":"","CourseID":strCategoryID1]
                }
            }

        }
        else{
            if ((UserDefaults.standard.value(forKey: "logindata")) != nil)
            {
                //            result = UserDefaults.standard.value(forKey: "logindata") as! [String : String] //as! NSMutableDictionary
                //        }
                let result = UserDefaults.standard.value(forKey: "logindata")! as! NSDictionary

                params = ["StudentID":"\(result["StudentID"] ?? "")","TutorID":"\(tutorId)","CourseTypeID":"","BoardID":"","CourseID":"","StandardID":"","SubjectID":""]

            }

        }


        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        //Bhargav Hide
        //        print("API, Params: \n",API.Get_Course_ListApi,params)
        if !Connectivity.isConnectedToInternet() {
            //            self.AlertPopupInternet()

            // show Alert
            self.hideActivityIndicator()
            print("The network is not reachable")
            self.tblTutorList.reloadData()
            // self.view.makeToast("The network is not reachable", duration: 3.0, position: .bottom)
            return
        }
        //        Get_TutorNameBy_Criteria_Lite(string CourseTypeID, string BoardID, string CourseID, string StandardID, string SubjectID)
        Alamofire.request(API.Get_TestPackageName_By_TutorID_New, method: .post, parameters: params, headers: headers).validate().responseJSON { response in
            self.hideActivityIndicator()

            switch response.result {
            case .success(let value):

                let json = JSON(value)
                //Bhargav Hide
                print(json)
                //   self.arrPreferenceList.removeAll()
                if(json["Status"] == "true" || json["Status"] == "1") {

                    let arrData1 = json["data"].array!

                    //                    for value in arrData1 {
                    //                        self.strtempBoardID = "\(value["BoardID"].stringValue)"
                    //                        self.istempSubscription = "\(value["isSubscription"].stringValue)"
                    //                        let Performance_final = Double("\(value["Performance"].stringValue ?? "0")")//100 - per
                    //                        self.floatPercentage = CGFloat(Performance_final ?? 0)
                    //                        self.strProgress = "\(value["Performance"].stringValue)"
                    //
                    //                    }
                    // let arrData = json["data"][0]["PackageList"].array!
                    self.arrMyPackageList.removeAll()
                    for values in arrData1 {
                        // let TestTypeModel:PackageDetailsModal = PackageDetailsModal.init(id: "", TestTypeName: values["TestTypeName"].stringValue, TestQuantity: values["TestQuantity"].stringValue)
                        let TestTypeModel:arrTestList = arrTestList.init(SubjectName: values["SubjectName"].stringValue, TestName: values["TestName"].stringValue, NumberOfHintUsed: values["NumberOfHintUsed"].stringValue, TestEndTime: values["TestEndTime"].stringValue, TestDuration: values["TestDuration"].stringValue, CourseName: values["CourseName"].stringValue, STGuiD: values["STGuiD"].intValue, TestInstruction: values["TestInstruction"].stringValue, RemainTime: values["RemainTime"].stringValue, NumberOfHint: values["NumberOfHint"].stringValue, Icon: values["Icon"].stringValue, TutorName: values["TutorName"].stringValue, Name: values["Name"].stringValue, TotalQuestions: values["TotalQuestions"].stringValue, TestMarks: values["TestMarks"].stringValue, StatusName: values["StatusName"].stringValue, IsCompetetive: values["IsCompetetive"].stringValue, TestStartTime: values["TestStartTime"].stringValue, StudentTestID: values["StudentTestID"].intValue, TestID: values["TestID"].intValue, TestGuiD: values["TestGuiD"].intValue, TestPackageName: values["TestPackageName"].stringValue,IsFree: values["IsFree"].stringValue,Price: values["Price"].stringValue,TestPackageID: values["TestPackageID"].intValue) // old
                        self.arrMyPackageList.append(TestTypeModel)
                    }

                    DispatchQueue.main.async {

                        self.tblTutorList.reloadData()

                        if self.arrMyPackageList.count == 1
                        {
                            self.tableViewHeightConstraint.constant = self.tblTutorList.contentSize.height
                        }



                    }

                }
                else
                {
                    self.view.makeToast("\(json["Msg"].stringValue)", duration: 3.0, position: .bottom)
                }
            case .failure(let error):
                self.view.makeToast("Somthing wrong...", duration: 3.0, position: .bottom)
            }
        }
    }


    func api_Call_Get_Tutor_Detail()
    {
        showActivityIndicator()
        self.arrTutorList.removeAll()

        // let params = [:]
        let params = ["TutorID":tutorId]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        //Bhargav Hide
        //        print("API, Params: \n",API.Get_Course_ListApi,params)
        if !Connectivity.isConnectedToInternet() {
            //            self.AlertPopupInternet()

            // show Alert
            self.hideActivityIndicator()
            print("The network is not reachable")
            self.tblTutorList.reloadData()
            // self.view.makeToast("The network is not reachable", duration: 3.0, position: .bottom)
            return
        }
        //        Get_TutorNameBy_Criteria_Lite(string CourseTypeID, string BoardID, string CourseID, string StandardID, string SubjectID)
        Alamofire.request(API.Get_Tutor_By_TutorIDApi, method: .post, parameters: params, headers: headers).validate().responseJSON { response in
            self.hideActivityIndicator()

            switch response.result {
            case .success(let value):

                let json = JSON(value)
                //Bhargav Hide
                print(json)
                //   self.arrPreferenceList.removeAll()
                if(json["Status"] == "true" || json["Status"] == "1") {
                    if let arrData = json["data"].array{
                        for (_,value) in arrData.enumerated() {

                            let objdict = arrTutorModel(
                                TutorID: value["TutorID"].intValue, TutorName: value["TutorName"].stringValue, TutorEmail: value["TutorEmail"].stringValue, TutorPhoneNumber: value["TutorPhoneNumber"].stringValue, InstituteName: value["InstituteName"].stringValue, Icon: value["Icon"].stringValue, TotalRateCount: value["TutorStars"].stringValue, TutorStars: value["TutorStars"].doubleValue, TutorDescription: value["TutorDescription"].stringValue)
                            self.arrTutorList.append(objdict)
                        }


                        self.imgTutor.layer.cornerRadius = self.imgTutor.layer.frame.width/2.0
                        self.imgTutor.layer.masksToBounds = true


                        //        if( searching == true){
                        self.imgTutor.sd_setImage(with: URL(string: API.imageUrl + self.arrTutorList[0].Icon))

                        // tempory hide InstituteName

                        //  cell.lblBoard.text = arrTutorList[indexPath.row].InstituteName
                        self.lblTitle.text = self.arrTutorList[0].TutorName
                        self.lblTutorName.text = self.arrTutorList[0].TutorName

                        // tempory hide TutorPhoneNumber
                        self.lblTutorDesc.text = self.arrTutorList[0].TutorDescription

                        self.lblTutorCount.text = "(\(self.arrTutorList[0].TotalRateCount))"

                        self.vwStarRating.isHidden = false
                        self.vwStarRating.rating = self.arrTutorList[0].TutorStars
                        self.vwStarRating.settings.updateOnTouch = false
                        self.vwStarRating.settings.starMargin = 1
                        // self.lblTutorCount.text = "(\(self.arrTutorList[0].TotalRateCount))"

                        self.api_Call_TestPackageName_By_TutorID_New()

                    }
                }
                else
                {
                    self.view.makeToast("\(json["Msg"].stringValue)", duration: 3.0, position: .bottom)
                }
            case .failure(let error):
                self.view.makeToast("Somthing wrong...", duration: 3.0, position: .bottom)
            }
        }
    }
}
extension TutorDetailVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMyPackageList.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell  = tableView.dequeueReusableCell(withIdentifier: "MyPackageCell", for: indexPath) as! MyPackageCell
        cell.selectionStyle = .none

        if arrMyPackageList.count > 1
        {
            self.tableViewHeightConstraint.constant = self.tblTutorList.contentSize.height
        }


        if arrMyPackageList.count > 0
        {
            if arrMyPackageList[indexPath.row].IsFree == "1"{
                cell.btnBuyClick.isHidden = true
                cell.imgAnalysis.isHidden = false
                if arrMyPackageList[indexPath.row].StatusName == "Start Test"{
                    cell.imgAnalysis.image = UIImage(named: "StartIcon.png")
                }else if arrMyPackageList[indexPath.row].StatusName == "Resume"{
                    cell.imgAnalysis.image = UIImage(named: "Group 79.png")
                }else if arrMyPackageList[indexPath.row].StatusName == "Analyse"{
                    cell.imgAnalysis.image = UIImage(named: "CompleteTestIcon.png")
                }
                cell.lblAttemptTotalTest.isHidden = false
                cell.lblPackagePrice.isHidden = true

            }else{
                cell.btnBuyClick.isHidden = false
                cell.imgAnalysis.isHidden = true
                cell.lblPackagePrice.isHidden = false
                cell.lblPackagePrice.text = "Price :" + "₹"+"\(arrMyPackageList[indexPath.row].Price)"
                //                    cell.lblAttemptTotalTest.isHidden = true
                //                    cell.lblAttemptTotalTest.text = "Marks :\(arrMyPackageList[indexPath.row].TotalQuestions)"

            }

            cell.btnBuyClick.layer.cornerRadius = cell.btnBuyClick.layer.frame.height / 2
            cell.btnBuyClick.layer.masksToBounds = true

            cell.btnBuyClick.addTarget(self, action:#selector(btnBuyClickEvent(_:)), for: .touchUpInside)

            cell.btnBuyClick.tag = indexPath.row
            cell.lblTestName.text = arrMyPackageList[indexPath.row].TestName
            cell.lblTestSubjectName.text = "Time :\(arrMyPackageList[indexPath.row].TestDuration)"
            cell.lblAttemptTotalTest.text = "Marks :\(arrMyPackageList[indexPath.row].TestMarks)"

            //                cell.imgOfSubject.layer.borderWidth = 1.0
            //                cell.imgOfSubject.layer.borderColor = UIColor.white.cgColor

            cell.lblTestName.isHidden = false

            if arrMyPackageList[indexPath.row].TutorName == "Testcraft"
            {
                cell.lblTutorname.isHidden = true

            }else{
                cell.lblTutorname.isHidden = true
               // cell.lblTutorname.text = arrMyPackageList[indexPath.row].TutorName
            }

            cell.imgOfSubject.sd_setImage(with: URL(string: API.imageUrl + arrMyPackageList[indexPath.row].Icon))

            cell.imgOfSubject.layer.cornerRadius = cell.imgOfSubject.layer.frame.width / 2.0
            cell.imgOfSubject.layer.masksToBounds = true
        }


        return cell
    }

    @objc func btnBuyClickEvent(_ sender:UIButton)
    {
//        if arrMyPackageList[sender.tag].Price != "" && arrMyPackageList[sender.tag].Price != "0"{
//            strTestPackageID = "\(arrMyPackageList[sender.tag].TestPackageID)"
//            AddTocart_Api(strCoin: arrMyPackageList[sender.tag].Price)
//            IsFree = "\(arrMyPackageList[sender.tag].IsFree)"
//
//
//            arrPackageDetail = StandardList(ID: "\(arrMyPackageList[sender.tag].TestID)", Name: arrMyPackageList[sender.tag].TestPackageName, Icon: "", selected: "")
//        }
//
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        <#code#>
    //    }
//    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
//        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        view.layer.mask = mask
//    }
}
