import Foundation

extension Array {
    /// Split an array of d dimensions
    ///
    ///     let arr = Array(1...10)
    ///     arr.chunked(by: shape[5])
    fileprivate func chunked(by size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    /// Expand dimensions on OUTER layer
    ///
    ///     let arr = [[4,3,5],[1,0,0]]
    ///     print(arr.expandDim())  # [[[4,3,5],[1,0,0]]]
    func expandDim() -> [[Element]] {
        return [self]
    }
}

typealias Arr1DInt = [Int]
typealias Arr2DInt = [[Int]]
typealias Arr3DInt = [[[Int]]]
typealias Arr4DInt = [[[[Int]]]]
typealias Arr5DInt = [[[[[Int]]]]]

typealias Arr1DFloat = [Float32]
typealias Arr2DFloat = [[Float32]]
typealias Arr3DFloat = [[[Float32]]]
typealias Arr4DFloat = [[[[Float32]]]]
typealias Arr5DFloat = [[[[[Float32]]]]]

typealias Tuple2DInt = (Int,Int)
typealias Tuple3DInt = (Int,Int,Int)
typealias Tuple4DInt = (Int,Int,Int,Int)
typealias Tuple5DInt = (Int,Int,Int,Int,Int)

/// Reshape a 1D NumSwift tensor to a 2D NumSwift tensor
func reshape_1_to_2(_ arr: Arr1DInt, shape: Tuple2DInt) -> Arr2DInt {
    return arr.chunked(by: shape.1)
}

/// Reshape a 1D NumSwift tensor to a 3D NumSwift tensor
func reshape_1_to_3(_ arr: Arr1DInt, shape: Tuple3DInt) -> Arr3DInt {
    return arr.chunked(by: shape.2)
        .chunked(by: shape.1)
}

/// Reshape a 1D NumSwift tensor to a 4D NumSwift tensor
func reshape_1_to_4(_ arr: Arr1DInt, shape: Tuple4DInt) -> Arr4DInt {
    return arr.chunked(by: shape.3)
        .chunked(by: shape.2)
        .chunked(by: shape.1)
}

/// Reshape a 1D NumSwift tensor to a 5D NumSwift tensor
func reshape_1_to_5(_ arr: Arr1DInt, shape: Tuple5DInt) -> Arr5DInt {
    return arr.chunked(by: shape.4)
        .chunked(by: shape.3)
        .chunked(by: shape.2)
        .chunked(by: shape.1)
}

/// Create and manipulate 1D, 2D, 3D, 4D and 5D tensors.
///
/// Naïve and non-optimised tensor manipulation whose underlying operations are simply `Array` operations. Hoping to create something like Python's NumPy (who am I kidding 😆?). `NumSwift` supports printing of tensors.
///
/// - Important: Only supports 1D and 2D operations
///
/// # Ways to initialise
///
///     let a = NumSwift.ones((1,4,2))
///     // array([[[1, 1],
///     //         [1, 1],
///     //         [1, 1],
///     //         [1, 1]]])
///
///     let b = NumSwift.zeros((3,9))
///     // array([[0, 0, 0, 0, 0, 0, 0, 0, 0],
///     //        [0, 0, 0, 0, 0, 0, 0, 0, 0],
///     //        [0, 0, 0, 0, 0, 0, 0, 0, 0]])
///
///     let c = NumSwift([1,2,3,4], shape: (2,2))
///     // array([[1, 2],
///     //        [3, 4]])
///
///     let d = NumSwift.arange(7)
///     // array([0, 1, 2, 3, 4, 5, 6])
///
///     let e = NumSwift.arange(3,6)
///     // array([3, 4, 5])
///
///     let f = NumSwift.randint(1,10,(2,5))
///     // array([[5, 10, 1, 6, 4],
///     //        [4, 2, 10, 6, 9]])
///
///     let g = NumSwift([2,4])
///     // array([2, 4])
///
/// # Operations
///
/// Element-wise addition
///
///     let add = a + b
///     print(add)
///
/// Element-wise multiplication
///
///     let mul = a * b
///     print(mul)
///
/// Broadcasting
///
///     let bcast1 = a + 1
///     let bcast2 = b * 8
///     print(bcast1)
///     print(bcast2)
///
/// Operator overloading:
///
/// - addition, `+`
/// - subtraction, `-`
/// - multiplication, `*`
///
struct NumSwift: CustomStringConvertible {
    
    /// 1D INTEGER arrays for now
    ///
    /// - ToDo:
    ///     - Double type
    var arr1D: Arr1DInt = [0]
    var arr2D: Arr2DInt = [[0]]
    var arr3D: Arr3DInt = [[[0]]]
    var arr4D: Arr4DInt = [[[[0]]]]
    var arr5D: Arr5DInt = [[[[[0]]]]]
    
    /// Shape of array
    let shape_: [Int]
    
    /// No. of dimensions of array
    let dim: Int
    
    /// Initialise a 1D, 2D, 3D, 4D or 5D `NumSwift` tensor
    init<Tuple>(_ object: Arr1DInt, shape: Tuple) {
        self.arr1D = object
        self.shape_ = [0]
        self.dim = Mirror(reflecting: shape).children.count
        if self.dim == 2 {
            self.arr2D = reshape_1_to_2(object, shape: shape as! (Int,Int))
        } else if self.dim == 3 {
            self.arr3D = reshape_1_to_3(object, shape: shape as! (Int,Int,Int))
        } else if self.dim == 4 {
            self.arr4D = reshape_1_to_4(object, shape: shape as! (Int,Int,Int,Int))
        } else if self.dim == 5 {
            self.arr5D = reshape_1_to_5(object, shape: shape as! (Int,Int,Int,Int,Int))
        } else {
            print("Not supported")
        }
    }
    
    /// Initialise a 1D `NumSwift` tensor
    ///
    ///     let ns = NumSwift([1,2,3])
    init(_ object: Arr1DInt) {
        self.arr1D = object
        self.shape_ = [2,2]
        self.dim = 1
    }
    
    /// Initialise a 2D `NumSwift` tensor
    ///
    ///     let ns = NumSwift([[1,2,3],[4,5,6]])
    init(_ object: Arr2DInt) {
        self.arr2D = object
        self.shape_ = [2,2]
        self.dim = 2
    }
    
    /// Initialise a 3D `NumSwift` tensor
    init(_ object: Arr3DInt) {
        self.arr3D = object
        self.shape_ = [2,2]
        self.dim = 3
    }
    
    /// Initialise a 4D `NumSwift` tensor
    init(_ object: Arr4DInt) {
        self.arr4D = object
        self.shape_ = [2,2]
        self.dim = 4
    }
    
    /// Initialise a 5D `NumSwift` tensor
    init(_ object: Arr5DInt) {
        self.arr5D = object
        self.shape_ = [2,2]
        self.dim = 5
    }
    
    func indexIsValid(index: Int) -> Bool {
        return index >= 0 && index < arr1D.count
    }
    
    /// Flattens to a 1D `NumSwift` tensor
    ///
    /// - Returns:
    ///     A 1D `NumSwift` tensor
    func flatten() -> NumSwift {
        let finalArr: Arr1DInt
        
        switch (self.dim) {
        case 1: finalArr = arr1D
        case 2: finalArr = arr2D.flatMap { $0 }
        case 3: finalArr = arr3D.flatMap { $0 }.flatMap { $0 }
        case 4: finalArr = arr4D.flatMap { $0 }.flatMap { $0 }.flatMap { $0 }
        default: finalArr = arr5D.flatMap { $0 }.flatMap { $0 }.flatMap { $0 }.flatMap { $0 }
        }
        
        return NumSwift(finalArr)
    }
    
    subscript(_ index1: Int, _ index2: Int) -> Int {
        get {
            assert(self.dim == 2, "Dimension must be 2")
            return arr2D[index1][index2]
        }
        set {
            assert(self.dim == 2, "Dimension must be 2")
            arr2D[index1][index2] = newValue
        }
    }
    subscript(_ index1: Int, _ index2: Int, _ index3: Int) -> Int {
        get {
            assert(self.dim == 3, "Dimension must be 3")
            return arr3D[index1][index2][index3]
        }
        set {
            assert(self.dim == 3, "Dimension must be 3")
            arr3D[index1][index2][index3] = newValue
        }
    }
    subscript(_ index1: Int, _ index2: Int, _ index3: Int, _ index4: Int) -> Int {
        get {
            assert(self.dim == 4, "Dimension must be 4")
            return arr4D[index1][index2][index3][index4]
        }
        set {
            assert(self.dim == 4, "Dimension must be 4")
            arr4D[index1][index2][index3][index4] = newValue
        }
    }
    subscript(_ index1: Int, _ index2: Int, _ index3: Int, _ index4: Int, _ index5: Int) -> Int {
        get {
            assert(self.dim == 5, "Dimension must be 5")
            return arr5D[index1][index2][index3][index4][index5]
        }
        set {
            assert(self.dim == 5, "Dimension must be 5")
            arr5D[index1][index2][index3][index4][index5] = newValue
        }
    }
    
    /// Print function for 1D array from `CustomStringConvertible` protocol
    var description: String {
        let space = "       "
        var str: String = "array("
        
        switch (self.dim) {
        case 1:
            str.append(contentsOf: "\(arr1D)")
        case 2:
            str.append("[")
            for i in 0..<arr2D.count {
                if i > 0 {
                    str.append(space)
                }
                str.append(contentsOf: "\(arr2D[i])")
                if i != arr2D.count-1 {
                    str.append(",\n")
                }
            }
            str.append("]")
        default:
            str.append("[")
            for i in 0..<arr3D.count {
                if i == 0 {
                    str.append("[")
                } else if i > 0 {
                    str.append(space + "[")
                }
                for j in 0..<arr3D[i].count {
                    if j > 0 {
                        str.append(space + " ")
                    }
                    str.append(contentsOf: "\(arr3D[i][j])")
                    if j != arr3D[i].count-1 {
                        str.append(",\n")
                    }
                }
                if i != arr3D.count-1 {
                    str.append(",\n\n")
                }
            }
            str.append("]")
            str.append("]")
        }
        
        str.append(contentsOf: ")")
        
        return str
    }
    
    /// Initialise an array of zeros with a given shape
    ///
    /// - Parameters:
    ///     - shape: a tuple of ints
    /// - Returns:
    ///     A `NumSwift` tensor of given shape
    static func zeros<Tuple>(_ shape: Tuple) -> NumSwift {
        let numElements = Mirror(reflecting: shape).children.map {$1 as! Int}.reduce(1,*)
        let arr = Array(repeating: 0, count: numElements)
        return NumSwift(arr, shape: shape)
    }
    
    /// Initialise an array of ones with a given shape
    ///
    /// - Parameters:
    ///     - shape: a tuple of ints
    /// - Returns:
    ///     A `NumSwift` tensor of given shape
    static func ones<Tuple>(_ shape: Tuple) -> NumSwift {
        let numElements = Mirror(reflecting: shape).children.map {$1 as! Int}.reduce(1,*)
        let arr = Array(repeating: 1, count: numElements)
        return NumSwift(arr, shape: shape)
    }
    
    /// Initialise an array of integers from 0 up to but not including `stop`
    ///
    /// - Parameters:
    ///     - stop: The upper bound
    /// - Returns:
    ///     A 1D `NumSwift` tensor
    static func arange(_ stop: Int) -> NumSwift {
        return NumSwift(Array(0..<stop))
    }
    
    /// Initialise an array of integers from `start` up to but not including `stop`
    ///
    /// - Parameters:
    ///     - start: The lower bound
    ///     - stop: The upper bound
    /// - Returns:
    ///     A 1D `NumSwift` tensor
    static func arange(_ start: Int, _ stop: Int) -> NumSwift {
        return NumSwift(Array(start..<stop))
    }
    
    /// Initialise a tensor of shape `size` of random integers from 0 up to but not including `stop`.
    /// Similar to `numpy.random.randint()` API.
    ///
    /// - Parameters:
    ///     - high: The upper bound of range of random integers
    ///     - size: Size of tensor, in `Tuple`
    /// - Returns:
    ///     A `NumSwift` tensor of given shape
    static func randint<Tuple>(_ high: Int, _ size: Tuple) -> NumSwift {
        let numElements = Mirror(reflecting: size).children.map {$1 as! Int}.reduce(1,*)
        let arr = (1...numElements).map( {_ in Int.random(in: 0...high)} )
        return NumSwift(arr, shape: size)
    }
    
    /// Initialise a tensor of shape `size` of random integers from 0 up to but not including `stop`.
    /// Similar to `numpy.random.randint()` API.
    ///
    /// - Parameters:
    ///     - low: The lower bound of range of random integers
    ///     - high: The upper bound of range of random integers
    ///     - size: Size of tensor, in `Tuple`
    /// - Returns:
    ///     A `NumSwift` tensor of given shape
    static func randint<Tuple>(_ low: Int, _ high: Int, _ size: Tuple) -> NumSwift {
        let numElements = Mirror(reflecting: size).children.map {$1 as! Int}.reduce(1,*)
        let arr = (1...numElements).map( {_ in Int.random(in: low...high)} )
        return NumSwift(arr, shape: size)
    }
}


/// Overloading element-wise addition
func + (lhs: NumSwift, rhs: NumSwift) -> NumSwift {
    switch (lhs.dim) {
    case 1:
        return NumSwift(
            zip(lhs.arr1D, rhs.arr1D).map(+))
    case 2:
        return NumSwift(
            zip(lhs.arr2D, rhs.arr2D).map {
                zip($0, $1).map(+)})
    default:
        return NumSwift(
            zip(lhs.arr3D, rhs.arr3D).map {
                zip($0, $1).map {
                    zip($0, $1).map(+)}})
    }
}

/// Overloading element-wise subtraction
func - (lhs: NumSwift, rhs: NumSwift) -> NumSwift {
    return lhs + rhs * -1
}

/// Overloading add operation for 1D broadcasting
func + (lhs: NumSwift, rhs: Int) -> NumSwift {
    switch (lhs.dim) {
    case 1:
        return NumSwift(lhs.arr1D.map {$0 + rhs})
    case 2:
        return NumSwift(lhs.arr2D.map {$0.map {$0 + rhs}})
    default:
        return NumSwift(lhs.arr3D.map {$0.map {$0.map {$0 + rhs}}})
    }
}

/// Overloading multiply operation
func * (lhs: NumSwift, rhs: NumSwift) -> NumSwift {
    switch (lhs.dim) {
    case 1:
        return NumSwift(
            zip(lhs.arr1D, rhs.arr1D).map (*))
    case 2:
        return NumSwift(
            zip(lhs.arr2D, rhs.arr2D).map {zip($0, $1).map(*)})
    default:
        return NumSwift(
            zip(lhs.arr3D, rhs.arr3D).map {zip($0, $1).map {zip($0, $1).map(*)}})
    }
}

/// Overloading multiply operation with broadcasting
func * (lhs: NumSwift, rhs: Int) -> NumSwift {
    switch (lhs.dim) {
    case 1:
        return NumSwift(lhs.arr1D.map {$0 * rhs})
    case 2:
        return NumSwift(lhs.arr2D.map {$0.map {$0 * rhs}})
    case 3:
        return NumSwift(lhs.arr3D.map {$0.map {$0.map {$0 * rhs}}})
    case 4:
        return NumSwift(lhs.arr4D.map {$0.map {$0.map {$0.map {$0 * rhs}}}})
    default:
        return NumSwift(lhs.arr5D.map {$0.map {$0.map {$0.map {$0.map {$0 * rhs}}}}})
    }
}
