import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import './V2'
import './Scripts/Permutation.js' as Permute

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
    function getEmptyCells(positions) { }

    /* positions: Array of [<row>, <columns>] | Returns true/false */
    function checkEmpty(positions) { }

    /* Set alive of cells at each position to true. Does NOT check if can be placed or not */
    function drawShape(positions) { gridFunctions.drawShape(positions) }

    /* Draw sequence of shapes. See drawShape() */
    function drawSequence(positionSequence) { gridFunctions.drawSequence(positionSequence) }

    /* Places shape at position if cell are empty */
    function placeShape(shapeKey, position) { shapes.place(shapeKey, position) }

    /* Comparisions */
    function checkFitComparision(shapeKeys) { }
    function permuteShapesComparision(shapeStr, all) { }

    Component.onCompleted: generateGrid()

    /* For Autocomplete */
    Cell_ { visible: false }

    ColumnLayout {
        id: controls
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            id: listView
            property int currentIndex: -1
            Text {
                Layout.preferredWidth: paintedWidth + 20
                text: modelData; horizontalAlignment: Text.horizontalAlignment; leftPadding: 10
                scale: clicky.containsMouse ? 1.1 : 1; opacity: listView.currentIndex === index ? 1 : 0.5
                MouseArea { id: clicky; hoverEnabled: true; anchors.fill: parent; onClicked: listView.clickHandler(parent.text, index) }
            }
            model: [
                "4x3 LJS",
                "4x3 TTJ",
                "4x4 IJL2",
                "5x4 ITTL2",
                "6x4 TTJJL2",
                "6x6 OOTTLLJIS",
                "5x8 TTTTLJSS22",
                "10x4 STTTTOOILL"
            ]

            function clickHandler(text, index) {
                console.log("\\____________________ New Session _____________________/")

                currentIndex = index
                var params = text.split(" ")
                var sizeStr = params[0]
                var sizeArr = sizeStr.split("x")
                gridFunctions.clearGrid()
                gridFunctions.generateGrid(parseInt(sizeArr[0]), parseInt(sizeArr[1]))
                internal.permuteShapes(params[1])
            }
        }

        ComboBox {
            id: algoDropdown
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
            model: ["Random", "Permute from last"]
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap; text: algoDropdown.currentText
        }
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

        function permuteShapes(shapeStr) {
            switch (algoDropdown.currentText) {
            case "Random": permuteShapes3_1(shapeStr); break
            case "Permute from last": permuteShapes3_0(shapeStr); break
            }
        }

        /* ---------------------------- V 3.1 ------------------------------- */

        function permuteShapes3_1(shapeStr) {
            permuteRandom(shapeStr.split(""))
        }

        function permuteRandom(shapeArr) {
            var tracker = {}
            var shapeDictionary = shapes.getDictionary()

            while (true) {
                shuffleArray(shapeArr)
                var shapeStr = shapeArr.join("")
                if (tracker[shapeStr] !== undefined) {
                    continue
                }

                console.log("Checking fit for shapes: " + shapeStr)
                tracker[shapeStr] = 1

                var shapesMat = []
                shapesMat.push(shapes.getInitialKeys(shapeArr[0]))
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

        /* ---------------------------- V 3.0 ------------------------------- */

        property int shapeArrIndex: 0

        function permuteShapes3_0(shapeStr) {
            if (shapeStr.length * 4 !== rows * columns) {
                console.log("Not possible to fit shapes to grid")
                return
            }

            var shapeOrder = ["I", "O", "T", "J", "L", "S", "2"]
            var orderMap = { "I": 0, "O": 1, "T": 2, "J": 3, "L": 4, "S": 5, "2": 6 }
            var shapeSplit = shapeStr.split("")
            var shapeArr = []
            var sortArr = []

            shapeSplit.forEach(function(item) {
                sortArr.push(orderMap[item])
            })

            sortArr.sort()
            sortArr.forEach(function(index) {
                shapeArr.push(shapeOrder[index])
            })

            permuteArr3_0(shapeArr)
        }

        function permuteArr3_0(shapeArr) {
            if (shapeArr.length < 3) { console.log("Needs more than 2 shapes"); return }

            shapeArrIndex = shapeArr.length - 2

            while (shapeArrIndex > 0) {
                var postArr = shapeArr.slice()
                var preArr = postArr.splice(0, shapeArrIndex)

                var postPermuted = Permute.array(postArr)
                var shapeDictionary = shapes.getDictionary()

                for (var index = 0; index < postPermuted.length; index++) {
                    var shape = preArr.concat(postPermuted[index])
                    console.log("Checking fit for shapes: " + shape)

                    var shapesMat = []
                    shapesMat.push(shapes.getInitialKeys(shape[0]))
                    for (var x = 1; x < shape.length; x++)
                        shapesMat.push(shapeDictionary[shape[x]])

                    var postVariant = Permute.variant(shapesMat)
                    for (var index_ = 0; index_ < postVariant.length; index_++) {
                        var shapeKeys = postVariant[index_]

                        if (checkFitGridBase(shapeKeys)) {
                            var positionSequence = getFit(shapeKeys)
                            gridFunctions.drawSequence(positionSequence)
                            return
                        }
                    }
                }

                shapeArrIndex--
            }
        }

        /* ---------------------------- Check Functions ------------------------------- */

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

        function checkFitGridBase(shapeKeys) {
            var shapeKeyIndex = 0
            var population_ = gridFunctions.getEmptyPopulation()

            for (var row = 0; row < population_.length; row++) {
                var statusArr = population_[row]
                for (var col = 0; col < statusArr.length; col++) {
                    if (!statusArr[col] && shapeKeyIndex < shapeKeys.length) {
                        var positions = shapes.getPositions(shapeKeys[shapeKeyIndex], [row, col])
                        if (checkEmptyInPopulation(positions, population_)) {
                            shapeKeyIndex++

                            positions.forEach(function(position) {
                                population_[position[0]][position[1]] = true
                            })
                        }
                    }
                }
            }
            if (shapeKeyIndex === shapeKeys.length) return true
            else return false
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
                            var positions = shapes.getPositions(key, [row, col])
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

                    var component = Qt.createComponent('./V2/Cell_.qml')
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
