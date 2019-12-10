// Permutation

function permutation(string_) {
    var str = string_.split("")
    var result = permute_xN(str)

    result.forEach(function(element) { console.log(element) })
    console.log("Tolal: " + result.length + " entries")
}

function permute_x2(arr) {
    var res = []
    res.push([arr[0], arr[1]])
    if (arr[0] !== arr[1])
        res.push([arr[1], arr[0]])

    return res
}

function permute_x3(string_) {
    var res = []

    for (var index = 0; index < 3; index++) {
        var arr = string_.slice()
        if (index > 0) arr.move(index, 0)
        var str_x2 = arr.slice(1, arr.length)
        var res_x2 = permute_x2(str_x2)

        res_x2.forEach(function(element){
            res.push([arr[0], element[0], element[1]])
        })
    }

    return res
}

function permute_x4(string_) {
    var res = []

    for (var index = 0; index < 4; index++) {
        var arr = string_.slice()
        if (index > 0) arr.move(index, 0)
        var str_x3 = arr.slice(1, arr.length)
        var res_x3 = permute_x3(str_x3)

        res_x3.forEach(function(element){
            res.push([arr[0], element[0], element[1], element[2]])
        })
    }

    return res
}

function permute_xN(arr) {
    var res = []
    var tallyMap = {}

    if (arr.length <= 2) {
        return permute_x2(arr)
    }

    for (var index = 0; index < arr.length; index++) {
        var arr_ = arr.slice()
        if (index > 0) arr_.move(index, 0)

        if (!tallyMap[arr_[0]]) tallyMap[arr_[0]] = 1
        else continue

        var str_x = arr_.slice(1, arr_.length)
        var res_x = permute_xN(str_x)

        res_x.forEach(function(element){
            var res_ = [arr_[0]]
            for (var x = 1; x < arr.length; x++)
                res_.push(element[x - 1])
            res.push(res_)
        })
    }

    return res
}

function permuteVariant(str) {
    var arr = []
    var str_A = str.split("|")

    str_A.forEach(function(variant) {
        arr.push(variant.split(""))
    })

    var res = permuteVariant_xN(arr)
    res.forEach(function(element) { console.log(element) })
    console.log("Tolal: " + res.length + " entries")
}

function permuteVariant_x2(arr) {
    var res = []
    var arr_ = arr[0]
    var arr_1 = arr[1]

    for (var index_ = 0; index_ < arr_.length; index_++) {
        for (var index_1 = 0; index_1 < arr_1.length; index_1++) {
            res.push([arr_[index_], arr_1[index_1]])
        }
    }

    return res
}

function permuteVariant_x3(arr) {
    var res = []
    var arr_ = arr[0]
    var res_x2 = permuteVariant_x2([arr[1], arr[2]])

    for (var index_ = 0; index_ < arr_.length; index_++) {
        res_x2.forEach(function(element) {
            res.push([arr_[index_], element[0], element[1]])
        })
    }

    return res
}

function permuteVariant_x4(arr) {
    var res = []
    var arr_ = arr[0]
    var res_x3 = permuteVariant_x3([arr[1], arr[2], arr[3]])

    for (var index_ = 0; index_ < arr_.length; index_++) {
        res_x3.forEach(function(element) {
            res.push([arr_[index_], element[0], element[1], element[2]])
        })
    }

    return res
}

function permuteVariant_xN(arr) {
    var res = []

    if (arr.length <= 2) {
        return permuteVariant_x2(arr)
    }

    var arr_ = arr[0]
    var arr_1 = []
    for (var index = 1; index < arr.length; index++)
        arr_1.push(arr[index])

    var res_x = permuteVariant_xN(arr_1)

    for (var index_ = 0; index_ < arr_.length; index_++) {
        res_x.forEach(function(element) {
            var res_ = [arr_[index_]]
            for (var x = 1; x < arr.length; x++) {
                res_.push(element[x - 1])
            }
            res.push(res_)
        })
    }

    return res
}

/* -------------------------------------------- */
/* -----------| Shape placement /------------- */
/* ------------------------------------------ */

var position_arr = []
var grid_state = {}

function getShapeDictionary() {
    return {
        "T": ["T", "T_1", "T_2", "T_3"],
        "L": ["L", "L_1", "L_2", "L_3"],
        "LRev": ["LRev", "LRev_1", "LRev_2", "LRev_3"],
        "S": ["S", "S_1"],
        "SRev": ["SRev", "SRev_1"],
        "I": ["I", "I_1"],
        "Bx": ["Bx"]
    }
}

function getFirstShape(key) {
    switch (key) {
    case "T": return ["T", "T_3"]
    case "L": return ["L", "L_1", "L_2"]
    case "LRev": return ["LRev_1", "LRev_2", "LRev_3"]
    case "S": return ["S_1"]
    case "I": return ["I", "I_1"]
    case "SRev":
    case "Bx": return [key]
    }
}

function permuteShapes(shapeStr) {
    clearGrid()

    var shapes = shapeStr.split(" ")
    var permutedList = permute_xN(shapes)
    var progressMax = permutedList.length
    var shapeList = getShapeDictionary()

    // Use for(;;) loop not forEach
    for (var x = 0; x < progressMax; x++) {
        var element = permutedList[x]

        console.log((x + 1) + "/" + progressMax + " > " + element)

        var shapes_ = []
        for (var y = 0; y < element.length; y++) {
            var key = element[y]
            if (y === 0) shapes_.push(getFirstShape(key))
            else shapes_.push(shapeList[key])
        }

        var pVarList = permuteVariant_xN(shapes_)
        for (var i = 0; i < pVarList.length; i++) {
            var shape = pVarList[i]
            var solution = checkFit(shape)
            if (solution.length > 0) {
                for (var index = 0; index < shapes_.length; index++) {
                    placeShapeInGrid(shape[index], solution[index])
                }

                console.log("Found solution at shape " + shape)
                return
            }
        }
    }
}

function findAllSolutions(shapeStr) {
    clearGrid()

    var shapes = shapeStr.split(" ")
    var permutedList = permute_xN(shapes)
    var finalShapes = []
    var progress = 0
    var progressMax = permutedList.length
    var shapeList = getShapeDictionary()
    var solutions = []

    permutedList.forEach(function(element) {
        console.log(++progress + "/" + progressMax + " > " + element)

        var shapes_ = []
        element.forEach(function(key) {
            shapes_.push(shapeList[key])
        })

        var pVarList = permuteVariant_xN(shapes_)
        pVarList.forEach(function(shape) {
            finalShapes.push(shape)
        })
    })

    var solutionCount = 0
    progress = 0
    progressMax = finalShapes.length

    finalShapes.forEach(function(shape) {
        console.log(++progress + "/" + progressMax + " > " + shape)

        var solution = checkFit(shape)
        if (solution.length > 0) {
            solutions.push([shape, solution])
            solutionCount++
            console.log("Found solution at shape " + shape)
        }
    })

    console.log("Found " + solutionCount + " solutions in " + progressMax + " entries")

    return solutions
}

function permuteShapes_Alt(shapeStr) {
    clearGrid()

    var shapes = shapeStr.split(" ")
    var permutedList = permute_xN(shapes)
    var finalShapes = []
    var progress = 0
    var progressMax = permutedList.length
    var shapeList = getShapeDictionary()

    permutedList.forEach(function(element) {
        console.log(++progress + "/" + progressMax + " > " + element)

        var shapes = []
        element.forEach(function(key) {
            shapes.push(shapeList[key])
        })

        var pVarList = permuteVariant_xN(shapes)
        pVarList.forEach(function(shape) {
            finalShapes.push(shape)
        })
    })

    progress = 0
    progressMax = finalShapes.length

    for (var index = 0; index < progressMax; index++) {
        var shape = finalShapes[index]
        var solution = checkFit(shape)
        console.log(++progress + "/" + progressMax + " > " + shape)

        if (solution.length > 0) {
            for (var i = 0; i < shape.length; i++) {
                placeShapeInGrid(shape[i], solution[i])
            }

            console.log("Found solution at shape " + shape)
            return
        }
    }
}

function permutePartial(shapeStr) {
    position_arr = []
    grid_state = {}

    position_arr = getEmptyGridPositions()
    position_arr.forEach(function(position) {
        grid_state[position[0] + "|" + position[1]] = false
    })

    var shapes = shapeStr.split(" ")
    var permutedList = permute_xN(shapes)
    var progressMax = permutedList.length
    var shapeList = getShapeDictionary()

    // Use for(;;) loop not forEach
    for (var x = 0; x < progressMax; x++) {
        var element = permutedList[x]

        console.log((x + 1) + "/" + progressMax + " > " + element)

        var shapes_ = []
        element.forEach(function(key) {
            shapes_.push(shapeList[key])
        })

        var pVarList = permuteVariant_xN(shapes_)
        for (var i = 0; i < pVarList.length; i++) {
            var shape = pVarList[i]
            var solution = checkPartialFit(shape)
            if (solution.length > 0) {
                for (var index = 0; index < shapes_.length; index++) {
                    placeShapeInGrid(shape[index], solution[index])
                }

                console.log("Found solution to shape " + shape + " at " + solution.join(" "))
                return
            }
        }
    }
}

function checkFit(shapes) {
    var positions = getGridPositions()
    var grid = {}
    var solution = []

    positions.forEach(function(position) {
        grid[position[0] + "|" + position[1]] = false
    })

    shapes.forEach(function(shape) {
        for (var index = 0; index < positions.length; index++) {
            var position = positions[index]

            if (!grid[position[0] + "|" + position[1]]) {
                var res = placeShape(shape, position)

                if (res[0]) {
                    solution.push(position)
                    res[1].forEach(function(cell) {
                        grid[cell.position[0] + "|" + cell.position[1]] = true
                    })

                    break
                }
            }
        }
    })

    for (var pos in grid) {
        if (!grid[pos]) return []
    }

    return solution
}

function checkPartialFit(shapes) {
    var grid = {}
    var positions = position_arr.slice()
    var solution = []

    for (var pos_key in grid_state) {
        grid[pos_key] = grid_state[pos_key]
    }

    shapes.forEach(function(shape) {
        for (var index = 0; index < positions.length; index++) {
            var position = positions[index]

            if (!grid[position[0] + "|" + position[1]]) {
                var res = placeShape(shape, position)

                if (res[0]) {
                    solution.push(position)
                    res[1].forEach(function(cell) {
                        grid[cell.position[0] + "|" + cell.position[1]] = true
                    })

                    break
                }
            }
        }
    })

    for (var pos in grid) {
        if (!grid[pos]) return []
    }

    return solution
}

function placeFixedLShapesTest() {
    recycleGrid(3, 3)

    var shapes = ["L_1", "L_3"]
    var positions = getGridPositions()
    var grid = {}
    var solution = {}

    positions.forEach(function(position) {
        grid[position[0] + "|" + position[1]] = false
    })

    var res = placeShape(shapes[0], [0, 0])
    if (res[0]) {
        solution[shapes[0]] = [0, 0]

        res[1].forEach(function(cell) {
            grid[cell.position[0] + "|" + cell.position[1]] = true
        })

        positions.forEach(function(position) {
            if (!grid[position[0] + "|" + position[1]]) {
                var res_ = placeShape(shapes[1], position)
                if (res_[0]) {
                    solution[shapes[1]] = position

                    res_[1].forEach(function(cell) {
                        grid[cell.position[0] + "|" + cell.position[1]] = true
                    })
                }
            }
        })
    }

    for (var key in solution) {
        console.log(key + ": " + solution[key])
        placeShapeInGrid(key, solution[key])
    }
}

function placeRecursionTest() {
    recycleGrid(4, 4)

    var shapes = ["Bx", "Bx", "Bx", "Bx"]
    var solution = checkFit(shapes)

    for (var index = 0; index < shapes.length; index++) {
        placeShapeInGrid(shapes[index], solution[index])
    }
}

function placeRecursionTest_2() {
    recycleGrid(3, 4)

    var shapes = ["LRev_2", "S", "L_3"]
//    var shapes = ["L", "S_1", "L_2"]
    var solution = checkFit(shapes)

    for (var index = 0; index < shapes.length; index++) {
        placeShapeInGrid(shapes[index], solution[index])
    }
}

function simplePlacement() {
    recycleGrid(3, 4)

    var shapes = ["L_3", "LRev_2", "S"]
    var res = permute_xN(shapes)

    res.forEach(function(config) {
        var solution = checkFit(config)
        if (solution.length > 0) {
            for (var index = 0; index < shapes.length; index++) {
                placeShapeInGrid(config[index], solution[index])
            }
        }
    })
}

function simplePlacement_Variant() {
    recycleGrid(3, 4)

    var shapes = [
                ["LRev", "LRev_1", "LRev_2", "LRev_3"],
                ["S", "S_1"],
                ["L", "L_1", "L_2", "L_3"]
            ]

    var res = permuteVariant_xN(shapes)

    res.forEach(function(config) {
        res.forEach(function(config) {
            var solution = checkFit(config)
            if (solution.length > 0) {
                for (var index = 0; index < shapes.length; index++) {
                    placeShapeInGrid(config[index], solution[index])
                }
            }
        })
    })
}

Array.prototype.move = function(from, to) {
    this.splice(to, 0, this.splice(from, 1)[0])
}

/* ------------------------------------------------- */
/* ----------------| from Shape.js |---------------- */
/* ------------------------------------------------- */

var rotationIndex_T = 0
var rotationIndex_L = 0
var rotationIndex_LRev = 0
var rotationIndex_S = 0
var rotationIndex_SRev = 0
var rotationIndex_I = 0

function placeShape(shapeKey, position) {
    var shape = get(shapeKey, position)
    var placementCells = []

    for (var index = 0; index < shape.length; index++) {
        try {
            var cell = gridArr[shape[index][0]][shape[index][1]]
            if (cell === undefined) return [false]
        }
        catch (error) {
            return [false]
        }

        if (cell.alive) { return [false] }
        else { placementCells.push(cell) }
    }

    return [true, placementCells]
}

function get(shapeKey, position) {
    var shapes = {
        "T": [[0, 0], [0, 1], [0, 2], [1, 1]],
        "T_1": [[0, 0], [-1, 1], [0, 1], [1, 1]],
        "T_2": [[0, 0], [0, 1], [0, 2], [-1, 1]],
        "T_3": [[0, 0], [1, 0], [2, 0], [1, 1]],

        "L": [[0, 0], [1, 0], [2, 0], [2, 1]],
        "L_1": [[0, 0], [0, 1], [0, 2], [1, 0]],
        "L_2": [[0, 0], [0, 1], [1, 1], [2, 1]],
        "L_3": [[0, 0], [0, 1], [0, 2], [-1, 2]],

        "LRev": [[0, 0], [1, 0], [2, 0], [2, -1]],
        "LRev_1": [[0, 0], [1, 0], [1, 1], [1, 2]],
        "LRev_2": [[0, 0], [1, 0], [2, 0], [0, 1]],
        "LRev_3": [[0, 0], [0, 1], [0, 2], [1, 2]],

        "S": [[0, 0], [0, 1], [-1, 1], [-1, 2]],
        "S_1": [[0, 0], [1, 0], [1, 1], [2, 1]],

        "SRev": [[0, 0], [0, 1], [1, 1], [1, 2]],
        "SRev_1": [[0, 0], [0, 1], [-1, 1], [1, 0]],

        "I": [[0, 0], [1, 0], [2, 0], [3, 0]],
        "I_1": [[0, 0], [0, 1], [0, 2], [0, 3]],

        "Bx": [[0, 0], [1, 0], [0, 1], [1, 1]]
    }

    var shape = shapes[getRotatedKey(shapeKey)]
    for (var index in shape) {
        shape[index][0] += position[0]
        shape[index][1] += position[1]
    }

    return shape
}

function getRotatedKey(shapeKey) {
    switch (shapeKey) {
    case "T":
        var shape_T = ["T", "T_1", "T_2", "T_3"]
        return shape_T[rotationIndex_T]

    case "L":
        var shape_L = ["L", "L_1", "L_2", "L_3"]
        return shape_L[rotationIndex_L]

    case "LRev":
        var shape_LRev = ["LRev", "LRev_1", "LRev_2", "LRev_3"]
        return shape_LRev[rotationIndex_LRev]

    case "S":
        var shape_S = ["S", "S_1"]
        return shape_S[rotationIndex_S]

    case "SRev":
        var Shape_SRev = ["SRev", "SRev_1"]
        return Shape_SRev[rotationIndex_SRev]

    case "I":
        var Shape_I = ["I", "I_1"]
        return Shape_I[rotationIndex_I]

    default:
        return shapeKey
    }
}
