import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import '../Components'

Item {
    width: 40
    height: Math.min(parent.height, colLayout.height)

    property var shapes: ["T", "L", "J", "S", "2", "I", "O"]
    property string currentShape: { return shapes[currentShapeIndex] }
    property int currentShapeIndex: 0

    function getPositions(shapeKey, position) { return internal.getShapePostions(shapeKey, position) }
    function preview(position) { internal.previewShape(position) }
    function place(shapeKey, position) { internal.placeShape(shapeKey, position) }
    function rotate() { internal.rotateShape() }
    function getDictionary() { return internal.shapeDictionary }
    function getInitialKeys(key) { return internal.getInitialShapeKeys(key) }

    Flickable {
        anchors { fill: parent; margins: 4 }
        contentWidth: width; contentHeight: colLayout.height
        interactive: contentHeight > height

        ColumnLayout {
            id: colLayout
            width: parent.width

            MouseArea {
                id: t_shape
                width: 32; height: 32; hoverEnabled: true
                opacity: currentShapeIndex === 0 ? 1 : 0.44
                onClicked: currentShapeIndex = 0
                onEntered: scale = 1.1
                onExited: scale = 1
                Behavior on opacity { OpacityAnimator { duration: 120 }}
                Behavior on scale { ScaleAnimator { duration: 80 }}
                Behavior on rotation { RotationAnimator { duration: 120 }}
                Item {
                    width: 24; height: 16
                    anchors.centerIn: parent
                    ShapeFragment { origin: t_shape.rotation % 360 === 0 || t_shape.rotation % 360 === 90 }
                    ShapeFragment { x: 8 }
                    ShapeFragment { x: 16; origin: t_shape.rotation % 360 === 270 }
                    ShapeFragment { x: 8; y: 8; origin: t_shape.rotation % 360 === 180 }
                }
            }

            MouseArea {
                id: l_shape
                width: 32; height: 32; hoverEnabled: true
                opacity: currentShapeIndex === 1 ? 1 : 0.44
                onClicked: currentShapeIndex = 1
                onEntered: scale = 1.1
                onExited: scale = 1
                Behavior on opacity { OpacityAnimator { duration: 120 }}
                Behavior on scale { ScaleAnimator { duration: 80 }}
                Behavior on rotation { RotationAnimator { duration: 120 }}
                Item {
                    width: 16; height: 24
                    anchors.centerIn: parent
                    ShapeFragment { origin: l_shape.rotation % 360 === 0 }
                    ShapeFragment { y: 8 }
                    ShapeFragment { y: 16; origin: l_shape.rotation % 360 === 90 }
                    ShapeFragment { x: 8; y: 16; origin: l_shape.rotation % 360 === 180 || l_shape.rotation % 360 === 270 }
                }
            }

            MouseArea {
                id: lrev_shape
                width: 32; height: 32; hoverEnabled: true
                opacity: currentShapeIndex === 2 ? 1 : 0.44
                onClicked: currentShapeIndex = 2
                onEntered: scale = 1.1
                onExited: scale = 1
                Behavior on opacity { OpacityAnimator { duration: 120 }}
                Behavior on scale { ScaleAnimator { duration: 80 }}
                Behavior on rotation { RotationAnimator { duration: 120 }}
                Item {
                    width: 16; height: 24
                    anchors.centerIn: parent
                    ShapeFragment { x: 8; origin: lrev_shape.rotation % 360 === 0 ||
                                                  lrev_shape.rotation % 360 === 270 }
                    ShapeFragment { x: 8; y: 8 }
                    ShapeFragment { x: 8; y: 16; origin: lrev_shape.rotation % 360 === 180 }
                    ShapeFragment { y: 16; origin: lrev_shape.rotation % 360 === 90 }
                }
            }

            MouseArea {
                id: s_shape
                width: 32; height: 32; hoverEnabled: true
                opacity: currentShapeIndex === 3 ? 1 : 0.44
                onClicked: currentShapeIndex = 3
                onEntered: scale = 1.1
                onExited: scale = 1
                Behavior on opacity { OpacityAnimator { duration: 120 }}
                Behavior on scale { ScaleAnimator { duration: 80 }}
                Behavior on rotation { RotationAnimator { duration: 120 }}
                Item {
                    width: 24; height: 16
                    anchors.centerIn: parent
                    ShapeFragment { x: 16; origin: s_shape.rotation % 360 === 270 }
                    ShapeFragment { x: 8; origin: s_shape.rotation % 360 === 0 }
                    ShapeFragment { x: 8; y: 8; origin: s_shape.rotation % 360 === 180  }
                    ShapeFragment { y: 8; origin: s_shape.rotation % 360 === 90 }
                }
            }

            MouseArea {
                id: srev_shape
                width: 32; height: 32; hoverEnabled: true
                opacity: currentShapeIndex === 4 ? 1 : 0.44
                onClicked: currentShapeIndex = 4
                onEntered: scale = 1.1
                onExited: scale = 1
                Behavior on opacity { OpacityAnimator { duration: 120 }}
                Behavior on scale { ScaleAnimator { duration: 80 }}
                Behavior on rotation { RotationAnimator { duration: 120 }}
                Item {
                    width: 24; height: 16
                    anchors.centerIn: parent
                    ShapeFragment { origin: srev_shape.rotation % 360 === 0 || srev_shape.rotation % 360 === 90 }
                    ShapeFragment { x: 8 }
                    ShapeFragment { x: 8; y: 8 }
                    ShapeFragment { x: 16; y: 8; origin: srev_shape.rotation % 360 === 180 || srev_shape.rotation % 360 === 270 }
                }
            }

            MouseArea {
                id: i_shape
                width: 32; height: 32; hoverEnabled: true
                opacity: currentShapeIndex === 5 ? 1 : 0.44
                onClicked: currentShapeIndex = 5
                onEntered: scale = 1.1
                onExited: scale = 1
                rotation: 90
                Behavior on opacity { OpacityAnimator { duration: 120 }}
                Behavior on scale { ScaleAnimator { duration: 80 }}
                Behavior on rotation { RotationAnimator { duration: 120 }}
                Item {
                    width: 32; height: 8
                    anchors.centerIn: parent
                    ShapeFragment { origin: i_shape.rotation % 360 === 0 ||
                                            i_shape.rotation % 360 === 90 }
                    ShapeFragment { x: 8; width: 8; height: 8 }
                    ShapeFragment { x: 16; width: 8; height: 8 }
                    ShapeFragment { x: 24; origin: i_shape.rotation % 360 === 180 ||
                                                   i_shape.rotation % 360 === 270 }
                }
            }

            MouseArea {
                id: bx_shape
                width: 32; height: 32; hoverEnabled: true
                opacity: currentShapeIndex === 6 ? 1 : 0.44
                onClicked: currentShapeIndex = 6
                onEntered: scale = 1.1
                onExited: scale = 1
                Behavior on opacity { OpacityAnimator { duration: 120 }}
                Behavior on scale { ScaleAnimator { duration: 80 }}
                Item {
                    width: 16; height: 16
                    anchors.centerIn: parent
                    ShapeFragment { origin: true }
                    ShapeFragment { x: 8 }
                    ShapeFragment { y: 8 }
                    ShapeFragment { x: 8; y: 8 }
                }
            }
        }
    }

    QtObject {
        id: internal

        property var rotationIndices: [0, 0, 0, 0, 0, 0, 0]
        property var shapeDictionary: {
            "T": ["T", "T1", "T2", "T3"],
            "L": ["L", "L1", "L2", "L3"],
            "J": ["J", "J1", "J2", "J3"],
            "S": ["S", "S1"],
            "2": ["2", "21"],
            "I": ["I", "I1"],
            "O": ["O"]
        }
        property var shapePositions: {
            "T": [[0, 0], [0, 1], [0, 2], [1, 1]],
            "T1": [[0, 0], [1, -1], [1, 0], [2, 0]],
            "T2": [[0, 0], [1, -1], [1, 0], [1, 1]],
            "T3": [[0, 0], [1, 0], [1, 1], [2, 0]],

            "L": [[0, 0], [1, 0], [2, 0], [2, 1]],
            "L1": [[0, 0], [0, 1], [0, 2], [1, 0]],
            "L2": [[0, 0], [0, 1], [1, 1], [2, 1]],
            "L3": [[0, 0], [1, -2], [1, -1], [1, 0]],

            "J": [[0, 0], [1, 0], [2, -1], [2, 0]],
            "J1": [[0, 0], [1, 0], [1, 1], [1, 2]],
            "J2": [[0, 0], [0, 1], [1, 0], [2, 0]],
            "J3": [[0, 0], [0, 1], [0, 2], [1, 2]],

            "S": [[0, 0], [0, 1], [1, -1], [1, 0]],
            "S1": [[0, 0], [1, 0], [1, 1], [2, 1]],

            "2": [[0, 0], [0, 1], [1, 1], [1, 2]],
            "21": [[0, 0], [1, -1], [1, 0], [2, -1]],

            "I": [[0, 0], [1, 0], [2, 0], [3, 0]],
            "I1": [[0, 0], [0, 1], [0, 2], [0, 3]],

            "O": [[0, 0], [1, 0], [0, 1], [1, 1]]
        }

        function getCurrentShapeKey() {
            return shapeDictionary[currentShape][rotationIndices[currentShapeIndex]]
        }

        function getInitialShapeKeys(key) {
            switch (key) {
            case "T": return ["T", "T3"]
            case "L": return ["L", "L1", "L2"]
            case "J": return ["J1", "J2", "J3"]
            case "S": return ["S1"]
            case "I": return ["I", "I1"]
            case "2":
            case "O": return [key]
            }
        }

        function rotateShape() {
            clearPreview()

            switch (currentShapeIndex) {
            case 0:
            case 1:
            case 2:
                if (rotationIndices[currentShapeIndex] < 3) rotationIndices[currentShapeIndex]++
                else rotationIndices[currentShapeIndex] = 0
                break

            case 3:
            case 4:
            case 5:
                (rotationIndices[currentShapeIndex]) =
                        rotationIndices[currentShapeIndex] === 0 ? 1 : 0
                break
            }

            setListRotation(currentShapeIndex)

            /* Commenting this stops odd preview placement when rotating preview if shape already drawn */
            /* This happens cuz rotating shape auto calls previewShape(). Keeping for future ref */
//            previewShape(currentPosition)
        }

        /* Transposes shape positions to specified 'position' and returns positions */
        function getShapePostions(shapeKey, position) {
            var positions = []
            var shapePositions_ = shapePositions[shapeKey]
            shapePositions_.forEach(function(shapePos) {
                positions.push([position[0] + shapePos[0], position[1] + shapePos[1]])
            })

            return positions
        }

        function placeShape(shapeKey, position) {
            if (typeof(shapeKey) === "object") {
                position = shapeKey
                shapeKey = getCurrentShapeKey()
            }

            var positions = getShapePostions(shapeKey, position)
            if (checkEmpty(positions)) {
                drawShape(positions)
            }
        }

        function previewShape(position) {
            var positions = getShapePostions(getCurrentShapeKey(), position)
            setPreview(positions)
        }


        /* --------------------------------------------------------------------------- */

        function setListRotation(index) {
            colLayout.children[index].rotation += 90
        }
    }
}
