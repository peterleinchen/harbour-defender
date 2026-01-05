import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    property string searchString
    SilicaListView {
        id: listView
        model: cookiesModel
        anchors.fill: parent
        header: SearchField {
            width: parent.width
            placeholderText: "Search cookies"
            validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }

            EnterKey.onClicked: {
                searchString = text.toLowerCase()
                py.call(appname+'.load_cookies', [searchString], function(result) {
                    cookiesModel.clear()
                    for (var i = 0; i < result.length; i++) {
                        cookiesModel.append(result[i])
                    }
                })
            }
        }
        PullDownMenu {
            MenuItem {
                text: cookiesLocked ? qsTr("Unlock cookies") : qsTr("Lock cookies")
                onClicked: {
                    var infoText = cookiesLocked ? qsTr("Unlocking") : qsTr("Locking")
                    remorse.execute(infoText, function() {
                        py.call(appname+'.cookie_locker', [!cookiesLocked], function (result) {
                            cookiesLocked = !cookiesLocked
                        });
                    })
                }
            }
            MenuItem {
                text: qsTr("Delete all blacklisted")
                onClicked: {
                    remorse.execute("Deleting", function() {
                        py.call(appname+'.cookie_delete_blacklist', [cookieBlacklist, searchString], function (result) {
                            cookiesModel.clear()
                            for (var i = 0; i < result.length; i++) {
                                cookiesModel.append(result[i])
                            }
                            py.call(appname+'.get_stats', [], function (result) {
                                stats = result
                            });
                        });
                    })
                }
            }
            MenuItem {
                text: qsTr("Delete all not whitelisted")
                onClicked: {
                    remorse.execute("Deleting", function() {
                        py.call(appname+'.cookie_delete_whitelist', [cookieWhitelist, searchString], function (result) {
                            cookiesModel.clear()
                            for (var i = 0; i < result.length; i++) {
                                cookiesModel.append(result[i])
                            }
                            py.call(appname+'.get_stats', [], function (result) {
                                stats = result
                            });
                        });
                    })
                }
            }

        }
        section {
            property: "host"
            criteria: ViewSection.FullString
            delegate: ListItem {
                    id: sectionHeader
                    menu: contextMenu
                    property bool inBlacklist: (cookieBlacklist.indexOf(section) >= 0)
                    property bool inWhitelist: (cookieWhitelist.indexOf(section) >= 0)
                    contentHeight: Theme.itemSizeMedium
                    function remove() {
                        remorseAction("Deleting", function() {
                            py.call(appname+'.cookie_delete_domain', [section, searchString], function(result) {
                                cookiesModel.clear()
                                for (var i = 0; i < result.length; i++) {
                                    cookiesModel.append(result[i])
                                }
                            })
                        })
                    }
                    Label {
                        text: section
                        color: inBlacklist ? 'red' : (inWhitelist ? 'green' : Theme.highlightColor)
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: Theme.paddingMedium
                        }
                    }
                    Connections {
                        target: mainWindow
                        onCookieBlacklistChanged: sectionHeader.inBlacklist = (cookieBlacklist.indexOf(section) >= 0)
                        onCookieWhitelistChanged: sectionHeader.inWhitelist = (cookieBlacklist.indexOf(section) >= 0)
                    }

                    Component {
                        id: contextMenu
                        ContextMenu {
                            MenuItem {
                                text: "Remove"
                                onClicked: remove()
                            }
                            MenuItem {
                                text: inWhitelist ? qsTr("Remove from Whitelist") : qsTr("Add to Whitelist")
                                enabled: !inBlacklist
                                onClicked: {
                                    if (inWhitelist) {
                                        var indexInList = cookieWhitelist.indexOf(section);
                                        if (indexInList > -1) {
                                            cookieWhitelist.splice(indexInList, 1);
                                        }
                                        inWhitelist = false
                                    } else {
                                        cookieWhitelist.push(section)
                                        inWhitelist = true
                                    }
                                    py.call(appname+'.cookie_write_list', [cookieWhitelist, false], function(result) {
                                        console.debug('Config written '+result)
                                    })
                                }
                            }
                            MenuItem {
                                text: inBlacklist ? qsTr("Remove from Blacklist") : qsTr("Add to Blacklist")
                                enabled: !inWhitelist
                                onClicked: {
                                    if (inBlacklist) {
                                        var indexInList = cookieBlacklist.indexOf(section);
                                        if (indexInList > -1) {
                                            cookieBlacklist.splice(indexInList, 1);
                                        }
                                        inBlacklist = false
                                    } else {
                                        cookieBlacklist.push(section)
                                        inBlacklist = true
                                    }
                                    py.call(appname+'.cookie_write_list', [cookieBlacklist, true], function(result) {
                                        console.debug('Config written '+result)
                                    })
                                }
                            }
                        }
                    } // Component
                } // ListItem
        }
        delegate: ListItem {
            id: listItem
            menu: contextMenu
            contentHeight: Theme.itemSizeMedium
            ListView.onRemove: animateRemoval(listItem)
            function remove() {
                remorseAction("Deleting", function() {
                    py.call(appname+'.cookie_delete_single', [cookiesModel.get(index).id, searchString], function(result) {
                        listView.model.remove(index)
                    })
                })
            }

            Label {
                x: Theme.paddingLarge
                text: name
                anchors.verticalCenter: parent.verticalCenter
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: console.log("Clicked " + index)
            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: "Remove"
                        onClicked: remove()
                    }
                }
            } // Component
        }
        VerticalScrollDecorator {}
    }
    ListModel {
        id: cookiesModel
    }
    Component.onCompleted: {
        py.call(appname+'.load_cookies', [], function(result) {
            for (var i = 0; i < result.length; i++) {
                cookiesModel.append(result[i])
            }
        })
    }
    RemorsePopup { id: remorse }
}
