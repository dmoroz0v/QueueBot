import Foundation
import ChatBotSDK
import Fluent
import Vapor

final class FinishOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Any?

    init(app: Application, aborting: Bool) {
        initialHandlerId = ""
        inputHandlers = [:]
        action = FinishOperationAction(app: app, aborting: aborting)
        context = nil
    }

}

final class FinishOperationAction: FlowAction {

    let app: Application
    let aborting: Bool

    init(app: Application, aborting: Bool) {
        self.app = app
        self.aborting = aborting
    }

    func execute(chat: Chat, user: User) async -> [String] {
        guard let username = user.username else {
            return ["Не удалось получить username"]
        }
        let rows = try? await QueueData.query(on: app.db).filter(\.$chatId == chat.id).all()
        if let row = rows?.first {
            var users = row.value.split(separator: ",").map({ String($0) })
            guard let index = users.firstIndex(of: username) else {
                return [
                    "@\(username) не находится в очереди"
                ]
            }
            users.remove(at: index)
            row.value = users.joined(separator: ",")
            try? await row.update(on: app.db)
            let action = aborting ? "вышел из очереди" : "докатил sdk"
            return [
                "@\(username) \(action)" + "\n\n" + QueueOperationAction.format(users: users)
            ]
        } else {
            return [
                "@\(username) не находится в очереди"
            ]
        }
    }

}
