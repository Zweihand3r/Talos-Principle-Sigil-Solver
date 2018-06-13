import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import '../Scripts/Test.js' as Test

Item {
    id: rootDP
    width: toolBar.width + 20
    height: toolBar.height + 20

    property ComboBox shapeList: shapeList
    property bool toolBarVisible: false

    property var solutions: []
    property int solutionIndex: 0
    property bool navigateSolutions: false

    Component.onCompleted: menuButt.forceActiveFocus()
    onToolBarVisibleChanged: if (!toolBarVisible) menuButt.forceActiveFocus()

    Button {
        id: menuButt
        x: 20; y: 20
        text: "< Menu >"
        onClicked: toolBarVisible = true
        visible: !toolBarVisible
        Keys.onTabPressed: toolBarVisible = true
    }

    Rectangle {
        anchors.fill: parent
        color: "black"; opacity: 0.75
        visible: toolBarVisible
    }

    ColumnLayout {
        id: toolBar
        width: 180
        anchors.centerIn: parent
        visible: toolBarVisible

        RowLayout {
            Text {
                text: "Shapes"
                color: "white"; font.pixelSize: 21
                Layout.preferredWidth: 78
                Layout.alignment: Qt.AlignVCenter
            }

            ComboBox {
                id: shapeList
                model: ["T", "L", "LRev", "S", "SRev", "I", "Bx"]
                Layout.fillWidth: true
            }
        }

        Button {
            text: "Reset Grid"
            onClicked: recycleGrid(rows, columns)
            Layout.fillWidth: true
        }

        Item {
            Layout.preferredHeight: 20
            Layout.fillWidth: true
        }

        ComboBox {
            id: testList
            model: ["Solver", "Set Grid", "Permutation", "Variant Permutation", "Fixed L", "Recursion Bx", "Recursion Assorted", "L_3 <> LRev_2 <> S", "LRev > S > L"]
            Layout.fillWidth: true
            onCurrentIndexChanged: tf_shape.text = ""
        }

        TextField {
            id: tf
            placeholderText: "<rows> <cols>"
            text: rows + " " + columns
            Layout.fillWidth: true
            visible: testList.currentIndex === 1
            Keys.onReturnPressed: placeSequenceTest()
            Keys.onTabPressed: toolBarVisible = false
            Keys.onUpPressed: testList.currentIndex = 0
            Keys.onDownPressed: testList.currentIndex++
            onVisibleChanged: if (visible) forceActiveFocus()
        }

        TextField {
            id: tf_shape
            placeholderText: {
                switch (testList.currentIndex) {
                case 0: return "eg: L Lrev S"
                case 2: return "eg: ABCD"
                case 3: return "eg: ABC|1234|&@"
                default: return ""
                }
            }

            Layout.fillWidth: true
            visible: testList.currentIndex === 0 || testList.currentIndex === 2 || testList.currentIndex === 3
            Keys.onReturnPressed: placeSequenceTest()
            Keys.onTabPressed: toolBarVisible = false
            Keys.onUpPressed: testList.currentIndex = testList.currentIndex > 0 ? (testList.currentIndex - 1) : 0
            Keys.onDownPressed: testList.currentIndex++
            Keys.onRightPressed: goToNextSolution(true)
            Keys.onLeftPressed: goToNextSolution(false)
            onVisibleChanged: if (visible) forceActiveFocus()
        }

        Text {
            id: infoText
            visible: navigateSolutions
            Layout.preferredWidth: parent.width - 12
            font.pixelSize: 15
            color: "white"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Button {
            id: listActionButton
            text: testList.currentIndex < 4 ? "Go" : "Test"
            onClicked: placeSequenceTest()
            focus: testList.currentIndex > 3
            Keys.onReturnPressed: placeSequenceTest()
            Keys.onTabPressed: toolBarVisible = false
            Keys.onUpPressed: testList.currentIndex--
            Keys.onDownPressed: testList.currentIndex = testList.currentIndex < (testList.count - 1) ? (testList.currentIndex + 1) : (testList.count - 1)
            Layout.fillWidth: true
        }

        Item {
            Layout.preferredHeight: 20
            Layout.fillWidth: true
        }

        Button {
            text: "Close"
            onClicked: toolBarVisible = false
            Layout.fillWidth: true
        }
    }

    // Fn

    function placeSequenceTest() {
        navigateSolutions = false

        var shapeKeys = [
                    ["L", "L_1", "L_2", "L_3"],
                    ["LRev", "LRev_1", "LRev_2", "LRev_3"],
                    ["Bx"]
                ]

        switch (testList.currentText) {
        case "Permutation": Test.permutation(tf_shape.text); break
        case "Variant Permutation": Test.permuteVariant(tf_shape.text); break
        case "Fixed L": Test.placeFixedLShapesTest(); break
        case "Recursion Bx": Test.placeRecursionTest(); break
        case "Recursion Assorted": Test.placeRecursionTest_2(); break
        case "L_3 <> LRev_2 <> S": Test.simplePlacement(); break
        case "LRev > S > L": Test.simplePlacement_Variant(); break
        case "Solver": solverAction(); break
        case "Set Grid":
            var limits = tf.text.split(" ")
            recycleGrid(parseInt(limits[0]), parseInt(limits[1]))
            break
        }
    }

    function solverAction() {
        console.log("\n\n--------------------- New Solve Session ----------------------")

        var txt = tf_shape.text
        var arr = txt.split("_")
        var str = arr ? arr[0] : txt

        if (arr[1]) {
            switch (arr[1]) {
            case "Alt":
                console.time("PermuteShapes_Alt")
                Test.permuteShapes_Alt(str)
                console.timeEnd("PermuteShapes_Alt")
                break

            case "All":
                navigateSolutions = true
                solutionIndex = 0

                console.time("PermuteShapes_All")
                solutions = Test.findAllSolutions(str)
                console.timeEnd("PermuteShapes_All")

                printInfo()
                placeSolution()
                break

            case "Par":
                solutions = Test.permutePartial(str)
                break
            }
        }
        else {
            console.time("PermuteShapes")
            Test.permuteShapes(str)
            console.timeEnd("PermuteShapes")
        }
    }

    function goToNextSolution(next) {
        if (!navigateSolutions) return

        if (next) {
            if (solutionIndex < solutions.length - 1) {
                solutionIndex++
                placeSolution()
            }
        }
        else
            if (solutionIndex > 0) {
                solutionIndex--
                placeSolution()
            }

        printInfo()
    }

    function placeSolution() {
        clearGrid()

        var solution_ = solutions[solutionIndex]
        var solutionShapeKeys = solution_[0]
        var solutionPositions = solution_[1]

        for (var index = 0; index < solutionShapeKeys.length; index++) {
            var shapeKey = solutionShapeKeys[index]
            var position = solutionPositions[index]
            placeShapeInGrid(shapeKey, position)
        }
    }

    function printInfo() {
        infoText.text = solutions[solutionIndex][0] + "\n" +
                "<- " + (solutionIndex + 1) + " / " + solutions.length + " ->"
    }

    function permuteShapesTest(shapeStr) {
        Test.permuteShapes(shapeStr)
    }
}
