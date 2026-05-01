import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    SilicaGridView {
        id: listView
        model: menuModel
        anchors.fill: parent
        header: PageHeader {
            //title: appName
            title: appNameFull
        }
        cellWidth: width / 2
        cellHeight: Theme.itemSizeHuge * 2
        delegate: Loader {
            source: menuItemSource
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
        }

        VerticalScrollDecorator {}
    }
    ListModel {
        id: menuModel
        ListElement {
            name: qsTr("Adblock Lists")
            image: "image://theme/icon-l-attention"
            //image: "file://usr/share/themes/sailfish-default/silica/z1.75/icons-monochrome/icon-l-attention.png"
            itemPage: "SourcesPage.qml"
            menuItemSource: "components/SourcesMenuItem.qml"
        }
        ListElement {
            name: qsTr("Cookies")
            image: "image://theme/icon-l-transfer"
            itemPage: "CookiesPage.qml"
            menuItemSource: "components/CookiesMenuItem.qml"
        }
        ListElement {
            name: qsTr("Documentation")
            image: "image://theme/icon-l-document"
            itemPage: "DocsPage.qml"
            menuItemSource: "components/GeneralMenuItem.qml"
        }
        ListElement {
            name: qsTr("Settings")
            image: "image://theme/icon-l-developer-mode"
            itemPage: "SettingsPage.qml"
            menuItemSource: "components/GeneralMenuItem.qml"
        }
    }
}
