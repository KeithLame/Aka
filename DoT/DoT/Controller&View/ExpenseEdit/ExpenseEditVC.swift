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
        
        expenseEditVM.outputEditButtonClickedListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            expenseEditVM.complete.data = ()
            
            self.navigationController?.popViewController(animated: true)
        }
        
        expenseEditVM.outputDeleteButtonClickedListener.bind { [weak self] _ in
            
            guard let self else { return }
            
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
            
            guard let self else { return }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageSelectedButtonTapped))
            cell.photoImageView.addGestureRecognizer(tapGesture)
            guard let imageData = itemIdentifier as? Data, let image = UIImage(data: imageData) else { return }
            
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
            cell.deleteButton.tag = imageData.hashValue
            
            cell.configure(data: image)
        }
        
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.photoCollectionView) {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: photoRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        }
    }
    
    override func rightBarButtonClicked(_ sender: UIButton) {
        
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
        
        // 이미지의 Identifier를 사용하기 위해서는 초기화를 shared로 해줘야 합니다.
        var config = PHPickerConfiguration(photoLibrary: .shared())
        // 라이브러리에서 보여줄 Assets을 필터를 한다. (기본값: 이미지, 비디오, 라이브포토)
        config.filter = PHPickerFilter.any(of: [.images])
        // 다중 선택 갯수 설정 (0 = 무제한)
        config.selectionLimit = 5
        // 선택 동작을 나타냄 (default: 기본 틱 모양, ordered: 선택한 순서대로 숫자로 표현, people: 뭔지 모르겠게요)
        config.selection = .ordered
        // 잘은 모르겠지만, current로 설정하면 트랜스 코딩을 방지한다고 하네요!?
        // config.preferredAssetRepresentationMode = .current
        // 이 동작이 있어야 PHPicker를 실행 시, 선택했던 이미지를 기억해 표시할 수 있다. (델리게이트 코드 참고)
        config.preselectedAssetIdentifiers = expenseEditVM.selectedAssetIdentifiers
        
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
                expenseEditVM.selectedAssetIdentifiers.remove(at: idx)
                break
            }
        }
        print("delete")
        expenseEditVM.inputImageDataListener.data = datas
    }
}

extension ExpenseEditViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        // Picker에서 선택한 이미지의 Identifier들을 저장 (assetIdentifier은 옵셔널 값이라서 compactMap 받음)
        // 위의 PHPickerConfiguration에서 사용하기 위해서 입니다.
        expenseEditVM.selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        let dispatchGroup = DispatchGroup()
        
        var imageDataDic = [String: Data]()
        
        for idx in 0 ..< expenseEditVM.selectedAssetIdentifiers.count {
            
            dispatchGroup.enter()
            
            let identifier = self.expenseEditVM.selectedAssetIdentifiers[idx]
            let itemProvider = results[idx].itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                itemProvider.loadObject(ofClass: UIImage.self) { readingImage, error in
                    
                    guard let image = readingImage as? UIImage else { return }
                    
                    guard let data = image.jpegData(compressionQuality: 1.0) else { return }
                    
                    imageDataDic[identifier] = data
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            
            guard let self = self else { return }
            // 선택한 이미지의 순서대로 정렬하여 스택뷰에 올리기
            for identifier in expenseEditVM.selectedAssetIdentifiers {
                
                guard let data = imageDataDic[identifier] else { continue }
                
                expenseEditVM.inputImageDataListener.data.append(data)
            }
        }
        
        picker.dismiss(animated: true)
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
            
            if !datas.isEmpty {
                photoSnapshot.appendItems(datas, toSection: .photo)
            }
            photoSnapshot.appendItems(["plus Photo"], toSection: .photo)
            
            self.photoDataSource.apply(photoSnapshot, animatingDifferences: true)
        }
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



