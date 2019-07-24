import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import '../../OldContent/Scripts/Permutation.js' as P_JS

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors { left: parent.left; top: parent.top; right: parent.right; margins: 20 }

        Repeater {
            model: ListModel {
                ListElement { _text: "OLD SCRIPT"; _placeholder: "" } // 0
                ListElement { _text: "Array"; _placeholder: "eg: ABCD" } // 1
                ListElement { _text: "Variant"; _placeholder: "eg: ABC|123|XY" } // 2
                ListElement { _text: "NEW SCRIPT"; _placeholder: "" } // 3
                ListElement { _text: "Array_INSERT"; _placeholder: "eg: ABCD" } // 4
            }

            RowLayout {
                Layout.preferredWidth: parent.width

                Text { text: _text; color: "black"; font.bold: _placeholder === "" }

                TextField {
                    Layout.preferredWidth: 480
                    Layout.alignment: Qt.AlignRight
                    placeholderText: _placeholder
                    visible: _placeholder !== ""

                    Keys.onReturnPressed: compute(index, text)

                    Button {
                        id: clicky
                        text: "Compute"; visible: parent.length > 0
                        padding: 0; width: 98; height: parent.height - 8; anchors {
                            verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 4
                        }

                        onClicked: compute(index, parent.text)
                    }
                }
            }
        }
    }

    function compute(index, text) {
        console.time("TimeElapsedAtIndex_" + index)

        switch (index) {
        case 1:
            var arr = text.split("")
            logArray(P_JS.array(arr))
            break

        case 2:
            arr = text.split("")
            logArray(array_insert(arr))
        }

        console.timeEnd("TimeElapsedAtIndex_" + index)
    }


    /* ------------------------ FUNCTIONS ----------------------- */

    function array_insert(array) {
        var insertIndex = 1
        var _compute = [array[0]]
        var _final = []

        while (insertIndex < array.length + 1) {
            for (var index = 0; index <= insertIndex; index++) {
                const current = array[index]
                _final.push()
            }
        }
    }
}
