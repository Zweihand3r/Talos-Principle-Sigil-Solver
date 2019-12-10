import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import '../../Content_OLD/Scripts/Permutation.js' as Perm

Item {
    anchors.fill: parent

    Text {
        id: infoText; width: parent.width; height: 32
        text: "Only for debugging. Output displayed to Qt console"
        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; color: "red"
    }

    StackLayout {
        anchors {
            left: parent.left; top: infoText.bottom; right: parent.right; bottom: tabbar.top
        }

        /* --- Old Scripts --- */
        Item {
            ColumnLayout {
                anchors { fill: parent; margins: 20 }

                Repeater {
                    model: ListModel {
                        ListElement { _text: "Array"; _place: "abc" }
                        ListElement { _text: "Variant"; _place: "abc|123|xyz" }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTrailing

                        TextField {
                            id: oldTf
                            placeholderText: _place
                            Layout.fillWidth: true
                        }

                        Button {
                            text: _text
                            Layout.preferredWidth: 100

                            onClicked: {
                                let inputs = []
                                let res = []

                                const inputStr = oldTf.length > 0 ? oldTf.text : _place

                                switch (_text) {
                                case "Array":
                                    inputs = inputStr.split("")
                                    res = Perm.array(inputs)

                                    console.log("Tests.qml: Permutation for " + inputStr + ":")
                                    logArray(res)
                                    break

                                case "Variant":
                                    const input_temp = inputStr.split("|")
                                    input_temp.forEach(function(item) {
                                        inputs.push(item.split(""))
                                    })
                                    res = Perm.variant(inputs)

                                    console.log("Tests.qml: Permutaion alt for " + inputStr + ":")
                                    logArray(res)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    TabBar {
        id: tabbar
        width: parent.width; anchors {
            bottom: parent.bottom
        }

        Repeater {
            model: ["Old Scripts"]
            TabButton { text: modelData }
        }
    }

    function logArray(array) {
        array.forEach(item => {
                          console.log(item)
                      })
    }
}
