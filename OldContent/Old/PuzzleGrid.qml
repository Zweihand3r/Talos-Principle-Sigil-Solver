import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import '../Scripts/Shape.js' as Shape

Rectangle {
    id: rootGrid

    property int rows: 4
    property int columns: 3

    property var gridArr: []
    property var currentPosition: []

    property bool showCellIndices: false

    color: "#000000"
    anchors.fill: parent
    Component.onCompleted: generateGrid()

    Cell { visible: false }

    Item {
        id: grid
        width: 68 * columns
        height: 68 * rows
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: debugPanel.toolBarVisible ? 64 : 0
    }

    DebugPanel {
        id: debugPanel
    }

    function generateGrid(rows, columns) {
        if (rows === undefined) rows = rootGrid.rows
        if (columns === undefined) columns = rootGrid.columns

        gridArr = []
        var index = 0

        for (var r = 0; r < rows; r++) {
            var colArray = []
            for (var c = 0; c < columns; c++) {
                var component = Qt.createComponent('Cell.qml')
                var cell = component.createObject(grid, {
                                                      "x": c * 66,
                                                      "y": r * 66,
                                                      "rowIndex": r,
                                                      "colIndex": c,
                                                      "showIndices": showCellIndices
                                                  })

                colArray.push(cell)
                //                console.log(cell.rowIndex + ", " + cell.colIndex + " :: " + cell.alive)
                index++
            }

            gridArr.push(colArray)
        }
    }

    function previewShape(position) {
        clearPreview()
        var result = Shape.placeShape(debugPanel.shapeList.currentText, position)
        if (result[0]) {
            for (var index = 0; index < result[1].length; index++) {
                result[1][index].preview = true
            }
        }
    }

    function rotateShape() {
        Shape.rotateShape(debugPanel.shapeList.currentText)
    }

    function placeShape(shape, position) {
        if (shape === undefined) shape = debugPanel.shapeList.currentText
        if (position === undefined) position = currentPosition

        var tint = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)

        var result = Shape.placeShape(shape, position)
        if (result[0]) {
            for (var index = 0; index < result[1].length; index++) {
                result[1][index].alive = true
                result[1][index].tint = tint
            }
        }
    }

    function clearGrid() {
//        for (var x = 0; x < gridArr.length; x++) {
//            var colArr = gridArr[x]
//            for (var y = 9; y < colArr.length; y++) {
//                colArr[y].alive = false
//            }
//        }
        recycleGrid()
    }

    function clearPreview() {
        for (var x = 0; x < gridArr.length; x++) {
            var colArr = gridArr[x]
            for (var y = 0; y < colArr.length; y++) {
                colArr[y].preview = false
            }
        }
    }

    function recycleGrid(rows, columns) {
        if (rows) rootGrid.rows = rows
        else rows = rootGrid.rows
        if (columns) rootGrid.columns = columns
        else columns = rootGrid.columns

        for (var x = 0; x < gridArr.length; x++) {
            var colArr = gridArr[x]
            for (var y = 0; y < colArr.length; y++) {
                colArr[y].destroy()
            }
        }

        generateGrid(rows, columns)
    }

    function getGridPositions() {
        var arr = []
        for (var x = 0; x < gridArr.length; x++) {
            var colArr = gridArr[x]
            for (var y = 0; y < colArr.length; y++) {
                arr.push(colArr[y].position)
            }
        }

        return arr
    }

    function getEmptyGridPositions() {
        var arr = []
        for (var x = 0; x < gridArr.length; x++) {
            var colArr = gridArr[x]
            for (var y = 0; y < colArr.length; y++) {
                var cell = colArr[y]
                if (!cell.alive) arr.push(cell.position)
            }
        }

        return arr
    }

    function permuteShapesTest(shapeStr) {
        debugPanel.permuteShapesTest(shapeStr)
    }

    /* Cause js scripts has func name placeShape(). To avoid same name */
    function placeShapeInGrid(shape, position) {
        placeShape(shape, position)
    }
}
