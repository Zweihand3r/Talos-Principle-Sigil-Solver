import QtQuick 2.0

import './Old'
import './V2'
import './Solver'

Item {
    width: 640
    height: 480

    //    PuzzleGrid {
    //        id: puzzleGrid
    //    }

    //    PuzzleGrid_ {
    //        id: puzzleGrid_
    //        onWidthChanged: mainWindow.width = width
    //        onHeightChanged: mainWindow.height = height

    //        Component.onCompleted: compareVersions()
    //    }

    //    PermutationTest {

    //    }

    //    V3 {
    //        onWidthChanged: mainWindow.width = width
    //        onHeightChanged: mainWindow.height = height
    //    }

        SolverGrid {
            onWidthChanged: mainWindow.width = width
            onHeightChanged: mainWindow.height = height
        }

        function compareVersions() {
            var rows = 6
            var columns = 4
            var shapeStrOld = "T T LRev LRev L SRev"
            var shapeStr = "TTJJL2"

            puzzleGrid.recycleGrid(rows, columns)

            puzzleGrid_.clearGrid()
            puzzleGrid_.generateGrid(rows, columns)

            console.time("Old")
            puzzleGrid.permuteShapesTest(shapeStrOld)
            console.timeEnd("Old")

            console.time("V2")
            puzzleGrid_.permuteShapes(shapeStr)
            console.timeEnd("V2")
        }
}
