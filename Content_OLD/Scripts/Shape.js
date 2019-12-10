// Shapes.js

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

function rotateShape(shapeKey) {
    switch (shapeKey) {
    case "T":
        if (rotationIndex_T < 3) rotationIndex_T++
        else rotationIndex_T = 0
        break

    case "L":
        if (rotationIndex_L < 3) rotationIndex_L++
        else rotationIndex_L = 0
        break

    case "LRev":
        if (rotationIndex_LRev < 3) rotationIndex_LRev++
        else rotationIndex_LRev = 0
        break

    case "S":
        rotationIndex_S = rotationIndex_S === 0 ? 1 : 0
        break

    case "SRev":
        rotationIndex_SRev = rotationIndex_SRev === 0 ? 1 : 0
        break

    case "I":
        rotationIndex_I = rotationIndex_I === 0 ? 1 : 0
        break
    }
}

/* ____________________________________________________ */

Math.factorial = function(number_) {
    var total = number_

    for (var index = 1; index < number_; index++) {
        total *= index
    }

    return total
}
