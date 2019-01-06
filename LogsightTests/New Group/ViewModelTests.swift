import XCTest
import Quick
import Nimble
@testable import Logsight

class ViewModelTests: QuickSpec {
    override func spec() {
        describe("ViewModel") {
            let fakeApp = Application(name: "fake", filePath: "file://fake")
            let viewModel = ViewModel(fileLoader: FakeFileLoader())
            let delegateCaptor = FakeViewModelDelegate()
            viewModel.onNewFileLoading(application: fakeApp)
            viewModel.addDelegate(delegateCaptor)
            
            context("if it doesn't have any log yet") {
                it("simply add new logs at the end of existing logs") {
                    let logs = [self.log(Date(), fakeApp)]
                    viewModel.onNewLogsLoaded(logs)
                    
                    expect(delegateCaptor.lastReceivedDiff?.added).to(equal([0]))
                    expect(viewModel.logs).to(equal(logs))
                }
            }
        }
    }
    
    func log(_ date: Date, _ application: Application) -> Log {
        return Log(date: date, application: application, level: .info, message: "message", data: [:])
    }
}
