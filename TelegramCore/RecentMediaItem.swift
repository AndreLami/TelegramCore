import Foundation
#if os(macOS)
    import PostboxMac
#else
    import Postbox
#endif

public struct RecentMediaItemId {
    public let rawValue: MemoryBuffer
    public let mediaId: MediaId
    
    init(_ rawValue: MemoryBuffer) {
        self.rawValue = rawValue
        assert(rawValue.length == 4 + 8)
        var mediaIdNamespace: Int32 = 0
        var mediaIdId: Int64 = 0
        memcpy(&mediaIdNamespace, rawValue.memory, 4)
        memcpy(&mediaIdId, rawValue.memory.advanced(by: 4), 8)
        self.mediaId = MediaId(namespace: mediaIdNamespace, id: mediaIdId)
    }
    
    init(_ mediaId: MediaId) {
        self.mediaId = mediaId
        var mediaIdNamespace: Int32 = mediaId.namespace
        var mediaIdId: Int64 = mediaId.id
        self.rawValue = MemoryBuffer(memory: malloc(4 + 8)!, capacity: 4 + 8, length: 4 + 8, freeWhenDone: true)
        memcpy(self.rawValue.memory, &mediaIdNamespace, 4)
        memcpy(self.rawValue.memory.advanced(by: 4), &mediaIdId, 8)
    }
}

public final class RecentMediaItem: OrderedItemListEntryContents {
    public let media: Media
    
    init(_ media: Media) {
        self.media = media
    }
    
    public init(decoder: Decoder) {
        self.media = decoder.decodeObjectForKey("m") as! Media
    }
    
    public func encode(_ encoder: Encoder) {
        encoder.encodeObject(self.media, forKey: "m")
    }
}