import XCTest
import Quick
import Nimble
@testable import Logsight

class LogsServiceImplTests: QuickSpec {
    override func spec() {
        describe("LogsServiceImpl") {
            let fakeApp = Application(name: "fake", filePath: "file://fake")
            let logsServiceImpl = LogsServiceImpl(fileLoader: FakeFileLoader())
            let delegateCaptor = FakeLogsServiceDelegate()
            logsServiceImpl.onNewFileLoading(application: fakeApp)
            logsServiceImpl.addDelegate(delegateCaptor)
            
            context("if it doesn't have any log yet") {
                it("simply add new logs at the end of existing logs") {
                    let logs = [self.log(Date(), fakeApp)]
                    logsServiceImpl.onNewLogsLoaded(logs)
                    
                    expect(delegateCaptor.lastReceivedDiff).to(equal([.added(0..<1)]))
                    expect(logsServiceImpl.logs).to(equal(logs))
                }
            }
        }
    }
    
    func log(_ date: Date, _ application: Application) -> Log {
        return Log(date: date, application: application, level: .info, message: "message", data: [:])
    }
}
