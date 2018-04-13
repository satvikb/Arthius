//
//// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor
//
//import Foundation
//
//public enum LevelTextTriggers : Int8 {
//    case none = 0, start = 1, tap = 2, pressPlay = 3
//}
//public final class Level {
//    public var levelData : LevelData? = nil
//    public init(){}
//    public init(levelData: LevelData?){
//        self.levelData = levelData
//    }
//}
//public extension Level {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> Level? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? Level
//        }
//        let _result = Level()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.levelData = LevelData.create(reader, objectOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))
//        return _result
//    }
//}
//public extension Level {
//    public static func makeLevel(data : Data,  cache : FlatBuffersReaderCache? = FlatBuffersReaderCache()) -> Level? {
//        let reader = FlatBuffersMemoryReader(data: data, cache: cache)
//        return makeLevel(reader: reader)
//    }
//    public static func makeLevel(reader : FlatBuffersReader) -> Level? {
//        let objectOffset = reader.rootObjectOffset
//        return create(reader, objectOffset : objectOffset)
//    }
//}
//
//public extension Level {
//    public func encode(withBuilder builder : FlatBuffersBuilder) throws -> Void {
//        let offset = try addToByteArray(builder)
//        try builder.finish(offset: offset, fileIdentifier: nil)
//    }
//    public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
//        let builder = FlatBuffersBuilder(options: options)
//        try encode(withBuilder: builder)
//        return builder.makeData
//    }
//}
//
//public struct Level_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public init?(_ reader: T) {
//        self.reader = reader
//        guard let offest = reader.rootObjectOffset else {
//            return nil
//        }
//        self.myOffset = offest
//    }
//    public var levelData : LevelData_Direct<T>? { get {
//        if let offset = reader.offset(objectOffset: myOffset, propertyIndex: 0) {
//            return LevelData_Direct(reader: reader, myOffset: offset)
//        }
//        return nil
//    } }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : Level_Direct<T>, t2 : Level_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension Level {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        let offset0 = try levelData?.addToByteArray(builder) ?? 0
//        try builder.startObject(withPropertyCount: 1)
//        if levelData != nil {
//            try builder.insert(offset: offset0, toStartedObjectAt: 0)
//        }
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class LevelData {
//    public var levelMetadata : LevelMetadata? = nil
//    public var texts : [LevelText] = []
//    public var propFrame : Rect? = nil
//    public var endPoints : [EndData] = []
//    public var lineData : [LineData] = []
//    public var gravityWells : [GravityWellData] = []
//    public var colorBoxData : [ColorBoxData] = []
//    public var rockData : [RockData] = []
//    public var antiGravityZones : [AntiGravityData] = []
//    public init(){}
//    public init(levelMetadata: LevelMetadata?, texts: [LevelText], propFrame: Rect?, endPoints: [EndData], lineData: [LineData], gravityWells: [GravityWellData], colorBoxData: [ColorBoxData], rockData: [RockData], antiGravityZones: [AntiGravityData]){
//        self.levelMetadata = levelMetadata
//        self.texts = texts
//        self.propFrame = propFrame
//        self.endPoints = endPoints
//        self.lineData = lineData
//        self.gravityWells = gravityWells
//        self.colorBoxData = colorBoxData
//        self.rockData = rockData
//        self.antiGravityZones = antiGravityZones
//    }
//}
//public extension LevelData {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> LevelData? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? LevelData
//        }
//        let _result = LevelData()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.levelMetadata = LevelMetadata.create(reader, objectOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))
//        let offset_texts : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 1)
//        let length_texts = reader.vectorElementCount(vectorOffset: offset_texts)
//        if(length_texts > 0){
//            var index = 0
//            _result.texts.reserveCapacity(length_texts)
//            while index < length_texts {
//                if let element = LevelText.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_texts, index: index)) {
//                    _result.texts.append(element)
//                }
//                index += 1
//            }
//        }
//        _result.propFrame = reader.get(objectOffset: objectOffset, propertyIndex: 2)
//        let offset_endPoints : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 3)
//        let length_endPoints = reader.vectorElementCount(vectorOffset: offset_endPoints)
//        if(length_endPoints > 0){
//            var index = 0
//            _result.endPoints.reserveCapacity(length_endPoints)
//            while index < length_endPoints {
//                if let element = EndData.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_endPoints, index: index)) {
//                    _result.endPoints.append(element)
//                }
//                index += 1
//            }
//        }
//        let offset_lineData : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 4)
//        let length_lineData = reader.vectorElementCount(vectorOffset: offset_lineData)
//        if(length_lineData > 0){
//            var index = 0
//            _result.lineData.reserveCapacity(length_lineData)
//            while index < length_lineData {
//                if let element = LineData.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_lineData, index: index)) {
//                    _result.lineData.append(element)
//                }
//                index += 1
//            }
//        }
//        let offset_gravityWells : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 5)
//        let length_gravityWells = reader.vectorElementCount(vectorOffset: offset_gravityWells)
//        if(length_gravityWells > 0){
//            var index = 0
//            _result.gravityWells.reserveCapacity(length_gravityWells)
//            while index < length_gravityWells {
//                if let element = GravityWellData.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_gravityWells, index: index)) {
//                    _result.gravityWells.append(element)
//                }
//                index += 1
//            }
//        }
//        let offset_colorBoxData : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 6)
//        let length_colorBoxData = reader.vectorElementCount(vectorOffset: offset_colorBoxData)
//        if(length_colorBoxData > 0){
//            var index = 0
//            _result.colorBoxData.reserveCapacity(length_colorBoxData)
//            while index < length_colorBoxData {
//                if let element = ColorBoxData.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_colorBoxData, index: index)) {
//                    _result.colorBoxData.append(element)
//                }
//                index += 1
//            }
//        }
//        let offset_rockData : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 7)
//        let length_rockData = reader.vectorElementCount(vectorOffset: offset_rockData)
//        if(length_rockData > 0){
//            var index = 0
//            _result.rockData.reserveCapacity(length_rockData)
//            while index < length_rockData {
//                if let element = RockData.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_rockData, index: index)) {
//                    _result.rockData.append(element)
//                }
//                index += 1
//            }
//        }
//        let offset_antiGravityZones : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 8)
//        let length_antiGravityZones = reader.vectorElementCount(vectorOffset: offset_antiGravityZones)
//        if(length_antiGravityZones > 0){
//            var index = 0
//            _result.antiGravityZones.reserveCapacity(length_antiGravityZones)
//            while index < length_antiGravityZones {
//                if let element = AntiGravityData.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_antiGravityZones, index: index)) {
//                    _result.antiGravityZones.append(element)
//                }
//                index += 1
//            }
//        }
//        return _result
//    }
//}
//public struct LevelData_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var levelMetadata : LevelMetadata_Direct<T>? { get {
//        if let offset = reader.offset(objectOffset: myOffset, propertyIndex: 0) {
//            return LevelMetadata_Direct(reader: reader, myOffset: offset)
//        }
//        return nil
//    } }
//    public var texts : FlatBuffersTableVector<LevelText_Direct<T>, T> {
//        let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 1)
//        return FlatBuffersTableVector(reader: self.reader, myOffset: offsetList)
//    }
//    public var propFrame : Rect? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 2)}
//    }
//    public var endPoints : FlatBuffersTableVector<EndData_Direct<T>, T> {
//        let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 3)
//        return FlatBuffersTableVector(reader: self.reader, myOffset: offsetList)
//    }
//    public var lineData : FlatBuffersTableVector<LineData_Direct<T>, T> {
//        let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 4)
//        return FlatBuffersTableVector(reader: self.reader, myOffset: offsetList)
//    }
//    public var gravityWells : FlatBuffersTableVector<GravityWellData_Direct<T>, T> {
//        let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 5)
//        return FlatBuffersTableVector(reader: self.reader, myOffset: offsetList)
//    }
//    public var colorBoxData : FlatBuffersTableVector<ColorBoxData_Direct<T>, T> {
//        let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 6)
//        return FlatBuffersTableVector(reader: self.reader, myOffset: offsetList)
//    }
//    public var rockData : FlatBuffersTableVector<RockData_Direct<T>, T> {
//        let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 7)
//        return FlatBuffersTableVector(reader: self.reader, myOffset: offsetList)
//    }
//    public var antiGravityZones : FlatBuffersTableVector<AntiGravityData_Direct<T>, T> {
//        let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 8)
//        return FlatBuffersTableVector(reader: self.reader, myOffset: offsetList)
//    }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : LevelData_Direct<T>, t2 : LevelData_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension LevelData {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        var offset8 = Offset(0)
//        if antiGravityZones.count > 0{
//            var offsets = [Offset?](repeating: nil, count: antiGravityZones.count)
//            var index = antiGravityZones.count - 1
//            while(index >= 0){
//                offsets[index] = try antiGravityZones[index].addToByteArray(builder)
//                index -= 1
//            }
//            try builder.startVector(count: antiGravityZones.count, elementSize: MemoryLayout<Offset>.stride)
//            index = antiGravityZones.count - 1
//            while(index >= 0){
//                try builder.insert(offset: offsets[index])
//                index -= 1
//            }
//            offset8 = builder.endVector()
//        }
//        var offset7 = Offset(0)
//        if rockData.count > 0{
//            var offsets = [Offset?](repeating: nil, count: rockData.count)
//            var index = rockData.count - 1
//            while(index >= 0){
//                offsets[index] = try rockData[index].addToByteArray(builder)
//                index -= 1
//            }
//            try builder.startVector(count: rockData.count, elementSize: MemoryLayout<Offset>.stride)
//            index = rockData.count - 1
//            while(index >= 0){
//                try builder.insert(offset: offsets[index])
//                index -= 1
//            }
//            offset7 = builder.endVector()
//        }
//        var offset6 = Offset(0)
//        if colorBoxData.count > 0{
//            var offsets = [Offset?](repeating: nil, count: colorBoxData.count)
//            var index = colorBoxData.count - 1
//            while(index >= 0){
//                offsets[index] = try colorBoxData[index].addToByteArray(builder)
//                index -= 1
//            }
//            try builder.startVector(count: colorBoxData.count, elementSize: MemoryLayout<Offset>.stride)
//            index = colorBoxData.count - 1
//            while(index >= 0){
//                try builder.insert(offset: offsets[index])
//                index -= 1
//            }
//            offset6 = builder.endVector()
//        }
//        var offset5 = Offset(0)
//        if gravityWells.count > 0{
//            var offsets = [Offset?](repeating: nil, count: gravityWells.count)
//            var index = gravityWells.count - 1
//            while(index >= 0){
//                offsets[index] = try gravityWells[index].addToByteArray(builder)
//                index -= 1
//            }
//            try builder.startVector(count: gravityWells.count, elementSize: MemoryLayout<Offset>.stride)
//            index = gravityWells.count - 1
//            while(index >= 0){
//                try builder.insert(offset: offsets[index])
//                index -= 1
//            }
//            offset5 = builder.endVector()
//        }
//        var offset4 = Offset(0)
//        if lineData.count > 0{
//            var offsets = [Offset?](repeating: nil, count: lineData.count)
//            var index = lineData.count - 1
//            while(index >= 0){
//                offsets[index] = try lineData[index].addToByteArray(builder)
//                index -= 1
//            }
//            try builder.startVector(count: lineData.count, elementSize: MemoryLayout<Offset>.stride)
//            index = lineData.count - 1
//            while(index >= 0){
//                try builder.insert(offset: offsets[index])
//                index -= 1
//            }
//            offset4 = builder.endVector()
//        }
//        var offset3 = Offset(0)
//        if endPoints.count > 0{
//            var offsets = [Offset?](repeating: nil, count: endPoints.count)
//            var index = endPoints.count - 1
//            while(index >= 0){
//                offsets[index] = try endPoints[index].addToByteArray(builder)
//                index -= 1
//            }
//            try builder.startVector(count: endPoints.count, elementSize: MemoryLayout<Offset>.stride)
//            index = endPoints.count - 1
//            while(index >= 0){
//                try builder.insert(offset: offsets[index])
//                index -= 1
//            }
//            offset3 = builder.endVector()
//        }
//        var offset1 = Offset(0)
//        if texts.count > 0{
//            var offsets = [Offset?](repeating: nil, count: texts.count)
//            var index = texts.count - 1
//            while(index >= 0){
//                offsets[index] = try texts[index].addToByteArray(builder)
//                index -= 1
//            }
//            try builder.startVector(count: texts.count, elementSize: MemoryLayout<Offset>.stride)
//            index = texts.count - 1
//            while(index >= 0){
//                try builder.insert(offset: offsets[index])
//                index -= 1
//            }
//            offset1 = builder.endVector()
//        }
//        let offset0 = try levelMetadata?.addToByteArray(builder) ?? 0
//        try builder.startObject(withPropertyCount: 9)
//        if antiGravityZones.count > 0 {
//            try builder.insert(offset: offset8, toStartedObjectAt: 8)
//        }
//        if rockData.count > 0 {
//            try builder.insert(offset: offset7, toStartedObjectAt: 7)
//        }
//        if colorBoxData.count > 0 {
//            try builder.insert(offset: offset6, toStartedObjectAt: 6)
//        }
//        if gravityWells.count > 0 {
//            try builder.insert(offset: offset5, toStartedObjectAt: 5)
//        }
//        if lineData.count > 0 {
//            try builder.insert(offset: offset4, toStartedObjectAt: 4)
//        }
//        if endPoints.count > 0 {
//            try builder.insert(offset: offset3, toStartedObjectAt: 3)
//        }
//        if let propFrame = propFrame {
//            builder.insert(value: propFrame)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 2)
//        }
//        if texts.count > 0 {
//            try builder.insert(offset: offset1, toStartedObjectAt: 1)
//        }
//        if levelMetadata != nil {
//            try builder.insert(offset: offset0, toStartedObjectAt: 0)
//        }
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class LevelText {
//    public var id : Int32 = 0
//    public var text : String? = nil
//    public var triggerOn : LevelTextTriggers? = LevelTextTriggers.none
//    public var nextText : Int32 = 0
//    public var animateTime : Float32 = 0
//    public var animateIn : Bool = false
//    public var animateOut : Bool = false
//    public var propFrame : Rect? = nil
//    public var fontColor : Color? = nil
//    public var fontSize : Int32 = 0
//    public init(){}
//    public init(id: Int32, text: String?, triggerOn: LevelTextTriggers?, nextText: Int32, animateTime: Float32, animateIn: Bool, animateOut: Bool, propFrame: Rect?, fontColor: Color?, fontSize: Int32){
//        self.id = id
//        self.text = text
//        self.triggerOn = triggerOn
//        self.nextText = nextText
//        self.animateTime = animateTime
//        self.animateIn = animateIn
//        self.animateOut = animateOut
//        self.propFrame = propFrame
//        self.fontColor = fontColor
//        self.fontSize = fontSize
//    }
//}
//public extension LevelText {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> LevelText? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? LevelText
//        }
//        let _result = LevelText()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.id = reader.get(objectOffset: objectOffset, propertyIndex: 0, defaultValue: 0)
//        _result.text = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 1))?§
//        _result.triggerOn = LevelTextTriggers(rawValue: reader.get(objectOffset: objectOffset, propertyIndex: 2, defaultValue: LevelTextTriggers.none.rawValue))
//        _result.nextText = reader.get(objectOffset: objectOffset, propertyIndex: 3, defaultValue: 0)
//        _result.animateTime = reader.get(objectOffset: objectOffset, propertyIndex: 4, defaultValue: 0)
//        _result.animateIn = reader.get(objectOffset: objectOffset, propertyIndex: 5, defaultValue: false)
//        _result.animateOut = reader.get(objectOffset: objectOffset, propertyIndex: 6, defaultValue: false)
//        _result.propFrame = reader.get(objectOffset: objectOffset, propertyIndex: 7)
//        _result.fontColor = reader.get(objectOffset: objectOffset, propertyIndex: 8)
//        _result.fontSize = reader.get(objectOffset: objectOffset, propertyIndex: 9, defaultValue: 0)
//        return _result
//    }
//}
//public struct LevelText_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var id : Int32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 0, defaultValue: 0) }
//    }
//    public var text : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:1)) } }
//    public var triggerOn : LevelTextTriggers? {
//        get { return LevelTextTriggers(rawValue: reader.get(objectOffset: myOffset, propertyIndex: 2, defaultValue: LevelTextTriggers.none.rawValue)) }
//    }
//    public var nextText : Int32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 3, defaultValue: 0) }
//    }
//    public var animateTime : Float32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 4, defaultValue: 0) }
//    }
//    public var animateIn : Bool {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 5, defaultValue: false) }
//    }
//    public var animateOut : Bool {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 6, defaultValue: false) }
//    }
//    public var propFrame : Rect? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 7)}
//    }
//    public var fontColor : Color? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 8)}
//    }
//    public var fontSize : Int32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 9, defaultValue: 0) }
//    }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : LevelText_Direct<T>, t2 : LevelText_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension LevelText {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        let offset1 = try builder.insert(value: text)
//        try builder.startObject(withPropertyCount: 10)
//        try builder.insert(value : fontSize, defaultValue : 0, toStartedObjectAt: 9)
//        if let fontColor = fontColor {
//            builder.insert(value: fontColor)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 8)
//        }
//        if let propFrame = propFrame {
//            builder.insert(value: propFrame)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 7)
//        }
//        try builder.insert(value : animateOut, defaultValue : false, toStartedObjectAt: 6)
//        try builder.insert(value : animateIn, defaultValue : false, toStartedObjectAt: 5)
//        try builder.insert(value : animateTime, defaultValue : 0, toStartedObjectAt: 4)
//        try builder.insert(value : nextText, defaultValue : 0, toStartedObjectAt: 3)
//        try builder.insert(value : triggerOn?.rawValue ?? 0, defaultValue : 0, toStartedObjectAt: 2)
//        try builder.insert(offset: offset1, toStartedObjectAt: 1)
//        try builder.insert(value : id, defaultValue : 0, toStartedObjectAt: 0)
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class LevelMetadata {
//    public var levelUUID : String? = nil
//    public var levelNumber : Int32 = 0
//    public var levelName : String? = nil
//    public var levelVersion : String? = nil
//    public var levelAuthor : String? = nil
//    public init(){}
//    public init(levelUUID: String?, levelNumber: Int32, levelName: String?, levelVersion: String?, levelAuthor: String?){
//        self.levelUUID = levelUUID
//        self.levelNumber = levelNumber
//        self.levelName = levelName
//        self.levelVersion = levelVersion
//        self.levelAuthor = levelAuthor
//    }
//}
//public extension LevelMetadata {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> LevelMetadata? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? LevelMetadata
//        }
//        let _result = LevelMetadata()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.levelUUID = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
//        _result.levelNumber = reader.get(objectOffset: objectOffset, propertyIndex: 1, defaultValue: 0)
//        _result.levelName = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 2))?§
//        _result.levelVersion = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 3))?§
//        _result.levelAuthor = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 4))?§
//        return _result
//    }
//}
//public struct LevelMetadata_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var levelUUID : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
//    public var levelNumber : Int32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 1, defaultValue: 0) }
//    }
//    public var levelName : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:2)) } }
//    public var levelVersion : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:3)) } }
//    public var levelAuthor : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:4)) } }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : LevelMetadata_Direct<T>, t2 : LevelMetadata_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension LevelMetadata {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        let offset4 = try builder.insert(value: levelAuthor)
//        let offset3 = try builder.insert(value: levelVersion)
//        let offset2 = try builder.insert(value: levelName)
//        let offset0 = try builder.insert(value: levelUUID)
//        try builder.startObject(withPropertyCount: 5)
//        try builder.insert(offset: offset4, toStartedObjectAt: 4)
//        try builder.insert(offset: offset3, toStartedObjectAt: 3)
//        try builder.insert(offset: offset2, toStartedObjectAt: 2)
//        try builder.insert(value : levelNumber, defaultValue : 0, toStartedObjectAt: 1)
//        try builder.insert(offset: offset0, toStartedObjectAt: 0)
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class GravityWellData {
//    public var position : Point? = nil
//    public var mass : Float32 = 0
//    public var coreDiameter : Float32 = 0
//    public var areaOfEffectDiameter : Float32 = 0
//    public init(){}
//    public init(position: Point?, mass: Float32, coreDiameter: Float32, areaOfEffectDiameter: Float32){
//        self.position = position
//        self.mass = mass
//        self.coreDiameter = coreDiameter
//        self.areaOfEffectDiameter = areaOfEffectDiameter
//    }
//}
//public extension GravityWellData {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> GravityWellData? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? GravityWellData
//        }
//        let _result = GravityWellData()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.position = reader.get(objectOffset: objectOffset, propertyIndex: 0)
//        _result.mass = reader.get(objectOffset: objectOffset, propertyIndex: 1, defaultValue: 0)
//        _result.coreDiameter = reader.get(objectOffset: objectOffset, propertyIndex: 2, defaultValue: 0)
//        _result.areaOfEffectDiameter = reader.get(objectOffset: objectOffset, propertyIndex: 3, defaultValue: 0)
//        return _result
//    }
//}
//public struct GravityWellData_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var position : Point? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 0)}
//    }
//    public var mass : Float32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 1, defaultValue: 0) }
//    }
//    public var coreDiameter : Float32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 2, defaultValue: 0) }
//    }
//    public var areaOfEffectDiameter : Float32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 3, defaultValue: 0) }
//    }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : GravityWellData_Direct<T>, t2 : GravityWellData_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension GravityWellData {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        try builder.startObject(withPropertyCount: 4)
//        try builder.insert(value : areaOfEffectDiameter, defaultValue : 0, toStartedObjectAt: 3)
//        try builder.insert(value : coreDiameter, defaultValue : 0, toStartedObjectAt: 2)
//        try builder.insert(value : mass, defaultValue : 0, toStartedObjectAt: 1)
//        if let position = position {
//            builder.insert(value: position)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 0)
//        }
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class ColorBoxData {
//    public var frame : Rect? = nil
//    public var rotation : Float32 = 0
//    public var leftColor : Color? = nil
//    public var rightColor : Color? = nil
//    public var backgroundColor : Color? = nil
//    public var middlePropWidth : Float32 = 0
//    public init(){}
//    public init(frame: Rect?, rotation: Float32, leftColor: Color?, rightColor: Color?, backgroundColor: Color?, middlePropWidth: Float32){
//        self.frame = frame
//        self.rotation = rotation
//        self.leftColor = leftColor
//        self.rightColor = rightColor
//        self.backgroundColor = backgroundColor
//        self.middlePropWidth = middlePropWidth
//    }
//}
//public extension ColorBoxData {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> ColorBoxData? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? ColorBoxData
//        }
//        let _result = ColorBoxData()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.frame = reader.get(objectOffset: objectOffset, propertyIndex: 0)
//        _result.rotation = reader.get(objectOffset: objectOffset, propertyIndex: 1, defaultValue: 0)
//        _result.leftColor = reader.get(objectOffset: objectOffset, propertyIndex: 2)
//        _result.rightColor = reader.get(objectOffset: objectOffset, propertyIndex: 3)
//        _result.backgroundColor = reader.get(objectOffset: objectOffset, propertyIndex: 4)
//        _result.middlePropWidth = reader.get(objectOffset: objectOffset, propertyIndex: 5, defaultValue: 0)
//        return _result
//    }
//}
//public struct ColorBoxData_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var frame : Rect? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 0)}
//    }
//    public var rotation : Float32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 1, defaultValue: 0) }
//    }
//    public var leftColor : Color? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 2)}
//    }
//    public var rightColor : Color? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 3)}
//    }
//    public var backgroundColor : Color? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 4)}
//    }
//    public var middlePropWidth : Float32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 5, defaultValue: 0) }
//    }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : ColorBoxData_Direct<T>, t2 : ColorBoxData_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension ColorBoxData {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        try builder.startObject(withPropertyCount: 6)
//        try builder.insert(value : middlePropWidth, defaultValue : 0, toStartedObjectAt: 5)
//        if let backgroundColor = backgroundColor {
//            builder.insert(value: backgroundColor)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 4)
//        }
//        if let rightColor = rightColor {
//            builder.insert(value: rightColor)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 3)
//        }
//        if let leftColor = leftColor {
//            builder.insert(value: leftColor)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 2)
//        }
//        try builder.insert(value : rotation, defaultValue : 0, toStartedObjectAt: 1)
//        if let frame = frame {
//            builder.insert(value: frame)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 0)
//        }
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class LineData {
//    public var startPosition : Point? = nil
//    public var startVelocity : Vector? = nil
//    public var startColor : Color? = nil
//    public var startThickness : Float32 = 0
//    public init(){}
//    public init(startPosition: Point?, startVelocity: Vector?, startColor: Color?, startThickness: Float32){
//        self.startPosition = startPosition
//        self.startVelocity = startVelocity
//        self.startColor = startColor
//        self.startThickness = startThickness
//    }
//}
//public extension LineData {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> LineData? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? LineData
//        }
//        let _result = LineData()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.startPosition = reader.get(objectOffset: objectOffset, propertyIndex: 0)
//        _result.startVelocity = reader.get(objectOffset: objectOffset, propertyIndex: 1)
//        _result.startColor = reader.get(objectOffset: objectOffset, propertyIndex: 2)
//        _result.startThickness = reader.get(objectOffset: objectOffset, propertyIndex: 3, defaultValue: 0)
//        return _result
//    }
//}
//public struct LineData_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var startPosition : Point? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 0)}
//    }
//    public var startVelocity : Vector? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 1)}
//    }
//    public var startColor : Color? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 2)}
//    }
//    public var startThickness : Float32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 3, defaultValue: 0) }
//    }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : LineData_Direct<T>, t2 : LineData_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension LineData {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        try builder.startObject(withPropertyCount: 4)
//        try builder.insert(value : startThickness, defaultValue : 0, toStartedObjectAt: 3)
//        if let startColor = startColor {
//            builder.insert(value: startColor)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 2)
//        }
//        if let startVelocity = startVelocity {
//            builder.insert(value: startVelocity)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 1)
//        }
//        if let startPosition = startPosition {
//            builder.insert(value: startPosition)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 0)
//        }
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class RockData {
//    public var position : Point? = nil
//    public var diameter : Float32 = 0
//    public init(){}
//    public init(position: Point?, diameter: Float32){
//        self.position = position
//        self.diameter = diameter
//    }
//}
//public extension RockData {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> RockData? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? RockData
//        }
//        let _result = RockData()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.position = reader.get(objectOffset: objectOffset, propertyIndex: 0)
//        _result.diameter = reader.get(objectOffset: objectOffset, propertyIndex: 1, defaultValue: 0)
//        return _result
//    }
//}
//public struct RockData_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var position : Point? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 0)}
//    }
//    public var diameter : Float32 {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 1, defaultValue: 0) }
//    }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : RockData_Direct<T>, t2 : RockData_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension RockData {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        try builder.startObject(withPropertyCount: 2)
//        try builder.insert(value : diameter, defaultValue : 0, toStartedObjectAt: 1)
//        if let position = position {
//            builder.insert(value: position)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 0)
//        }
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class AntiGravityData {
//    public var frame : Rect? = nil
//    public var color : Color? = nil
//    public init(){}
//    public init(frame: Rect?, color: Color?){
//        self.frame = frame
//        self.color = color
//    }
//}
//public extension AntiGravityData {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> AntiGravityData? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? AntiGravityData
//        }
//        let _result = AntiGravityData()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.frame = reader.get(objectOffset: objectOffset, propertyIndex: 0)
//        _result.color = reader.get(objectOffset: objectOffset, propertyIndex: 1)
//        return _result
//    }
//}
//public struct AntiGravityData_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var frame : Rect? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 0)}
//    }
//    public var color : Color? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 1)}
//    }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : AntiGravityData_Direct<T>, t2 : AntiGravityData_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension AntiGravityData {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        try builder.startObject(withPropertyCount: 2)
//        if let color = color {
//            builder.insert(value: color)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 1)
//        }
//        if let frame = frame {
//            builder.insert(value: frame)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 0)
//        }
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public final class EndData {
//    public var frame : Rect? = nil
//    public var color : Color? = nil
//    public init(){}
//    public init(frame: Rect?, color: Color?){
//        self.frame = frame
//        self.color = color
//    }
//}
//public extension EndData {
//    fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> EndData? {
//        guard let objectOffset = objectOffset else {
//            return nil
//        }
//        if  let cache = reader.cache,
//            let o = cache.objectPool[objectOffset] {
//            return o as? EndData
//        }
//        let _result = EndData()
//        if let cache = reader.cache {
//            cache.objectPool[objectOffset] = _result
//        }
//        _result.frame = reader.get(objectOffset: objectOffset, propertyIndex: 0)
//        _result.color = reader.get(objectOffset: objectOffset, propertyIndex: 1)
//        return _result
//    }
//}
//public struct EndData_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
//    fileprivate let reader : T
//    fileprivate let myOffset : Offset
//    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
//        guard let myOffset = myOffset, let reader = reader as? T else {
//            return nil
//        }
//        self.reader = reader
//        self.myOffset = myOffset
//    }
//    public var frame : Rect? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 0)}
//    }
//    public var color : Color? {
//        get { return reader.get(objectOffset: myOffset, propertyIndex: 1)}
//    }
//    public var hashValue: Int { return Int(myOffset) }
//}
//public func ==<T>(t1 : EndData_Direct<T>, t2 : EndData_Direct<T>) -> Bool {
//    return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
//}
//public extension EndData {
//    fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
//        if builder.options.uniqueTables {
//            if let myOffset = builder.cache[ObjectIdentifier(self)] {
//                return myOffset
//            }
//        }
//        try builder.startObject(withPropertyCount: 2)
//        if let color = color {
//            builder.insert(value: color)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 1)
//        }
//        if let frame = frame {
//            builder.insert(value: frame)
//            try builder.insertCurrentOffsetAsProperty(toStartedObjectAt: 0)
//        }
//        let myOffset =  try builder.endObject()
//        if builder.options.uniqueTables {
//            builder.cache[ObjectIdentifier(self)] = myOffset
//        }
//        return myOffset
//    }
//}
//public struct Color : Scalar {
//    public let r : Float32
//    public let g : Float32
//    public let b : Float32
//    public let a : Float32
//}
//public func ==(v1:Color, v2:Color) -> Bool {
//    return  v1.r==v2.r &&  v1.g==v2.g &&  v1.b==v2.b &&  v1.a==v2.a
//}
//public struct Point : Scalar {
//    public let x : Float32
//    public let y : Float32
//}
//public func ==(v1:Point, v2:Point) -> Bool {
//    return  v1.x==v2.x &&  v1.y==v2.y
//}
//public struct Vector : Scalar {
//    public let dx : Float32
//    public let dy : Float32
//}
//public func ==(v1:Vector, v2:Vector) -> Bool {
//    return  v1.dx==v2.dx &&  v1.dy==v2.dy
//}
//public struct Rect : Scalar {
//    public let x : Float32
//    public let y : Float32
//    public let width : Float32
//    public let height : Float32
//}
//public func ==(v1:Rect, v2:Rect) -> Bool {
//    return  v1.x==v2.x &&  v1.y==v2.y &&  v1.width==v2.width &&  v1.height==v2.height
//}
