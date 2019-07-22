import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import '../Scripts/Permutation.js' as Permute

Rectangle {
    id: rootGrid
    width: controls.width + grid.width + shapes.width
    height: grid.height
    color: "#FFFFFF"

    property var cellGridArr: []
    property var population: []
    property var currentPosition: []

    property int rows: 4
    property int columns: 3

    property bool showCellIndices: false

    function generateGrid(rows, columns) { gridFunctions.generateGrid(rows, columns) }
    function clearGrid() { gridFunctions.clearGrid() }
    function resetGrid() { gridFunctions.clearGrid(); gridFunctions.generateGrid() }
    function clearPreview() { gridFunctions.clearPreview() }
    function setPreview(positions) { gridFunctions.setPreview(positions) }
    function toggleIndices() { gridFunctions.toggleIndices() }

    function cellClickAction() { shapes.place(currentPosition); shapes.preview(currentPosition) }
    function previewShape(position) { shapes.preview(position) }
    function rotateShape() { shapes.rotate() }

    /* Permute shapes in shapeStr */
    function permuteShapes(shapeStr) { internal.permuteShapes(shapeStr) }

    /* Returns an array of 'Cell's if shape can be placed. Returns empty array otherwise */
    function getEmptyCells(positions) { return internal.getEmptyCells(positions) }

    /* positions: Array of [<row>, <columns>] | Returns true/false */
    function checkEmpty(positions) { return internal.checkEmpty(positions) }

    /* Set alive of cells at each position to true. Does NOT check if can be placed or not */
    function drawShape(positions) { gridFunctions.drawShape(positions) }

    /* Draw sequence of shapes. See drawShape() */
    function drawSequence(positionSequence) { gridFunctions.drawSequence(positionSequence) }

    /* Places shape at position if cell are empty */
    function placeShape(shapeKey, position) { shapes.place(shapeKey, position) }

    /* Comparisions */
    function checkFitComparision(shapeKeys) { internal.checkFitCompare(shapeKeys) }
    function permuteShapesComparision(shapeStr, all) { internal.permuteShapesCompare(shapeStr, all) }

    Component.onCompleted: generateGrid()

    /* For Autocomplete */
    Cell_ { visible: false }

    GridControls {
        id: controls
    }

    Item {
        id: grid
        width: (68 * columns) - (2 * columns); height: (68 * rows) - (2 * rows) + 10
        anchors { left: controls.right; verticalCenter: parent.verticalCenter; verticalCenterOffset: 6 }
    }

    ShapeList {
        id: shapes
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
    }

    QtObject {
        id: internal

        function checkEmpty(positions) {
            for (var index = 0; index < positions.length; index++) {
                if (positions[index][0] < rows && positions[index][1] < columns && positions[index][1] >= 0) {
                    var status = population[positions[index][0]][positions[index][1]]
                    if (status) return false
                }
                else return false
            }

            return true
        }

        function checkEmptyInPopulation(positions, population) {
            for (var index = 0; index < positions.length; index++) {
                if (positions[index][0] < rows && positions[index][1] < columns && positions[index][1] >= 0) {
                    var status = population[positions[index][0]][positions[index][1]]
                    if (status) return false
                }
                else return false
            }

            return true
        }

        function getFit(shapeKeys) {
            var shapeKeyIndex = 0; var fitPositions = []
            var population_ = gridFunctions.getEmptyPopulation()
            shapeKeys.forEach(function(key) {
                loopRow: for (var row = 0; row < population_.length; row++) {
                    var statusArr = population_[row]
                    for (var col = 0; col < statusArr.length; col++) {
                        if (!statusArr[col]) {
                            var positions = shapes.getPositions(key, [row, col])
                            if (checkEmptyInPopulation(positions, population_)) {
                                shapeKeyIndex++
                                positions.forEach(function(position) { population_[position[0]][position[1]] = true })
                                fitPositions.push(positions)
                                break loopRow
                            }
                        }
                    }
                }
            })
            return fitPositions
        }

        function permuteShapes(shapeStr) {
            var solutionKeys = permuteGridBase(shapeStr, false)
            var positionSequence = getFit(solutionKeys[0])
            drawSequence(positionSequence)
        }


        /* __________________/ Comparisions \____________________ */

        function permuteShapesCompare(shapeStr, all) {
            if (all === undefined) all = false

            console.time("GridBase")
            var gridBaseSolutions = permuteGridBase(shapeStr, all)
            console.timeEnd("GridBase")

            console.time("ShapeBase")
            var shapeBaseSolutions = permuteShapeBase(shapeStr, all)
            console.timeEnd("ShapeBase")

            console.log("Grid Base found " + gridBaseSolutions.length + " solutions: ")
            for (var i = 0; i < gridBaseSolutions.length; i++) {
                console.log((i + 1) + ": " + gridBaseSolutions[i])
            }

            console.log("Shape Base found " + shapeBaseSolutions.length + " solutions: ")
            for (i = 0; i < shapeBaseSolutions.length; i++) {
                console.log((i + 1) + ": " + shapeBaseSolutions[i])
            }

            if (all) {
                var solutionDictionary = {}
                var solutionArray = []
                var shapeKeyArray = []

                var gridBaseArr = []
                gridBaseSolutions.forEach(function(solution) { gridBaseArr.push(getFit(solution)) })
                shapeKeyArray.push(gridBaseSolutions)
                solutionArray.push(gridBaseArr)

                var shapeBaseArr = []
                shapeBaseSolutions.forEach(function(solution) { shapeBaseArr.push(getFit(solution)) })
                shapeKeyArray.push(shapeBaseSolutions)
                solutionArray.push(shapeBaseArr)

                solutionDictionary["shapeKeys"] = shapeKeyArray
                solutionDictionary["sequences"] = solutionArray
                controls.setNavigator(solutionDictionary)
            }
        }

        function permuteGridBase(shapeStr, all) {
            var shapeArr = shapeStr.split("")
            var permutedShapes = Permute.array(shapeArr)
            var progressMax = permutedShapes.length
            var shapeDictionary = shapes.getDictionary()

            var solutions = []

            for (var index = 0; index < progressMax; index++) {
                var shape = permutedShapes[index]
//                console.log((index + 1) + "/" + progressMax + " > " + shape)

                var shapesMat = []
                shapesMat.push(shapes.getInitialKeys(shape[0]))
                for (var x = 1; x < shape.length; x++)
                    shapesMat.push(shapeDictionary[shape[x]])

                var variantShapes = Permute.variant(shapesMat)
                for (var index_ = 0; index_ < variantShapes.length; index_++) {
                    var shapeKeys = variantShapes[index_]

                    if (checkFitGridBase(shapeKeys)) {
                        solutions.push(shapeKeys)
                        if (!all) return solutions
                    }
                }
            }

            return solutions
        }

        function permuteShapeBase(shapeStr, all) {
            var shapeArr = shapeStr.split("")
            var permutedShapes = Permute.array(shapeArr)
            var progressMax = permutedShapes.length
            var shapeDictionary = shapes.getDictionary()

            var solutions = []

            for (var index = 0; index < progressMax; index++) {
                var shape = permutedShapes[index]
//                console.log((index + 1) + "/" + progressMax + " > " + shape)

                var shapesMat = []
                shapesMat.push(shapes.getInitialKeys(shape[0]))
                for (var x = 1; x < shape.length; x++)
                    shapesMat.push(shapeDictionary[shape[x]])

                var variantShapes = Permute.variant(shapesMat)
                for (var index_ = 0; index_ < variantShapes.length; index_++) {
                    var shapeKeys = variantShapes[index_]

                    if (checkFitShapesBase(shapeKeys)) {
                        solutions.push(shapeKeys)
                        if (!all) return solutions
                    }
                }
            }

            return solutions
        }

        function checkFitCompare(shapeKeys) {
            if (checkFitGridBase(shapeKeys)) {
                console.log("Solution found for Grid Base")
            }

            if (checkFitShapesBase(shapeKeys)) {
                console.log("Solution found for Shape Base")
            }

//            var shapeSequence = checkFitGridBase(shapeKeys)
//            if (shapeSequence) {
//                console.log("Found solution")
//            }
//            else {
//                console.log("Solution not found")
//            }
        }

        function checkFitGridBase(shapeKeys) {
            var shapeKeyIndex = 0
            var population_ = gridFunctions.getEmptyPopulation()

            for (var row = 0; row < population_.length; row++) {
                var statusArr = population_[row]
                for (var col = 0; col < statusArr.length; col++) {

//                    console.log([row, col] + ": " + statusArr[col])

                    if (!statusArr[col] && shapeKeyIndex < shapeKeys.length) {
                        var positions = shapes.getPositions(shapeKeys[shapeKeyIndex], [row, col])
                        if (checkEmptyInPopulation(positions, population_)) {

//                            console.log("Shape " + shapeKeys[shapeKeyIndex] + " placed at " + [row, col])

                            shapeKeyIndex++

                            positions.forEach(function(position) {
                                population_[position[0]][position[1]] = true
                            })

//                            console.log("Current Shape > " + shapeKeys[Math.min(shapeKeyIndex, shapeKeys.length - 1)])
                        }
                    }
                }
            }

//            console.log("ShapeKeyIndex: " + shapeKeyIndex)

            if (shapeKeyIndex === shapeKeys.length) return true
            else return false
        }

        function checkFitShapesBase(shapeKeys) {
            var shapeKeyIndex = 0
            var population_ = gridFunctions.getEmptyPopulation()

            shapeKeys.forEach(function(key) {

//                console.log("Current Shape > " + key)

                loopRow: // Compare against return
                for (var row = 0; row < population_.length; row++) {
                    var statusArr = population_[row]
                    for (var col = 0; col < statusArr.length; col++) {

//                        console.log([row, col] + ": " + statusArr[col])

                        if (!statusArr[col]) {
                            var positions = shapes.getPositions(key, [row, col])
                            if (checkEmptyInPopulation(positions, population_)) {

//                                console.log("Shape " + key + " placed at " + [row, col])

                                shapeKeyIndex++

                                positions.forEach(function(position) {
                                    population_[position[0]][position[1]] = true
                                })

                                break loopRow
                            }
                        }
                    }
                }
            })

//            console.log("ShapeKeyIndex: " + shapeKeyIndex)

            if (shapeKeyIndex === shapeKeys.length) return true
            else return false
        }
    }

    QtObject {
        id: gridFunctions

        function generateGrid(rows, columns) {
            if (rows === undefined) rows = rootGrid.rows; else rootGrid.rows = rows
            if (columns === undefined) columns = rootGrid.columns; else rootGrid.columns = columns

            var index = 0
            cellGridArr = []
            population = []

            for (var r = 0; r < rows; r++) {
                var colArray = []
                var colPopulation = []

                for (var c = 0; c < columns; c++) {
                    colPopulation.push(false)

                    var component = Qt.createComponent('Cell_.qml')
                    var cell = component.createObject(grid, { "x": c * 66, "y": r * 66, "rowIndex": r,
                                                          "colIndex": c, "showIndices": showCellIndices })

                    colArray.push(cell)
                    index++
                }

                cellGridArr.push(colArray)
                population.push(colPopulation)
            }
        }

        function setPreview(positions) {
            var previewCells = []
            var previewIncomplete = false

            for (var index = 0; index < positions.length; index++) {
                if (positions[index][0] < rows && positions[index][0] >= 0 &&
                        positions[index][1] < columns && positions[index][1] >= 0) {

                    previewCells.push(cellGridArr[positions[index][0]][positions[index][1]])
                    var status = population[positions[index][0]][positions[index][1]]
                    if (status) previewIncomplete = true
                }
                else previewIncomplete = true
            }

            previewCells.forEach(function(cell) {
                cell.preview = true
                cell.previewIncomplete = previewIncomplete
            })
        }

        function drawShape(positions) {
            var tint = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            positions.forEach(function(position) {
                population[position[0]][position[1]] = true
                cellGridArr[position[0]][position[1]].color = tint
            })
        }

        function drawSequence(positionSequence) {
            positionSequence.forEach(function(positions) {
                drawShape(positions)
            })
        }

        function clearGrid() {
            for (var x = 0; x < cellGridArr.length; x++) {
                var colArr = cellGridArr[x]
                for (var y = 0; y < colArr.length; y++) {
                    colArr[y].destroy()
                }
            }
        }

        function clearPreview() {
            for (var x = 0; x < cellGridArr.length; x++) {
                var colArr = cellGridArr[x]
                for (var y = 0; y < colArr.length; y++) {
                    colArr[y].preview = false
                    colArr[y].previewIncomplete = false
                }
            }
        }

        function getEmptyPopulation() {
            var population_ = []
            for (var r = 0; r < cellGridArr.length; r++) {
                var colArr = []
                for (var c = 0; c < cellGridArr[r].length; c++) colArr.push(false)
                population_.push(colArr)
            }
            return population_
        }

        function toggleIndices() {
            showCellIndices = !showCellIndices

            for (var x = 0; x < cellGridArr.length; x++) {
                var colArr = cellGridArr[x]
                for (var y = 0; y < colArr.length; y++) {
                    colArr[y].showIndices = showCellIndices
                }
            }
        }
    }
}
