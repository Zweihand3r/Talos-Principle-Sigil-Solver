import QtQuick 2.7

Rectangle {
    property color tint: "#323232"
    property bool origin: false

    width: 8; height: 8; color: "#00000000"
    border { width: (origin ? 2 : 4); color: tint }
    Behavior on border.width { NumberAnimation { duration: 120 }}
}
