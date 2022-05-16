### 将要整理代码

--------------------------------

主流APP分类切换滚动视图
https://github.com/pujiaxin33/JXCategoryView

import UIKit
import JXCategoryView

class GYCostRecordsVC: GYSwiftBaseViewController, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        queryOperatorList()
    }
    
    // 执行析构过程
    deinit {}
    
    // MARK: - Public
    
    // MARK: - Protocol
    // MARK: - JXCategoryListContainerViewDelegate
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return categoryView.titles.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        switch index {
        case 0:
            return telephoneBillVC()
        default:
            return smsBillVC()
        }
    }
    
    // MARK: - IBActions
    
    // MARK: - Private
    
    // MARK: - UI
    private func setupUI() -> Void {
        title = "业务扣费记录"
        view.addSubview(categoryView)
        view.addSubview(listContanerView)
        
        // 关联到 categoryView
        categoryView.listContainer = listContanerView
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        listContanerView.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Property

    lazy var categoryView: JXCategoryTitleView = {
        let _categoryView = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width:gScreenWidth , height: 50))
        _categoryView.delegate = self
        _categoryView.titles = ["通话中间服务费", "短信服务费"]
        _categoryView.isTitleColorGradientEnabled = true
        _categoryView.backgroundColor = UIColor.hexColor(0xf5f5f5)
        _categoryView.titleSelectedColor = .red
        _categoryView.titleColor = UIColor.hexColor(0x565659)
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = .red
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension
        lineView.verticalMargin = 4
        _categoryView.indicators = [ lineView ]
        
        return _categoryView
    }()
    
    lazy var listContanerView: JXCategoryListContainerView = {
        let _listContanerView = JXCategoryListContainerView(type: .scrollView, delegate: self)
        return _listContanerView!
    }()
    
}

--------------------------------


--------------------------------

