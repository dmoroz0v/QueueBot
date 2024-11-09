import Fluent

struct CreateQueueData: AsyncMigration {
    func prepare(on database: Fluent.Database) async throws {
        do {
            try await database.schema(QueueData.schema)
                .id()
                .field("chatId", .int64, .required)
                .field("value", .string, .required)
                .create()
        } catch {
            print(error)
            throw error
        }
    }

    func revert(on database: Fluent.Database) async throws {
        try await database.schema(QueueData.schema).delete()
    }
}
