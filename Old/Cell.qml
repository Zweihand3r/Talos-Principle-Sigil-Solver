import QtQuick 2.7

Rectangle {
    implicitWidth: 64
    implicitHeight: 64

    property bool showIndices: true

    property var position: [rowIndex, colIndex]
    property color tint: "#FFFFFF"
    property string text: "0"
    property int rowIndex: 0
    property int colIndex: 0
    property bool alive: false
    property bool preview: false

    color: alive ? tint : "#00000000"
    border.width: 2
    border.color: preview ? "#FFFFFF" : "#333333"
    Behavior on color { ColorAnimation { duration: 120 }}
    Behavior on border.color { ColorAnimation { duration: 80 }}

    Text {
        anchors.centerIn: parent
        font.pixelSize: 19
        text: rowIndex + ", " + colIndex
        color: alive ? "black" : "white"
        visible: showIndices
    }

    MouseArea {
        id: clicky
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onEntered: previewShape(position)
        onExited: clearPreview()
        onPressed: cellClickHandler()
    }

    function cellClickHandler() {
        if (clicky.pressedButtons & Qt.LeftButton) {
            currentPosition = position
            placeShape()
        }
        else {
            rotateShape()
            previewShape(position)
        }
    }
}
