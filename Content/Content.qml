import QtQuick 2.7

import './qml'

Item {
    id: rootContent
    width: applicationWidth
    height: applicationHeight

    CPP_Tests {}

    function logArray(arr) {
        arr.forEach(function(item, index) {
            console.log((index + 1) + ": " + item)
        })
    }
}
