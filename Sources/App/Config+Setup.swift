import FluentProvider
import PostgreSQLProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(PostgreSQLProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(User.self)
        preparations.append(Track.self)
        preparations.append(Post.self)
        preparations.append(PostComment.self)
        preparations.append(PostReply.self)
        preparations.append(PostLike.self)
        preparations.append(Event.self)
        preparations.append(Setting.self)
        preparations.append(Image.self)
        preparations.append(ImageComment.self)
        preparations.append(ImageReply.self)
        preparations.append(ImageLike.self)
        preparations.append(Video.self)
        preparations.append(VideoComment.self)
        preparations.append(VideoReply.self)
        preparations.append(VideoLike.self)
        preparations.append(Review.self)
        preparations.append(ReviewComment.self)
        preparations.append(ReviewReply.self)
        preparations.append(UserToken.self)
        preparations.append(Advert.self)
        preparations.append(AdvertImage.self)
        preparations.append(AdvertMessage.self)
    }
}
