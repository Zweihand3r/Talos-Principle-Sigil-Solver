import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import '../Scripts/Permutation_Test.js' as Ptest

Rectangle {
    id: rootPt
    width: parent.width
    height: parent.height
    color: "#788990"

    Component.onCompleted: {
        var str = "AB"
        Ptest.permuteString(str)
    }

    ColumnLayout {
        spacing: 12
        anchors { left: parent.left; top: parent.top; right: parent.right; margins: 48 }

        Repeater {
            model: ["Permute", "Permute Reduce", "Permute Legacy", "Compare"]
            RowLayout {
                Layout.fillWidth: true

                TextField {
                    id: tf
                    Layout.fillWidth: true
                    Keys.onReturnPressed: handleButtonClicks(modelData, text)
                }

                Button {
                    text: modelData
                    Layout.preferredWidth: 120
                    onClicked: handleButtonClicks(modelData, tf.text)
                }
            }
        }
    }

    function handleButtonClicks(title, str) {
        var arr = str.split("")
        var res = []

        if (title === "Compare") {
            console.time("Permute")
            var perm = Ptest.permute_xN(arr)
            console.timeEnd("Permute")

            console.time("Permute Reduce")
            Ptest.permute_reduce(arr)
            console.timeEnd("Permute Reduce")

            console.time("Permute Legacy")
            var leg = Ptest.permute_Legacy(arr)
            console.timeEnd("Permute Legacy")

            return
        }

        console.time(title)
        switch (title) {
        case "Permute": res = Ptest.permute_xN(arr); break
        case "Permute Reduce": res = Ptest.permute_reduce(arr); break
        case "Permute Legacy": res = Ptest.permute_Legacy(arr); break
        }

        res.forEach(function(element) { console.log(element)})
        console.timeEnd(title)
    }
}
