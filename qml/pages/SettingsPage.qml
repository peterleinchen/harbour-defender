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
                text: qsTr("Update")
            }
	    
	    ComboBox {
                id: cbInterval
                width: parent.width
		label: qsTr("Interval time")

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
                    py.call(appname + '.get_config_string', ['SETTINGS', 'UpdateInterval', 'weekly'], function(result) {
                        if (result === 'daily') currentIndex = 0
                        else if (result === 'weekly') currentIndex = 1
                        else if (result === 'monthly') currentIndex = 2
                    })
	        }
            }

	    ComboBox {
                id: cbCookiesDeletion
                width: parent.width
		label: qsTr("Delete cookies on update")
		property bool pageIsLoaded: false
		//onActivated: { if (currentIndex !== 0) {tsCloseBrowser.checked = true} } //on "physical" change, touch
		onCurrentIndexChanged: if (pageIsLoaded && currentIndex !== 0) {tsCloseBrowser.checked = true} //on any change - bad, as this also fires on page loading

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("None")
                        onClicked: {
                            py.call(appname + '.change_config', ['SETTINGS', 'DeleteCookiesOnUpdate', 'none'], function(result) {})
                        }
                    }
                    MenuItem {
                        text: qsTr("All blacklisted")
                        onClicked: {
                            py.call(appname + '.change_config', ['SETTINGS', 'DeleteCookiesOnUpdate', 'blacklist'], function(result) {})
                        }
                    }
                    MenuItem {
                        text: qsTr("All not whitelisted")
                        onClicked: {
                            py.call(appname + '.change_config', ['SETTINGS', 'DeleteCookiesOnUpdate', 'whitelist'], function(result) {})
                        }
                    }
                }

                Component.onCompleted: {
                    py.call(appname + '.get_config_string', ['SETTINGS', 'DeleteCookiesOnUpdate', 'none'], function(result) {
                        if (result === 'none') currentIndex = 0
                        else if (result === 'blacklist') currentIndex = 1
			else if (result === 'whitelist') currentIndex = 2
			pageIsLoaded = true
                    })
                }
            }
	    TextSwitch {
		id: tsCloseBrowser
                text: qsTr("Close browser on cookies deletion")
                description: qsTr("To enable the deletion of cookies, the browser must not be open. If this setting is not enabled and the browser is open, cookies will not be deleted on update interval.")
		//visible: !(cbCookiesDeletion.currentIndex === 0)
		//onEnabledChanged: if (!enabled) {visible = false}
		enabled: !(cbCookiesDeletion.currentIndex === 0)
		onCheckedChanged: {
                    py.call(appname + '.change_config', ['SETTINGS', 'CloseBrowserOnCookiesDeletion', checked], function(result) {
                    })
                }

                Component.onCompleted: {
                    py.call(appname + '.get_config_bool', ['SETTINGS', 'CloseBrowserOnCookiesDeletion', false], function(result) {
                        checked = result
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
