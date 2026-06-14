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

            SectionHeader {
                text: qsTr("Cookie lists")
            }
	    
	    Button {
                text: qsTr("Clear Cookie Blacklist")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    remorse.execute(qsTr("Clearing"), function() {
                        py.call(appname + '.change_config', ['SETTINGS', 'DomainBlacklist', ''], function(result) {
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
                        py.call(appname + '.change_config', ['SETTINGS', 'DomainWhitelist', ''], function(result) {
                            cookieWhitelist = []
                        })
                    })
                }
            }

            SectionHeader {
                text: qsTr("Update Interval")
            }
	    
	    ComboBox {
                id: intervalCombo
                width: parent.width
                label: qsTr("Interval")

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Daily")
                        onClicked: {
                            py.call(appname + '.change_config', ['SETTINGS', 'UpdateInterval', 'daily'], function(result) {})
                            py.call(appname + '.set_update_interval', ['daily'], function(result) {})
                        }
                    }
                    MenuItem {
                        text: qsTr("Weekly")
                        onClicked: {
                            py.call(appname + '.change_config', ['SETTINGS', 'UpdateInterval', 'weekly'], function(result) {})
                            py.call(appname + '.set_update_interval', ['weekly'], function(result) {})
                        }
                    }
                    MenuItem {
                        text: qsTr("Monthly")
                        onClicked: {
                            py.call(appname + '.change_config', ['SETTINGS', 'UpdateInterval', 'monthly'], function(result) {})
                            py.call(appname + '.set_update_interval', ['monthly'], function(result) {})
                        }
                    }
                }

                Component.onCompleted: {
                    py.call(appname + '.get_config_string', ['SETTINGS', 'UpdateInterval', 'daily'], function(result) {
                        if (result === 'daily') currentIndex = 0
                        else if (result === 'weekly') currentIndex = 1
                        else if (result === 'monthly') currentIndex = 2
                    })
                }
            }
	    
	    SectionHeader {
                text: qsTr("WLAN/GPRS usage")
            }
	    
	    TextSwitch {
                text: qsTr("WLAN only")
                description: qsTr("Downloads adblock lists only if connected to WLAN (tested only on Jolla phones)")
                onCheckedChanged: {
                    py.call(appname + '.change_config', ['SETTINGS', 'WlanOnly', checked], function(result) {
                    })
                }

                Component.onCompleted: {
                    py.call(appname + '.get_config_bool', ['SETTINGS', 'WlanOnly', true], function(result) {
                        checked = result
                    })
                }
            }
        }
    }

    RemorsePopup { id: remorse }
}
