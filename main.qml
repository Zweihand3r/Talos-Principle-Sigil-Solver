import QtQuick 2.9
import QtQuick.Window 2.2

import './Content'
import './OldContent'

Window {
    id: mainWindow
    visible: true
    width: applicationWidth
    height: applicationHeight
    title: qsTr("Sigil Solver")

    property int applicationWidth: 640
    property int applicationHeight: 480

    OldContent {}

    /*Content {}*/
}
