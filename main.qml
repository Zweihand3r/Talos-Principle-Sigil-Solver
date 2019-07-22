import QtQuick 2.9
import QtQuick.Window 2.2

import './OldContent'

Window {
    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Sigil Solver")

    OldContent {}
}
