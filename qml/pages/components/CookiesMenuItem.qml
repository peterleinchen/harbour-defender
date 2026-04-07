import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: delegate

    Image {
        source: image
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: Theme.paddingLarge * 3
        }
    }
    Column {
        width: parent.width
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge
        }
        DetailItem {
            label: qsTr("Cookies")
            value: stats.cookies_count
            anchors.horizontalCenter: parent.horizontalCenter
        }
        DetailItem {
            label: qsTr("Domains")
            value: stats.domains_count
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            x: Theme.paddingLarge
            text: qsTr("Cookie Manager")

            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    Rectangle {
        anchors.centerIn: parent
        width: parent.width - Theme.paddingMedium
        height: parent.height - Theme.paddingMedium
        opacity: delegate.highlighted ? 0.2 : 0.1
        color: delegate.highlighted ? Theme.highlightBackgroundColor : Theme.secondaryHighlightColor
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../CookiesPage.qml"))
} // BackgroundItem
