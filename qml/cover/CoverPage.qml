import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

//        DetailItem {
//            label: qsTr("Last")
//            value: (stats.last_time > 0) ? stats.last_time.toLocaleTimeString() : '?'
//            anchors.horizontalCenter: parent.horizontalCenter
//        }
//        DetailItem {
//            label: qsTr("Enabled")
//            value: (stats.last_sources > 0) ? qsTr('Yes') : qsTr('No')
//            anchors.horizontalCenter: parent.horizontalCenter
//        }
        Image {
            id: appIcon
            source: "../pages/images/harbour-defender.svg"
            width: Theme.itemSizeLarge
            height: width
            anchors.centerIn: parent
            opacity: (stats != undefined) ? (stats.last_sources > 0) ? 1 : 0.5 : 0.1
        }

        Label {
            x: Theme.paddingLarge
            text: appName
            color: Theme.primaryColor
            anchors {
                top: appIcon.bottom
                topMargin: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
        }

//    CoverActionList {
//        id: coverAction

//        CoverAction {
//            iconSource: "image://theme/icon-cover-next"
//        }

//        CoverAction {
//            iconSource: "image://theme/icon-cover-pause"
//        }
//    }
}

