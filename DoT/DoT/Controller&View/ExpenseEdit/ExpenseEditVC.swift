//
//  ExpenseEditViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import UIKit
import PhotosUI

class ExpenseEditViewController: BaseViewController<ExpenseEditView> {
    
    private var categoryDataSource: UICollectionViewDiffableDataSource<CategoryCompositionalLayout, ExpenseCategory>!
    private var photoDataSource: UICollectionViewDiffableDataSource<PhotoCompositionalLayout, AnyHashable>!
    let expenseEditVM = ExpenseEditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
        
        expenseEditVM.inputCheckSaveButtonEnabledListener.data = ()
    }
    
    override func configure() {
        
        let createCustomView = UIButton()
        
        createCustomView.configure(title: "지출내역 삭제", image: nil, fontSize: .small, fontScale: .Bold, backgroundColor: .clear, foregroundColor: .justRed, imageColor: .blackWhite)
        createCustomView.addTarget(self, action: #selector(rightBarButtonClicked), for: .touchUpInside)
        
        let createBarButton = UIBarButtonItem(customView: createCustomView)
        
        navigationItem.rightBarButtonItem = createBarButton
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        layoutView.mainScrollView.addGestureRecognizer(tapGesture)
        
        guard let tripDetailInfo = expenseEditVM.inputTripDetailInfoListener.data else { return }
        layoutView.configure(data: tripDetailInfo)
        
        layoutView.expenseTextField.addTarget(self, action: #selector(expenseValueChanged), for: .editingChanged)
        layoutView.placeTextField.addTarget(self, action: #selector(placeValueChanged), for: .editingChanged)
        layoutView.editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        layoutView.memoTextView.delegate = self
        
        layoutView.expenseTextField.delegate = self
        layoutView.placeTextField.delegate = self
    }
    
    override func bindData() {
        
        // Category 선택된 셀 이외 모두 선택 끄기
        expenseEditVM.outputCategoryButtonClickedListener.bind { [weak self] category in
            
            guard let self, let category else { return }
            
            for idx in 0 ..< ExpenseCategory.allCases.count {
                let indexPath = IndexPath(item: idx, section: 0)
                guard let cell = layoutView.categoryCollectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
                cell.update(data: category)
            }
        }
        
        // 수정 버튼 클릭 활성화 여부 체크
        expenseEditVM.outputCheckSaveButtonEnabledListener.bind { [weak self] isEnabled in
            
            guard let self else { return }
            
            layoutView.editButton.isEnabled = isEnabled
        }
        
        // 데이터 수정 시 Expense VC로 이동
        expenseEditVM.outputEditButtonClickedListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            expenseEditVM.complete.data = ()
            
            self.navigationController?.popViewController(animated: true)
        }
        
        // 데이터 삭제 시 Expense VC로 이동
        expenseEditVM.outputDeleteButtonClickedListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            expenseEditVM.complete.data = ()
            
            navigationController?.popViewController(animated: true)
        }
        
        // 이미지 선택 시 사진 콜렉션뷰 업데이트
        expenseEditVM.outputImageDataListener.bind { [weak self] datas in
            
            guard let self else { return }
            
            update()
        }
    }
    
    override func configureCollectionView() {
        
        layoutView.categoryCollectionView.showsHorizontalScrollIndicator = false
        
        // MARK: Category Collecion View
        let categoryRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, ExpenseCategory> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self, let tripDetailInfo = expenseEditVM.inputTripDetailInfoListener.data else { return }
            
            // Category Button Selected
            expenseEditVM.inputCategoryButtonClickedListener.data = tripDetailInfo.category
            cell.configure(data: itemIdentifier)
            cell.categoryButton.tag = indexPath.item
            cell.categoryButton.addTarget(self, action: #selector(self.categoryButtonClicked), for: .touchUpInside)
            cell.update(data: tripDetailInfo.category)
        }
        
        categoryDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.categoryCollectionView) {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: categoryRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        }
        
        layoutView.photoCollectionView.showsHorizontalScrollIndicator = false
        
        // MARK: Photo Collecion View
        let photoRegistration = UICollectionView.CellRegistration<PhotoCollectionViewCell, AnyHashable> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self,
                  let photoDTO = itemIdentifier as? PhotoInfoDTO,
                  let image = UIImage(data: photoDTO.data) else { return }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageSelectedButtonTapped))
            cell.photoImageView.addGestureRecognizer(tapGesture)
            
            let data = photoDTO.data
            
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
            cell.deleteButton.tag = data.hashValue
            cell.configure(data: image)
        }
        
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.photoCollectionView) {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: photoRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        }
    }
    
    // 데이터 삭제
    override func rightBarButtonClicked(_ sender: UIButton) {
        
        let alert = makeAlert()
        
        present(alert, animated: true)
    }
    
    // 지출 변경
    @objc private func expenseValueChanged(_ sender: UITextField) {
        
        guard let input = sender.text else { return }
        
        let result = input.convertDecimalString()
        sender.text = result
        
        expenseEditVM.inputExpenseListener.data = result
        expenseEditVM.inputCheckSaveButtonEnabledListener.data = ()
    }
    
    // 장소 입력
    @objc private func placeValueChanged(_ sender: UITextField) {
        
        guard let place = sender.text else { return }
        
        if place.isWhiteSpace() {
            sender.text = ""
        }
        
        expenseEditVM.inputPlaceListener.data = place
    }
    
    // 카테고리 선택 버튼 클릭
    @objc private func categoryButtonClicked(sender: UIButton) {
        
        guard let category = ExpenseCategory(rawValue: sender.tag) else { return }
        
        expenseEditVM.inputCategoryButtonClickedListener.data = category
    }
    
    // 수정 버튼 클릭
    @objc private func editButtonClicked(sender: UIButton) {
        
        expenseEditVM.inputEditButtonClickedListener.data = ()
    }
    
    // 키보드 내리기
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        
        layoutView.endEditing(true)
    }
    
    // 사진첩 선택
    @objc private func imageSelectedButtonTapped(sender: UITapGestureRecognizer) {
        
        let limitCount = 5 - (expenseEditVM.inputImageDataListener.data).count
        
        // 이미지의 Identifier를 사용하기 위해서는 초기화를 shared로 해줘야 함
        var config = PHPickerConfiguration(photoLibrary: .shared())
        // 라이브러리에서 보여줄 Assets을 필터 (기본값: 이미지, 비디오, 라이브포토)
        config.filter = PHPickerFilter.any(of: [.images])
        // 다중 선택 갯수 설정 - 최대 5개로 한정 (0 = 무제한)
        config.selectionLimit = limitCount
        // 선택 동작을 나타냄 (default: 기본 틱 모양, ordered: 선택한 순서대로 숫자로 표현)
        config.selection = .ordered
        // current로 설정 시 트랜스 코딩을 방지
        config.preferredAssetRepresentationMode = .current
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        
        present(phPicker, animated: true)
    }
    
    // 선택된 사진 삭제
    @objc private func deleteButtonClicked(sender: UIButton) {
        
        let dataHashVaulue = sender.tag
        var datas = expenseEditVM.inputImageDataListener.data
        
        for idx in 0 ..< datas.count {
            if datas[idx].hashValue == dataHashVaulue {
                datas.remove(at: idx)
                break
            }
        }
        
        expenseEditVM.inputImageDataListener.data = datas
    }
}

extension ExpenseEditViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        // 임시 데이터 보관소 - 저장 순서 체크
        var identifierGroup = [String?]()
        var imageDataDic = [String?: Data]()
        
        for result in results {
            
            dispatchGroup.enter()
            
            let identifier = result.assetIdentifier
            let itemProvider = result.itemProvider
            
            identifierGroup.append(identifier)
            
            // 모두 새로 선택한 Image이기 때문에 canLoadObject로 체크하지 않아도 됨
            itemProvider.loadObject(ofClass: UIImage.self) { readingImage, error in
                
                guard let image = readingImage as? UIImage,
                      let data = image.jpegData(compressionQuality: 1.0) else { return }
                
                imageDataDic[identifier] = data
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            
            guard let self = self else { return }
            
            // 선택한 이미지의 순서대로 저장
            for identifier in identifierGroup {
                
                guard let data = imageDataDic[identifier] else { continue }
                
                expenseEditVM.inputImageDataListener.data.append(data)
            }
        }
        
        picker.dismiss(animated: true)
    }
}

extension ExpenseEditViewController: UITextFieldDelegate {
    
    // 소수점 3자리 이상부터는 입력 불가
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField != layoutView.expenseTextField { return true }
        
        guard let text = textField.text else { return true }
        
        return expenseEditVM.limitDecimalPoint(text, range: range.location)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension ExpenseEditViewController: UITextViewDelegate {
    
    // 메모 입력
    func textViewDidChange(_ textView: UITextView) {
        
        guard let memo = textView.text else { return }
        
        expenseEditVM.inputMemoListener.data = memo
    }
}

extension ExpenseEditViewController {
    
    private func update() {
        
        DispatchQueue.main.async {
            // Category Snapshot
            var categorySnapshot = NSDiffableDataSourceSnapshot<CategoryCompositionalLayout, ExpenseCategory>()
            categorySnapshot.appendSections([.category])
            
            categorySnapshot.appendItems(ExpenseCategory.allCases, toSection: .category)
            
            self.categoryDataSource.apply(categorySnapshot, animatingDifferences: true)
            
            // Photo Snapshot
            var photoSnapshot = NSDiffableDataSourceSnapshot<PhotoCompositionalLayout, AnyHashable>()
            photoSnapshot.appendSections([.photo])
            
            let datas = self.expenseEditVM.outputImageDataListener.data
            photoSnapshot.appendItems(datas, toSection: .photo)
            
            if datas.count < 5 {
                photoSnapshot.appendItems(["plus Photo"], toSection: .photo)
            }
            
            self.photoDataSource.apply(photoSnapshot, animatingDifferences: true)
        }
    }
    
    private func makeAlert() -> UIAlertController {
        let alertTitle = "해당 지출내역을 삭제합니다"
        let deleteTitle = "삭제"
        let cancelTitle = "취소"
        
        let attributeAlertTitle = NSMutableAttributedString(string: alertTitle)
        let font = FontManager.getFont(size: .medium, scale: .Bold)
        
        attributeAlertTitle.addAttributes([.font: font, .foregroundColor: UIColor.blackWhite], range: (alertTitle as NSString).range(of: alertTitle))
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: deleteTitle, style: .destructive) { [weak self] _ in
            
            guard let self else { return }
            
            expenseEditVM.inputDeleteButtonClickedListener.data = ()
        }
        let cancelButton = UIAlertAction(title: cancelTitle, style: .cancel)
        
        alert.setValue(attributeAlertTitle, forKey: "attributedTitle")
        deleteButton.setValue(UIColor.justRed, forKey: "titleTextColor")
        cancelButton.setValue(UIColor.justGray, forKey: "titleTextColor")
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        return alert
    }
}
