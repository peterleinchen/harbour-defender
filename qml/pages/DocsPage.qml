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
                title: qsTr("Version")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2*x
                text: "0.6.1"
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
            }
            PageHeader {
                title: qsTr("Warning")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2*x
                text: qsTr("The installation and use of this application is solely in the responsibility of the user. The developers/authors are not responsible for the content of ad blocking sources available from the application, therefore you need to be careful when enabling them.")
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
            }
            PageHeader {
                title: qsTr("Adblock Lists")
            }
            SectionHeader {
                text: qsTr("How to add custom lists?")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2*x
                text: qsTr("You can add custom lists by editing the file /etc/defender.conf as root (either using the command line or an appropriate editor). See other sections in the config file for inspiration. In the square brackets [] should be a unique id.")
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
            }
            SectionHeader {
                text: qsTr("Why can't I add new sources from the app?")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2*x
                text: qsTr("It would be a security threat to allow adding new sources as a normal user (with the current SailfishOS security situation), as any app would be able to add new sources and potentially compromise your device. Even with the default sources, you still make the leap of faith to trust a remote source. If you want to have a source added/removed to/from the defaults, contact the app developer and see if it can be available in the next version.")
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
            }
            SectionHeader {
                text: qsTr("How to add custom entries?")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2*x
                text: qsTr("You can add your custom hosts entries by editing the file /etc/hosts.editable and treating it as a generic hosts file. Don't forget to choose 'Update Now' in the app to see an immediate effect.")
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
            }
            SectionHeader {
                text: qsTr("Why can't I add new entries from the app?")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2*x
                text: qsTr("Again, it would be a security threat (see the answer above), therefore one needs to be root to add/modify hosts file entries.")
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
            }
            PageHeader {
                title: qsTr("Cookies")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2*x
                text: qsTr("The cookie manager works by editing the -/.local/share/org.sailfishos/browser/.mozilla/ (for SFOS up to 3.4: -/.mozilla/mozembed/) cookies.sqlite database. In order to access/work with cookies the browser needs to be closed before opening the cookies section, else you might see an empty window. All changes need the browser to be closed/restarted in order to take effect.")
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
            }
            SectionHeader {
                text: qsTr("Cookie Locking")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - 2*x
                text: qsTr("Cookie locking works by making the cookie database read only, therefore its contents stay same between restarting the browser. The effect of this is cookies not being persistent over browser restarts.")
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeMedium
            }

        }
    }
}

