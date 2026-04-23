# -*- mode: sh -*-

# Firejail profile for harbour-defender

# x-sailjail-translation-catalog = sailjail-permissions
# x-sailjail-translation-key-description = permission-la-defender
# x-sailjail-description = Defender, privacy guard and ad-blocker (Internet, /etc/hosts, cookies.sqlite)
# x-sailjail-translation-key-long-description = permission-la-defender_description
# x-sailjail-long-description = Fetches ad-block lists from configured internet sources, writes tehm to hosts fil(s), works also for AlienDalvik/AppSupport. Also includes Internet permission.

### PERMISSIONS

# -*- mode: sh -*-

# try to scale the panel size (before found /etc/dconf - themes://silica whitelisting)
#env QT_SCALE_FACTOR=1.8
#env QT_QPA_PLATFORM=wayland (try for browser enabling)

# TRYing to access error.log with browser (doh!), noblacklisting for browser
noblacklist ${HOME}/.config/harbour-defender/
whitelist ${HOME}/.config/harbour-defender/
read-write ${HOME}/.config/harbour-defender/

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

#whitelistings
##doh: mkfile /var/log/defender_last.json
whitelist /var/log/defender_last.json
read-write /var/log/defender_last.json
whitelist /var/log/defender_err.log
read-write /var/log/defender_err.log

whitelist ${HOME}/.mozilla/mozembed/
whitelist ${HOME}/.mozilla/mozembed/cookies.sqlite*
read-write ${HOME}/.mozilla/mozembed/cookies.sqlite*
whitelist ${HOME}/.local/share/org.sailfishos/browser/.mozilla/
mkfile ${HOME}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite-shm
mkfile ${HOME}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite-wal
whitelist ${HOME}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite*
read-write ${HOME}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite*

ignore private-etc
#doh, crashes sailjail: whitelist /etc/
noblacklist /etc/
read-write /etc/hosts
read-write /etc/hosts.editable

#themes://silica
whitelist /etc/dconf/
read-only /etc/dconf/

#Fontconfig
#whitelist /etc/fonts/
whitelist /etc/fonts/fonts.conf
read-only /etc/fonts/fonts.conf

#nope: private-etc defender.conf
whitelist /etc/defender.conf
read-write /etc/defender.conf

whitelist /etc/hosts
read-write /etc/hosts
# mkfile /etc/hosts.editable
whitelist /etc/hosts.editable
read-write /etc/hosts.editable
#
whitelist /system/etc/hosts
read-write /system/etc/hosts
# mkfile /system/etc/hosts.editable
whitelist /system/etc/hosts.editable
read-write /system/etc/hosts.editable
#
#legacy, obsoleted: 
#/opt/alien/system/etc/hosts

#hmm, seems all not really to work for single files
ignore private-tmp
noblacklist /tmp/
## should not be needed
#ignore read-only /tmp/
#read-write /tmp/

#doh, crashes sailjail: whiitelist /tmp/
mkfile /tmp/hosts
whitelist /tmp/hosts
read-write /tmp/hosts
#
mkdir /tmp/defender/
whitelist /tmp/defender/
read-write /tmp/defender/

whitelist /usr/share/harbour-defender/qml/python/
read-only /usr/share/harbour-defender/qml/python/

#ignoring private-bin and noblacklisting does not work, as whitelisting not allowed
#ignore private-bin
noblacklist /bin/
#doh: whitelist /bin/
noblacklist /bin/sh
noblacklist /bin/busybox
noblacklist /usr/bin/
#doh: whitelist /usr/bin/
noblacklist /usr/bin/sh
noblacklist /usr/bin/busybox
noblacklist /usr/bin/sailfish-browser # this does also not work :(
private-bin busybox,echo,grep,ps,sh,sleep,touch,wc,sailfish-browser,invoker
#private-bin busybox,echo,grep,ps,sh,sleep,touch,wc,sailfish-browser

#non-sense regarding themes://silica, but kept anymway
noblacklist /usr/share/
#doh: whitelist /usr/share/
#read-only /usr/share/
noblacklist /usr/share/themes/
whitelist /usr/share/themes/
read-only /usr/share/themes/
whitelist /usr/share/themes//silica
read-only /usr/share/themes//silica
whitelist /usr/share/themes/sailfish-default/
read-only /usr/share/themes/sailfish-default/
whitelist /usr/share/themes/sailfish-default/silica/
read-only /usr/share/themes/sailfish-default/silica/
whitelist /usr/share/themes/sailfish-default/silica/z1.75/
read-only /usr/share/themes/sailfish-default/silica/z1.75/
whitelist /usr/share/themes/sailfish-default/silica/z1.75/icons-monochrome/
read-only /usr/share/themes/sailfish-default/silica/z1.75/icons-monochrome/
whitelist /usr/share/ambience/
read-only /usr/share/ambience/
whitelist /usr/share/icons/
read-only /usr/share/icons/
#
whitelist /usr/share/fonts
read-only /usr/share/fonts

#non-sense as well, but also jist keop anyway
whitelist /usr/lib/qt5/qml/io/thp/pyotherside/libpyothersideplugin.so*
whitelist /usr/lib/libsailfishapp.so*
whitelist /usr/lib/libmdeclarativecache5.so*
whitelist /usr/lib/libmlite5.so*
whitelist /usr/lib/libQt5Quick.so*
whitelist /usr/lib/libQt5Gui.so*
whitelist /usr/lib/libQt5Qml.so*
whitelist /usr/lib/libQt5Core.so*
whitelist /usr/lib/libstdc++.so*
whitelist /usr/lib/libQt5Network.so*
whitelist /usr/lib/libGLESv2.so*
whitelist /usr/lib/libdconf.so*
whitelist /usr/lib/libgobject-2.0.so*
whitelist /usr/lib/libglib-2.0.so*
whitelist /usr/lib/libQt5DBus.so*
whitelist /usr/lib/libz.so*
whitelist /usr/lib/libpng16.so*
whitelist /usr/lib/libicuuc.so*
whitelist /usr/lib/libicui18n.so*
whitelist /usr/lib/libpcre16.so*
whitelist /usr/lib/libsystemd.so*
whitelist /usr/lib/libproxy.so*
whitelist /usr/lib/libssl.so*
whitelist /usr/lib/libcrypto.so*
whitelist /usr/lib/libhybris-common.so*
whitelist /usr/lib/libgio-2.0.so*
whitelist /usr/lib/libffi.so*
whitelist /usr/lib/libpcre2-8.so*
whitelist /usr/lib/libdbus-1.so*
whitelist /usr/lib/libicudata.so*
whitelist /usr/lib/liblzma.so*
whitelist /usr/lib/libcap.so*
whitelist /usr/lib/libmount.so*
whitelist /usr/lib/libgcrypt.so*
whitelist /usr/lib/libgmodule-2.0.so*
whitelist /usr/lib/libselinux.so*
whitelist /usr/lib/libblkid.so*
whitelist /usr/lib/libgpg-error.so*
whitelist /usr/lib/libpcre.so*
#yes, enough:
#DOH! whitelist /lib
whitelist /lib/*
read-only /lib/*
whitelist /lib64/*
read-only /lib64/*
#
whitelist /usr/lib/*
read-only /usr/lib/*
whitelist /usr/lib64/*
read-only /usr/lib64/*
# on the search why *libui_compat_layer.so os not found when running in sailjail
# and app does not start on 10 III
whitelist /odm/lib/*
read-only /odm/lib/*
whitelist /odm/lib/egl/*
read-only /odm/lib/egl/*
whitelist /odm/lib/hw/*
read-only /odm/lib/hw/*
whitelist /odm/lib64/*
read-only /odm/lib64/*
whitelist /odm/lib64/egl/*
read-only /odm/lib64/egl/*
whitelist /odm/lib64/hw/*
read-only /odm/lib64//hw/*
#
#hitelist /system/lib/*
read-only /system/lib/*
whitelist /system/lib/hw/*
read-only /system/lib/hw/*
whitelist /system/lib64/*
read-only /system/lib64/*
whitelist /system/lib64/hw/*
read-only /system/lib64/hw/*
#
whitelist /system/vendor/lib/*
read-only /system/vendor/lib/*
whitelist /system/vendor/lib/egl/*
read-only /system/vendor/lib/egl/*
whitelist /system/vendor/lib/hw/*
read-only /system/vendor/lib/hw/*
whitelist /system/vendor/lib64/*
read-only /system/vendor/lib64/*
whitelist /system/vendor/lib64/egl/*
read-only /system/vendor/lib64/egl/*
whitelist /system/vendor/lib64/hw/*
read-only /system/vendor/lib64/hw/*
#
whitelist /vendor/lib/*
read-only /vendor/lib/*
whitelist /vendor/lib/egl/*
read-only /vendor/lib/egl/*
whitelist /vendor/lib/hw/*
read-only /vendor/lib/hw/*
whitelist /vendor/lib64/*
read-only /vendor/lib64/*
whitelist /vendor/lib64/egl/*
read-only /vendor/lib64/egl/*
whitelist /vendor/lib64/hw/*
read-only /vendor/lib64/hw/*
#
whitelist /apex/com.android.vndk.v30/lib/*
read-only /apex/com.android.vndk.v30/lib/*
whitelist /apex/com.android.vndk.v30/lib/egl/*
read-only /apex/com.android.vndk.v30/lib/egl/*
whitelist /apex/com.android.vndk.v30/lib/hw/*
read-only /apex/com.android.vndk.v30/lib/hw/*
whitelist /apex/com.android.vndk.v30/lib64/*
read-only /apex/com.android.vndk.v30/lib64/*
whitelist /apex/com.android.vndk.v30/lib64/egl/*
read-only /apex/com.android.vndk.v30/lib64/egl/*
whitelist /apex/com.android.vndk.v30/lib64/hw/*
read-only /apex/com.android.vndk.v30/lib64/hw/*
# end of lib section to get Defender start on sailjailed 10 III

whitelist ${HOME}/.cache/harbour-defender
whitelist ${HOME}/.config/harbour-defender
whitelist ${HOME}/.local/share/harbour-defender

include /etc/sailjail/permissions/Compatibility.permission
include /etc/sailjail/permissions/Internet.permission

#
#DOH!!! include /etc/sailjail/permissions/defender.profile
# do not include profiles in permissions, but only permissions in profles

#includes
#include /etc/sailjail/permissions/booster-browser.profile
#include /etc/sailjail/permissions/booster-silica-qt5.profile
#
include /etc/sailjail/permissions/Compatibility.permission
include /etc/sailjail/permissions/Internet.permission
#
include /etc/sailjail/permissions/Defender.permission
