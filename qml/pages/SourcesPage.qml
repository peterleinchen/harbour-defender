import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    SilicaListView {
        id: listView
        model: sourcesModel
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: qsTr("Disable all")
                onClicked: {
                    remorse.execute(qsTr("Preparing disable"), function() {
                        disableAll()
                    })
                }
            }
            MenuItem {
                text: qsTr("Cancel/clear update loop")
                onClicked: {
                    remorse.execute(qsTr("Preparing cancel/clear"), function() {
                        clearUpdateLoop()
                    })
                }
            }
            MenuItem {
                text: qsTr("Show error log (just in case ;)")
                onClicked: {
                    remorse.execute(qsTr("Pulling up error.log (only if exists)"), function() {
                        showErrorLog()
                    })
                }
            }
            MenuItem {
                text: qsTr("Restart Android/App Support")
                onClicked: {
                    remorse.execute(qsTr("Preparing Android restart"), function() {
                        restartAndroidSupport()
                    })
                }
            }
            MenuItem {
                text: qsTr("Update now")
                onClicked: {
                    remorse.execute(qsTr("Preparing update"), function() {
                        updateNow()
                    })
                }
            }
        }
        header: Column {
            width: parent.width
            PageHeader {
                title: qsTr("Sources")
            }
            ProgressBar {
                width: parent.width
                indeterminate: true
                visible: updating
                label: qsTr("Updating...")
            }
            Label {
                x: Theme.paddingLarge
                visible: updating
                width: parent.width - 2*x
                text: qsTr("Update in progress. This may take a while, but you can safely close the application and the update will finish in the background.")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                wrapMode: Text.Wrap
            }

        }

        section {
            property: "source"
            criteria: ViewSection.FullString
            delegate: SectionHeader {
                    text: section
                }
        }
        delegate: BackgroundItem {
            id: delegate

            Switch {
                id: sourceSwitch
                x: Theme.paddingLarge
                width: parent.height / 2
                height: width
                anchors.verticalCenter: parent.verticalCenter
                checked: sourceenabled
                automaticCheck: false
                onClicked: changeConfig(source_id, 'sourceenabled', !checked, index)
            }

            Label {
                text: name
                anchors {
                    left: sourceSwitch.right
                    margins: Theme.paddingLarge
                    verticalCenter: parent.verticalCenter
                }
                width: parent.width - sourceSwitch.width - 3*Theme.paddingLarge
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                truncationMode: TruncationMode.Fade
            }
            onClicked: pageStack.push(Qt.resolvedUrl("SourceDetailPage.qml"), {'sourceItem': sourcesModel.get(index), 'index': index})
        }
        VerticalScrollDecorator {}
    }

    RemorsePopup { id: remorse }
}




