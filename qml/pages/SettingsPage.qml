import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Settings")
            }
            Button {
                text: qsTr("Clear Cookie Blacklist")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    remorse.execute(qsTr("Clearing"), function() {
                        py.call(appname+'.change_config', ['SETTINGS', 'DomainBlacklist', ''], function(result) {
                            cookieBlacklist = []
                        })
                    })
                }
            }
            Button {
                text: qsTr("Clear Cookie Whitelist")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    remorse.execute(qsTr("Clearing"), function() {
                        py.call(appname+'.change_config', ['SETTINGS', 'DomainWhitelist', ''], function(result) {
                            cookieWhitelist = []
                        })
                    })
                }
            } // Button
            TextSwitch {
                text: qsTr("WLAN only")
                description: qsTr("Downloads adblock lists only if connected to WLAN (tested only on Jolla phones)")
                onCheckedChanged: {
                    py.call(appname+'.change_config', ['SETTINGS', 'WlanOnly', checked], function(result) {
                    })
                }

                Component.onCompleted: {
                    py.call(appname+'.get_config_bool', ['SETTINGS', 'WlanOnly', true], function(result) {
                        checked = result
                    })
                }
            }
        }
    }
    RemorsePopup { id: remorse }
}

