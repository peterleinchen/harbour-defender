# -*- mode: sh -*-

# try to scale the panel sizd (before the /etc/dconf - themes://silica whitelisting)
#env QT_SCALE_FACTOR=1.8
#env QT_QPA_PLATFORM=wayland (try for browser enabling)

## dbus whitelistings
##dbus-user.talk com.jolla.ambienced
##dbus-user.talk org.maliit.server #anyway in Base
##dbus-user.talk org.nemomobile.lipstick
##dbus-user.talk org.freedesktop.Notifications
#
#already in Base: dbus-user.talk org.freedesktop.DBus
dbus-user.talk org.sailfishos.browser
dbus-user.talk org.sailfishos.urlhandler
dbus-user.talk org.sailfishos.mapplauncherd

#
# TRYing to access error.log with browser (doh!), nobälacklisting for browser
noblacklist ${HOME}/.config/harbour-defender/
whitelist ${HOME}/.config/harbour-defender/
read-write ${HOME}/.config/harbour-defender/

#includes
#include /etc/sailjail/permissions/booster-browser.profile
include /etc/sailjail/permissions/Defender.permission
