import UIKit
import SwifteriOS
import SafariServices
import RxCocoa
import RxSwift

class LoginViewController: UIViewController, SFSafariViewControllerDelegate, ErrorNotifying {
    
    @IBOutlet weak var LoginTopImageView: CornerRoundableImageView!
    @IBOutlet weak var LoginButton: CornerRoundableButton!
    
    var routing: LoginRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: LoginViewModelProtocol?
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        bindVM()
    }
    
    private func bindUI() {
        
        LoginButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let this = self else { return }
                this.viewModel?.oAuthLogin(presentingForm: this)
            })
        .disposed(by: disposeBag)
    }
    
    private func bindVM() {
        
        viewModel?.error
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] error in
                guard let error = error as? AppError else { return }
                self?.showErrorMessage(error)
            }).disposed(by: disposeBag)
    }
}

// キャッシュクラス作成
// 遷移
// テスト // Observableで成功/失敗時に値がそれぞれ取れるかも
// UI調整
// ボタンエフェクト処理
// credential情報のコミットを修正/API Key隠蔽処理
