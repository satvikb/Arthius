
// generated with FlatBuffersSchemaEditor https://github.com/mzaks/FlatBuffersSchemaEditor

import Foundation

public final class Progress {
	public var progressData : [LevelProgressData] = []
	public init(){}
	public init(progressData: [LevelProgressData]){
		self.progressData = progressData
	}
}
public extension Progress {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> Progress? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? Progress
		}
		let _result = Progress()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		let offset_progressData : Offset? = reader.offset(objectOffset: objectOffset, propertyIndex: 0)
		let length_progressData = reader.vectorElementCount(vectorOffset: offset_progressData)
		if(length_progressData > 0){
			var index = 0
			_result.progressData.reserveCapacity(length_progressData)
			while index < length_progressData {
				if let element = LevelProgressData.create(reader, objectOffset: reader.vectorElementOffset(vectorOffset: offset_progressData, index: index)) {
					_result.progressData.append(element)
				}
				index += 1
			}
		}
		return _result
	}
}
public extension Progress {
	public static func makeProgress(data : Data,  cache : FlatBuffersReaderCache? = FlatBuffersReaderCache()) -> Progress? {
		let reader = FlatBuffersMemoryReader(data: data, cache: cache)
		return makeProgress(reader: reader)
	}
	public static func makeProgress(reader : FlatBuffersReader) -> Progress? {
		let objectOffset = reader.rootObjectOffset
		return create(reader, objectOffset : objectOffset)
	}
}

public extension Progress {
	public func encode(withBuilder builder : FlatBuffersBuilder) throws -> Void {
		let offset = try addToByteArray(builder)
		try builder.finish(offset: offset, fileIdentifier: nil)
	}
	public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
		let builder = FlatBuffersBuilder(options: options)
		try encode(withBuilder: builder)
		return builder.makeData
	}
}

public struct Progress_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
		guard let myOffset = myOffset, let reader = reader as? T else {
			return nil
		}
		self.reader = reader
		self.myOffset = myOffset
	}
	public init?(_ reader: T) {
		self.reader = reader
		guard let offest = reader.rootObjectOffset else {
			return nil
		}
		self.myOffset = offest
	}
	public var progressData : FlatBuffersTableVector<LevelProgressData_Direct<T>, T> {
		let offsetList = reader.offset(objectOffset: myOffset, propertyIndex: 0)
		return FlatBuffersTableVector(reader: self.reader, myOffset: offsetList)
	}
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : Progress_Direct<T>, t2 : Progress_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension Progress {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.options.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		var offset0 = Offset(0)
		if progressData.count > 0{
			var offsets = [Offset?](repeating: nil, count: progressData.count)
			var index = progressData.count - 1
			while(index >= 0){
				offsets[index] = try progressData[index].addToByteArray(builder)
				index -= 1
			}
			try builder.startVector(count: progressData.count, elementSize: MemoryLayout<Offset>.stride)
			index = progressData.count - 1
			while(index >= 0){
				try builder.insert(offset: offsets[index])
				index -= 1
			}
			offset0 = builder.endVector()
		}
		try builder.startObject(withPropertyCount: 1)
		if progressData.count > 0 {
			try builder.insert(offset: offset0, toStartedObjectAt: 0)
		}
		let myOffset =  try builder.endObject()
		if builder.options.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
public final class LevelProgressData {
	public var uuid : String? = nil
	public var completed : Bool = false
	public var locked : Bool = false
	public var stars : Int32 = 0
	public var time : Float32 = 0
	public var distance : Float32 = 0
	public init(){}
	public init(uuid: String?, completed: Bool, locked: Bool, stars: Int32, time: Float32, distance: Float32){
		self.uuid = uuid
		self.completed = completed
		self.locked = locked
		self.stars = stars
		self.time = time
		self.distance = distance
	}
}
public extension LevelProgressData {
	fileprivate static func create(_ reader : FlatBuffersReader, objectOffset : Offset?) -> LevelProgressData? {
		guard let objectOffset = objectOffset else {
			return nil
		}
		if  let cache = reader.cache,
			let o = cache.objectPool[objectOffset] {
			return o as? LevelProgressData
		}
		let _result = LevelProgressData()
		if let cache = reader.cache {
			cache.objectPool[objectOffset] = _result
		}
		_result.uuid = reader.stringBuffer(stringOffset: reader.offset(objectOffset: objectOffset, propertyIndex: 0))?§
		_result.completed = reader.get(objectOffset: objectOffset, propertyIndex: 1, defaultValue: false)
		_result.locked = reader.get(objectOffset: objectOffset, propertyIndex: 2, defaultValue: false)
		_result.stars = reader.get(objectOffset: objectOffset, propertyIndex: 3, defaultValue: 0)
		_result.time = reader.get(objectOffset: objectOffset, propertyIndex: 4, defaultValue: 0)
		_result.distance = reader.get(objectOffset: objectOffset, propertyIndex: 5, defaultValue: 0)
		return _result
	}
}
public struct LevelProgressData_Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
	fileprivate let reader : T
	fileprivate let myOffset : Offset
	public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset?) {
		guard let myOffset = myOffset, let reader = reader as? T else {
			return nil
		}
		self.reader = reader
		self.myOffset = myOffset
	}
	public var uuid : UnsafeBufferPointer<UInt8>? { get { return reader.stringBuffer(stringOffset: reader.offset(objectOffset: myOffset, propertyIndex:0)) } }
	public var completed : Bool { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 1, defaultValue: false) }
	}
	public var locked : Bool { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 2, defaultValue: false) }
	}
	public var stars : Int32 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 3, defaultValue: 0) }
	}
	public var time : Float32 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 4, defaultValue: 0) }
	}
	public var distance : Float32 { 
		get { return reader.get(objectOffset: myOffset, propertyIndex: 5, defaultValue: 0) }
	}
	public var hashValue: Int { return Int(myOffset) }
}
public func ==<T>(t1 : LevelProgressData_Direct<T>, t2 : LevelProgressData_Direct<T>) -> Bool {
	return t1.reader.isEqual(other: t2.reader) && t1.myOffset == t2.myOffset
}
public extension LevelProgressData {
	fileprivate func addToByteArray(_ builder : FlatBuffersBuilder) throws -> Offset {
		if builder.options.uniqueTables {
			if let myOffset = builder.cache[ObjectIdentifier(self)] {
				return myOffset
			}
		}
		let offset0 = try builder.insert(value: uuid)
		try builder.startObject(withPropertyCount: 6)
		try builder.insert(value : distance, defaultValue : 0, toStartedObjectAt: 5)
		try builder.insert(value : time, defaultValue : 0, toStartedObjectAt: 4)
		try builder.insert(value : stars, defaultValue : 0, toStartedObjectAt: 3)
		try builder.insert(value : locked, defaultValue : false, toStartedObjectAt: 2)
		try builder.insert(value : completed, defaultValue : false, toStartedObjectAt: 1)
		try builder.insert(offset: offset0, toStartedObjectAt: 0)
		let myOffset =  try builder.endObject()
		if builder.options.uniqueTables {
			builder.cache[ObjectIdentifier(self)] = myOffset
		}
		return myOffset
	}
}
