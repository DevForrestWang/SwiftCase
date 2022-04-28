#  <#Title#>

    @objc private func postersAction() {
        guard let imageName = currentModel?.posterImg else {
            yxc_debugPrintf("The posterImg is empty.")
            return
        }
        
        let usrPostersImage = GYCompanySwiftAdapter.gy_PICTUREAPPENDING(imageName)
        yxc_debugPrintf("image: \(usrPostersImage)")
        
        GYCompanyUtils.downloadWith(urlStr: usrPostersImage) { [weak self] image in
            guard let saveImage = image else {
                GYUtils.showCenterToast("海报生成失败")
                return
            }
            // 写入相册
            UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(self?.saveImageResult(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc private func saveImageResult(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            GYUtils.showCenterToast("海报保存失败")
        } else {
            GYUtils.showCenterToast("海报保存成功")
        }
    }
    
    
---------------------
class GYActivitySelectTimeView: GYPopupBaseView, UIPickerViewDataSource,UIPickerViewDelegate  {
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError()
    }
    
    // 执行析构过程
    deinit {}
    
    // MARK: - Public
    public func show(_ contentHeight: CGFloat, headIcon: Bool, titleName: String, startTime: String, isSelectTime: Bool) {
        super.show(contentHeight, headIcon: headIcon, titleName: titleName)
        self.startTime = startTime
        self.isSelectTime = isSelectTime
        
        if startTime.count > 0 {
            let timeAry = startTime.split(separator: ":")
            if timeAry.count > 1 {
                inputHour = String(timeAry[0]).toInt() ?? 0
                inputMinute = String(timeAry[1]).toInt() ?? 0
                pickerView.selectRow(inputHour, inComponent: 0, animated: true)
                pickerView.selectRow(inputMinute, inComponent: 1, animated: true)
            }
        }
    }
    
    // MARK: - Protocol
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hoursArray.count
        } else {
            return minuteArray.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row < hoursArray.count {
                return String(format: "%02d", arguments: [hoursArray[row]])
            }
        } else {
            if row < minuteArray.count {
                return String(format: "%02d", arguments: [minuteArray[row]])
            }
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var hour = ""
        var minute = ""
        if component == 0 {
            hour = String(format: "%02d", arguments: [hoursArray[row]])
        } else {
            minute = String(format: "%02d", arguments: [minuteArray[row]])
        }
        yxc_debugPrintf("hour: \(hour), minute: \(minute)")
    }
    
    // MARK: - IBActions
    @objc private func confirmAction() {
        let hour = pickerView.selectedRow(inComponent: 0)
        if hour < inputHour {
            GYUtils.showCenterToast("活动开始时间不能大于活动结束时间")
            return
        }
        
        let minute = pickerView.selectedRow(inComponent: 1)
        if hour == inputHour && minute <= inputMinute {
            GYUtils.showCenterToast("活动开始时间不能大于活动结束时间")
            return
        }
        
        if let tmpClouse = gySelectTimeClosure {
            let selectTime = "\(String(format: "%02d", arguments: [hour])):\(String(format: "%02d", arguments: [minute]))"
            
            var relustTime = "\(selectTime)"
            if isSelectTime {
                relustTime = "\(startTime)~\(selectTime)"
            }
            
            tmpClouse(relustTime)
            closeAction()
        }
    }
    
    // MARK: - Private
    
    // MARK: - UI
    private func setupUI() -> Void {
        contentView.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
        
        leftTitleButton.setTitle("取消", for: .normal)
        leftTitleButton.setTitleColor(UIColor.hexColor(0x949495), for: .normal)
        leftTitleButton.titleLabel?.font = .systemFont(ofSize: 16)
        leftTitleButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        rightTitleButton.setTitle("确认", for: .normal)
        rightTitleButton.setTitleColor(UIColor.hexColor(0x546d93), for: .normal)
        rightTitleButton.titleLabel?.font = .systemFont(ofSize: 16)
        rightTitleButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Property
    public var gySelectTimeClosure: ((_ selectTime: String) -> Void)?
    
    var startTime = ""
    var isSelectTime: Bool = false
    var inputHour: Int = 0
    var inputMinute: Int = 0
    
    let hoursArray = Array(0...23)
    let minuteArray = Array(0...59)
    
    let pickerView = UIPickerView().then {
        $0.backgroundColor = .white
        $0.selectRow(0, inComponent: 0, animated: true)
    }

}




