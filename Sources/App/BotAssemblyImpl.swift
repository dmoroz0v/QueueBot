import Foundation
import ChatBotSDK
import Fluent
import Vapor

public final class BotAssemblyImpl: BotAssembly {

    public private(set) lazy var commandsHandlers: [CommandHandler] = [

        CommandHandler(
            command: Command(value: "/sdk"),
            description: "Вставить в очередь покатить sdk",
            flowAssembly: SDKOperationFlowAssembly(app: app)
        ),

        CommandHandler(
            command: Command(value: "/queue"),
            description: "Показать очередь",
            flowAssembly: QueueOperationFlowAssembly(app: app)
        ),

        CommandHandler(
            command: Command(value: "/finish"),
            description: "Закончить катить sdk и выйти из очереди",
            flowAssembly: FinishOperationFlowAssembly(app: app, aborting: false)
        ),

        CommandHandler(
            command: Command(value: "/abort"),
            description: "Выйти из очереди",
            flowAssembly: FinishOperationFlowAssembly(app: app, aborting: true)
        ),

//        CommandHandler(
//            command: Command(value: "/insert"),
//            description: "Insert value",
//            flowAssembly: DatabaseInsertOperationFlowAssembly(app: app)
//        ),

//        CommandHandler(
//            command: Command(value: "/select"),
//            description: "Select values",
//            flowAssembly: DatabaseSelectOperationFlowAssembly(app: app)
//        ),
        

    ]

    private let app: Application

    public init(app: Application) {
        self.app = app
    }

}
