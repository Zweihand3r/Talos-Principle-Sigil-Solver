import QtQuick 2.7
import QtQuick.Layouts 1.3
import '../Scripts/Permutation.js' as Permute

Rectangle {
    id: rootGrid
    width: Math.max(selection.width, grid.width + 32)
    height: Math.max(selection.height, grid.height + 32)
    color: "black"

    property var cellGridArr: []
    property var population: []
    property var currentPosition: []

    property int rows: 0
    property int columns: 0

    Item {
        id: grid
        width: 64 * columns; height: 64 * rows
        anchors.centerIn: parent
    }

    Selection {
        id: selection
        onSelectionFinalised: initialiseGrid(rows, columns, shapeArray)
    }

    Rectangle {
        width: 44; height: 44; border { width: 2; color: "white" } radius: width / 2; color: "transparent"
        anchors { left: selection.right; verticalCenter: parent.verticalCenter; leftMargin: 12 }
        Rectangle { anchors { fill: parent; margins: 2 } color: "black"; opacity: 0.8; radius: width / 2 }
        Text { anchors { centerIn: parent; verticalCenterOffset: -2 } text: ">"; font.pixelSize: 27; color: "white" }
        MouseArea { anchors.fill: parent; onClicked: selection.presentSelection() }
    }

    function initialiseGrid(rows, columns, shapeArray) { gridFunctions.initialiseGrid(rows, columns, shapeArray) }

    QtObject {
        id: computeFunctions

        function permuteRandom(shapeArr) {
            var index = 0
            var maxIteration = Permute.value(shapeArr.length)
            var tracker = {}
            var shapeDictionary = shapeFunctions.getDictionary()

            while (true) {
                shuffleArray(shapeArr)
                console.log("Shuffled")
                var shapeStr = shapeArr.join("")
                if (tracker[shapeStr] !== undefined) {
                    continue
                }

                console.log("Checking fit for shapes > " + (index + 1) + ": " + shapeStr)
                tracker[shapeStr] = 1

                var shapesMat = []
                shapesMat.push(shapeFunctions.getInitialKeys(shapeArr[0]))
                for (var x = 1; x < shapeArr.length; x++)
                    shapesMat.push(shapeDictionary[shapeArr[x]])

                var variantShapes = Permute.variant(shapesMat)
                for (var index_ = 0; index_ < variantShapes.length; index_++) {
                    var shapeKeys = variantShapes[index_]

                    if (checkFitShapesBase(shapeKeys)) {
                        var positionSequence = getFit(shapeKeys)
                        gridFunctions.drawSequence(positionSequence)
                        return
                    }
                }
            }
        }

        function shuffleArray(array) {
            for (var i = array.length - 1; i > 0; i--) {
                var j = Math.floor(Math.random() * (i + 1));
                var temp = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
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

        function checkFitShapesBase(shapeKeys) {
            var shapeKeyIndex = 0
            var population_ = gridFunctions.getEmptyPopulation()
            shapeKeys.forEach(function(key) {
                loopRow: // Compare against return
                for (var row = 0; row < population_.length; row++) {
                    var statusArr = population_[row]
                    for (var col = 0; col < statusArr.length; col++) {
                        if (!statusArr[col]) {
                            var positions = shapeFunctions.getPositions(key, [row, col])
                            if (checkEmptyInPopulation(positions, population_)) {
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
            if (shapeKeyIndex === shapeKeys.length) return true
            else return false
        }

        function getFit(shapeKeys) {
            var shapeKeyIndex = 0; var fitPositions = []
            var population_ = gridFunctions.getEmptyPopulation()
            shapeKeys.forEach(function(key) {
                loopRow: for (var row = 0; row < population_.length; row++) {
                    var statusArr = population_[row]
                    for (var col = 0; col < statusArr.length; col++) {
                        if (!statusArr[col]) {
                            var positions = shapeFunctions.getPositions(key, [row, col])
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
    }

    QtObject {
        id: shapeFunctions

        property var rotationIndices: [0, 0, 0, 0, 0, 0, 0]
        property var shapeDictionary: {
            "T": ["T", "T1", "T2", "T3"],
            "L": ["L", "L1", "L2", "L3"],
            "J": ["J", "J1", "J2", "J3"],
            "S": ["S", "S1"],
            "2": ["2", "21"],
            "I": ["I", "I1"],
            "O": ["O"]
        }
        property var shapePositions: {
            "T": [[0, 0], [0, 1], [0, 2], [1, 1]],
            "T1": [[0, 0], [1, -1], [1, 0], [2, 0]],
            "T2": [[0, 0], [1, -1], [1, 0], [1, 1]],
            "T3": [[0, 0], [1, 0], [1, 1], [2, 0]],

            "L": [[0, 0], [1, 0], [2, 0], [2, 1]],
            "L1": [[0, 0], [0, 1], [0, 2], [1, 0]],
            "L2": [[0, 0], [0, 1], [1, 1], [2, 1]],
            "L3": [[0, 0], [1, -2], [1, -1], [1, 0]],

            "J": [[0, 0], [1, 0], [2, -1], [2, 0]],
            "J1": [[0, 0], [1, 0], [1, 1], [1, 2]],
            "J2": [[0, 0], [0, 1], [1, 0], [2, 0]],
            "J3": [[0, 0], [0, 1], [0, 2], [1, 2]],

            "S": [[0, 0], [0, 1], [1, -1], [1, 0]],
            "S1": [[0, 0], [1, 0], [1, 1], [2, 1]],

            "2": [[0, 0], [0, 1], [1, 1], [1, 2]],
            "21": [[0, 0], [1, -1], [1, 0], [2, -1]],

            "I": [[0, 0], [1, 0], [2, 0], [3, 0]],
            "I1": [[0, 0], [0, 1], [0, 2], [0, 3]],

            "O": [[0, 0], [1, 0], [0, 1], [1, 1]]
        }

        function getDictionary() {
            return shapeDictionary
        }

        function getCurrentShapeKey() {
            return shapeDictionary[currentShape][rotationIndices[currentShapeIndex]]
        }

        function getInitialKeys(key) {
            switch (key) {
            case "T": return ["T", "T3"]
            case "L": return ["L", "L1", "L2"]
            case "J": return ["J1", "J2", "J3"]
            case "S": return ["S1"]
            case "I": return ["I", "I1"]
            case "2":
            case "O": return [key]
            }
        }

        function getPositions(shapeKey, position) {
            var positions = []
            var shapePositions_ = shapePositions[shapeKey]
            shapePositions_.forEach(function(shapePos) {
                positions.push([position[0] + shapePos[0], position[1] + shapePos[1]])
            })

            return positions
        }
    }

    QtObject {
        id: gridFunctions

        function initialiseGrid(rows, columns, shapeArray) {
            if ((rows === 0 || !rows) && (columns === 0 || !columns)) {
                console.log("Not enough arguments")
                return
            }

            if (cellGridArr.length > 0) clearGrid()

            rootGrid.rows = rows
            rootGrid.columns = columns

            generateGrid(rows, columns)
            computeFunctions.permuteRandom(shapeArray)
        }

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

                    var component = Qt.createComponent('Cell_Plain.qml')
                    var cell = component.createObject(grid, { "x": c * 64, "y": r * 64 })

                    colArray.push(cell)
                    index++
                }

                cellGridArr.push(colArray)
                population.push(colPopulation)
            }
        }

        function clearGrid() {
            for (var x = 0; x < cellGridArr.length; x++) {
                var colArr = cellGridArr[x]
                for (var y = 0; y < colArr.length; y++) {
                    colArr[y].destroy()
                }
            }
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

        function getEmptyPopulation() {
            var population_ = []
            for (var r = 0; r < cellGridArr.length; r++) {
                var colArr = []
                for (var c = 0; c < cellGridArr[r].length; c++) colArr.push(false)
                population_.push(colArr)
            }
            return population_
        }
    }
}
