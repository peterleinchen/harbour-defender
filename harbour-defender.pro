# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed
#   - sailjail profile name and calls with parameter -p must be changed

# The name of your application
TARGET = harbour-defender

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# for binary copilation, use:
#CONFIG += sailfishapp
#SOURCES += src/harbour-defender.cpp
# but as from 2026-06 we build as BuildArch: noarch
# start noarch sailfish-qml, so there is no need to build, see build section in spec: 
#SOURCES -= src/harbour-defender.cpp
#TEMPLATE = subdirs
#SUBDIRS =
TEMPLATE = aux
# and we need to take care of (else done by qmake5)
# the desktop file
desktop_file.files = harbour-defender.desktop
desktop_file.path = $$PREFIX/share/applications
INSTALLS += desktop_file
# the icons directories
#icons_dirs.files = $$FILES(icons/*)
#icons_dirs.path = $$PREFIX/share/icons/hicolor
#INSTALLS += icons_dirs
for(res, SAILFISHAPP_ICONS) {
  # dyamically create an installation var for each resolution loop
  icons_$${res}.files = icons/$${res}/*.png
  # map it to the standard Sailfish hicolor path structure
  icons_$${res}.path = $${PREFIX}/share/icons/hicolor/$${res}/apps
  # append the dynamic rule to the installation engine queue
  INSTALLS += icons_$${res}
}
# end noarch

OTHER_FILES += qml/harbour-defender.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-defender.changes.in \
    rpm/harbour-defender.spec \
    translations/*.ts \
    harbour-defender.desktop


# Installs
units.files = \
   harbour-defender.service  \
   harbour-defender.path  \
   harbour-defender.timer \
   harbour-defender-adRestart.service  \
   harbour-defender-adRestart.path  \
   harbour-defender-updLoop.service \
   harbour-defender-updLoop.path
units.path = $${UNITDIR}
INSTALLS += units

conf.path = $${CONFDIR}
conf.extra = \
  install -p -m 644 $$PWD/qml/python/defender_default.conf \
  ${INSTALL_ROOT}$${CONFDIR}/defender.conf
INSTALLS += conf

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you are not
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
#TRANSLATIONS += translations/harbour-defender-de.ts
TRANSLATIONS += translations/harbour-defender-*.ts

DISTFILES += \
    qml/pages/CookiesPage.qml \
    qml/pages/DocsPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/SourceDetailPage.qml \
    qml/pages/SourcesPage.qml \
    qml/pages/WelcomePage.qml \
    qml/pages/components/CookiesMenuItem.qml \
    qml/pages/components/GeneralMenuItem.qml \
    qml/pages/components/SourcesMenuItem.qml
