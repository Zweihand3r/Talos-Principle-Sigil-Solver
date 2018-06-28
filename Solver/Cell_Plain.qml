import QtQuick 2.7

Item {
    width: 64; height: 64

    function draw(color) {
        rec.color = color
        rec.scale = 1
    }

    function reset() {
        rec.color = "#00000000"
        rec.scale = 0.24
    }

    Rectangle {
        anchors.fill: parent
        id: rec; color: "#00000000"; scale: 0.24
        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on scale { ScaleAnimator { duration: 120 } }
    }
}
