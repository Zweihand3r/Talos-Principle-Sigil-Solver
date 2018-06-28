import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: rootSelection
    width: 640
    height: 480

    property var selectorModel: ["T", "L", "J", "S", "2", "I", "O"]
    property int rows: 0
    property int columns: 0

    signal selectionFinalised(var shapeArray)

    function presentSelection() { x = 0 }
    function dismissSelection() { x = -width }

    Rectangle { anchors.fill: parent; color: "black"; opacity: 0.8 }

    GridView {
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 12 }
        width: cellWidth * 5; height: cellHeight * 3
        cellWidth: 70; cellHeight: 70; interactive: false

        model: selectedModel
        delegate: Image {
            width: 64; height: 64
            source: '../Images/' + shape + '.png'
            opacity: clicky.containsMouse ? 0.32 : 1
            Behavior on opacity { OpacityAnimator { duration: 120 } }

            MouseArea {
                id: clicky
                anchors.fill: parent
                hoverEnabled: true
                onClicked: selectedModel.remove(index, 1)
            }
        }

        ListModel {
            id: selectedModel
        }
    }

    MouseArea {
        id: goArea
        width: 144; height: 44
        anchors { bottom: selectorLayout.top; horizontalCenter: parent.horizontalCenter; bottomMargin: 20 }
        onClicked: handleClick()

        Rectangle {
            color: "transparent"
            anchors.fill: parent; radius: 6
            border { width: 2; color: "#FFFFFF" }
        }

        Text {
            font.pixelSize: 25; anchors.centerIn: parent
            text: "Solve"; color: "white"
        }
    }

    ColumnLayout {
        id: selectorLayout
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 12 }
        spacing: 20

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            ColumnLayout {
                Label {
                    text: "Rows"; font.pixelSize: 17; color: "#FFFFFF"
                    Layout.alignment: Qt.AlignHCenter
                }

                SpinBox {
                    Layout.preferredWidth: 128; Layout.preferredHeight: 32
                    from: 1; to: 10; editable: true; onValueChanged: rows = parseInt(value)
                }
            }

            ColumnLayout {
                Label {
                    text: "Columns"; font.pixelSize: 17; color: "#FFFFFF"
                    Layout.alignment: Qt.AlignHCenter
                }

                SpinBox {
                    Layout.preferredWidth: 128; Layout.preferredHeight: 32
                    from: 1; to: 10; editable: true; onValueChanged: columns = parseInt(value)
                }
            }
        }

        RowLayout {
            Repeater {
                model: selectorModel
                Image {
                    Layout.preferredWidth: 44; Layout.preferredHeight: 44
                    source: '../Images/' + modelData + '.png'
                    scale: mouse.containsMouse ? (mouse.pressed ? 0.96 : 1.1) : 1
                    Behavior on scale { ScaleAnimator { duration: 80 } }
                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: selectedModel.append({ "shape": modelData })
                    }
                }
            }
        }
    }

    function handleClick() {
        var shapeStr = ""
        if (selectedModel.count > 0) {
            for (var index = 0; index < selectedModel.count; index++)
                shapeStr += selectedModel.get(index).shape
        }
        else {
            console.log("No shapes selected")
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

        selectionFinalised(shapeArr)
        dismissSelection()
    }
}
