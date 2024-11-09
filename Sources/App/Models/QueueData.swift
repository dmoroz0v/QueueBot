import Fluent
import Vapor

final class QueueData: Model, Content {
    static let schema = "queue_data"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "chatId")
    var chatId: Int64

    @Field(key: "value")
    var value: String

    init() { }

    init(id: UUID? = nil, chatId: Int64, value: String) {
        self.id = id
        self.chatId = chatId
        self.value = value
    }
}
