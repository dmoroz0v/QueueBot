import Foundation
import ChatBotSDK
import Fluent
import Vapor

final class SDKOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Any?

    init(app: Application) {
        initialHandlerId = ""
        inputHandlers = [:]
        action = SDKOperationAction(app: app)
        context = nil
    }

}

final class SDKOperationAction: FlowAction {

    let app: Application

    init(app: Application) {
        self.app = app
    }

    func execute(chat: Chat, user: User) async -> [String] {
        guard let username = user.username else {
            return ["Не удалось получить username"]
        }
        let rows = try? await QueueData.query(on: app.db).filter(\.$chatId == chat.id).all()
        var users: [String]
        if let row = rows?.first {
            users = row.value.split(separator: ",").map({ String($0) })
            users.append("\(username)")
            row.value = users.joined(separator: ",")
            try? await row.update(on: app.db)
        } else {
            users = [username]
            let r = QueueData(chatId: chat.id, value: "\(username)")
            try? await r.save(on: app.db)
        }

        return [
            QueueOperationAction.format(users: users)
        ]
    }

}
