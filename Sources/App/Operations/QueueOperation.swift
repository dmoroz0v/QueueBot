import Foundation
import ChatBotSDK
import Fluent
import Vapor

final class QueueOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Any?

    init(app: Application) {
        initialHandlerId = ""
        inputHandlers = [:]
        action = QueueOperationAction(app: app)
        context = nil
    }

}

final class QueueOperationAction: FlowAction {
    let app: Application

    init(app: Application) {
        self.app = app
    }

    static func format(users: [String]) -> String {
        if users.count == 0 {
            return "Очередь пуста"
        }

        if users.count == 1 {
            return "Сейчас катит @\(users[0])"
        }

        let queue = users.dropFirst().enumerated().map({ index, user in
            return "\(index + 1). @\(user)"
        }).joined(separator: "\n")

        return "Сейчас катит: @\(users[0])" + "\n\n" + "На очереди:" + "\n" + queue
    }

    func execute(chat: Chat, user: User) async -> [String] {
        let rows: [QueueData]
        do {
            rows = try await QueueData.query(on: app.db).filter(\.$chatId == chat.id).all()
        } catch let e {
            return [e.localizedDescription]
        }

        let users = (rows.first?.value ?? "").split(separator: ",").map({ String($0) })

        return [
            QueueOperationAction.format(users: users)
        ]
    }

}
