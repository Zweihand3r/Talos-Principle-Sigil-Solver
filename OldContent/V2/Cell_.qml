import QtQuick 2.7

Rectangle {
    id: rootCell
    implicitWidth: 64
    implicitHeight: 64

    property bool showIndices: true

    property var position: [rowIndex, colIndex]
    property string text: "0"
    property int rowIndex: 0
    property int colIndex: 0
    property bool preview: false
    property bool previewIncomplete: false

    color: "#00000000"
    border.width: preview ? 4 : 2
    border.color: preview ? (previewIncomplete ? "#FF3232" : "#323232") : "#989898"
    Behavior on color { ColorAnimation { duration: 120 }}
    Behavior on border.color { ColorAnimation { duration: 80 }}
    Behavior on border.width { NumberAnimation { duration: 80 }}

    onColorChanged: indicesText.color = "#FFFFFF"

    Text {
        id: indicesText
        anchors.centerIn: parent
        font.pixelSize: 19
        text: rowIndex + ", " + colIndex
        color: "#989898"
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
            cellClickAction()
        }
        else {
            rotateShape()
            previewShape(position)
        }
    }
}
