import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: rootControls
    width: 164; height: parent.height

    property int funcCBCurIndex: 0
    property bool navigatorActive: false

    Component.onCompleted: shapeTf.forceActiveFocus()

    function setNavigator(solutionArray) { shapeNavigator.set(solutionArray) }

    Flickable {
        anchors { fill: parent; margins: 8 }
        contentWidth: width; contentHeight: colLayout.height
        interactive: contentHeight > height

        ColumnLayout {
            id: colLayout
            width: parent.width
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true; spacing: 2

                TextField {
                    id: dimensionTf
                    placeholderText: "<rows> <columns>"
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Keys.onReturnPressed: generateGrid()
                }

                Button {
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    text: "Generate/Reset Grid"; onClicked: generateGrid()
                }
            }

            ColumnLayout {
                Layout.fillWidth: true; spacing: 2

                ComboBox {
                    id: functionCB
                    currentIndex: funcCBCurIndex
                    model: ["Permute Shapes", "Check Fit"]
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                }

                TextField {
                    id: shapeTf
                    placeholderText: getPlaceholder()
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    Keys.onReturnPressed: triggerFunction()
                    Keys.onUpPressed: functionCB.currentIndex -= functionCB.currentIndex > 0 ? 1 : 0
                    Keys.onDownPressed: functionCB.currentIndex += functionCB.currentIndex < functionCB.count - 1 ? 1 : 0
                    Keys.onTabPressed: {
                        if (navigatorActive) shapeNavigator.forceActiveFocus()
                        else dimensionTf.forceActiveFocus()
                    }
                }

                Rectangle {
                    id: shapeNavigator
                    Layout.fillWidth: true; Layout.preferredHeight: shapeNavigatorLayout.height
                    border { width: focus ? 2 : 1; color: focus ? "#2E6AEC" : "#C2C2C2" }
                    visible: navigatorActive

                    Keys.onDownPressed: { if (baseIndex !== 1) { baseIndex = 1; updateUI() }}
                    Keys.onUpPressed: { if (baseIndex !== 0) { baseIndex = 0; updateUI() }}

                    Keys.onRightPressed: next()
                    Keys.onLeftPressed: previous()

                    property int baseIndex: 0
                    property var shapeIndices: [0, 0]
                    property var shapeIndicesMax: [14, 14]
                    property var solutions: []
                    property var shapeKeys: []

                    ColumnLayout {
                        id: shapeNavigatorLayout
                        width: parent.width; spacing: 0

                        Item { Layout.preferredHeight: 4 }

                        Text {
                            Layout.alignment: Qt.AlignHCenter; color: "#323232"
                            text: (shapeNavigator.baseIndex === 0 ? "Grid" : "Shape") + " Base Solutions"
                        }

                        Item { Layout.preferredHeight: 4 }

                        Text {
                            id: shapeKeysText
                            Layout.alignment: Qt.AlignHCenter; color: "#323232"
                        }

                        Text {
                            id: gridBaseIndicatorText
                            Layout.alignment: Qt.AlignHCenter
                            color: shapeNavigator.baseIndex === 0 ? "#323232" : "#C2C2C2"
                        }

                        Text {
                            id: shapeBaseIndicatorText
                            Layout.alignment: Qt.AlignHCenter
                            color: shapeNavigator.baseIndex === 1 ? "#323232" : "#C2C2C2"
                        }

                        Item { Layout.preferredHeight: 4 }
                    }

                    function set(solutionDictionary) {
                        navigatorActive = true
                        solutions = solutionDictionary["sequences"]
                        shapeKeys = solutionDictionary["shapeKeys"]

                        shapeIndicesMax[0] = solutions[0].length
                        shapeIndicesMax[1] = solutions[1].length

                        updateUI()
                        shapeNavigator.forceActiveFocus()
                    }

                    function next() {
                        if (shapeIndices[baseIndex] < shapeIndicesMax[baseIndex] - 1) {
                            shapeIndices[baseIndex] += 1
                            updateUI()
                        }
                    }

                    function previous() {
                        if (shapeIndices[baseIndex] > 0) {
                            shapeIndices[baseIndex] -= 1
                            updateUI()
                        }
                    }

                    function drawFit() {
                        var currentFit = solutions[baseIndex][shapeIndices[baseIndex]]
                        drawSequence(currentFit)
                    }

                    function setTexts() {
                        shapeKeysText.text = shapeKeys[baseIndex][shapeIndices[baseIndex]].join(" ")
//                        console.log(shapeKeys[baseIndex][shapeIndices[baseIndex]])
                        gridBaseIndicatorText.text = "<- " + (shapeIndices[0] + 1) + "/" + (shapeIndicesMax[0]) + " ->"
                        shapeBaseIndicatorText.text = "<- " + (shapeIndices[1] + 1) + "/" + (shapeIndicesMax[1]) + " ->"
                    }

                    function updateUI() {
                        drawFit()
                        setTexts()
                    }
                }

                Button {
                    id: functionButton
                    Layout.fillWidth: true; Layout.preferredHeight: 32
                    text: "Go"; onClicked: triggerFunction()
                }
            }

            CheckBox {
                text: "Show Indices"; onClicked: toggleIndices()
                Layout.fillWidth: true; Layout.preferredHeight: 32
                Component.onCompleted: checked = showCellIndices
            }
        }
    }

    function generateGrid() {
        navigatorActive = false
        rootGrid.clearGrid()

        if (dimensionTf.text.length > 0) {
            var arr = dimensionTf.text.split(" ")
            rootGrid.generateGrid(parseInt(arr[0]), parseInt(arr[1]))
        }
        else rootGrid.generateGrid()
    }

    function triggerFunction() {
        console.log("\\____________________ New Session _____________________/")

        var input = shapeTf.text.toUpperCase()

        navigatorActive = false
        resetGrid()

        switch (functionCB.currentText) {
        case "Permute Shapes":
            var inputArr = input.toLowerCase().split("_")
            if (inputArr[1]) {
                var parameters = inputArr[1]
                input = inputArr[0].toUpperCase()

                switch (parameters) {
                case "c": permuteShapesComparision(input, false); break
                case "ca": permuteShapesComparision(input, true); break
                }
            }
            else {
                permuteShapes(input)
            }

            break

        case "Check Fit": checkFitComparision(input.split(" ")); break
        }
    }

    function getPlaceholder() {
        var egPlaceholder = "eg: "

        switch (functionCB.currentText) {
        case "Permute Shapes": return (egPlaceholder + "LJS")
        case "Check Fit": return (egPlaceholder + "L1 S L3")
        }
    }
}
