# -*- mode: sh -*-

# Firejail profile for harbour-defender
# #Permissions=Defender;xBase;xCompatibility;xInternet

# x-sailjail-translation-catalog = sailjail-permissions
# # x-sailjail-translation-key-description = permission-la-defender
# # x-sailjail-description = Defender profile (Internet, /etc/hosts, cookies.sqlite)
# # x-sailjail-translation-key-long-description = permission-la-defender_description
# # x-sailjail-long-description = Defender, a privacy guard and ad-blocker. Fetches ad-block lists from pre-configured internet sources, writes them to hosts file(s), works also for AlienDalvik/AppSupport. Lets you decide which cookies to white- or blacklist  or even freeze them. Needs (of course ;) Internet permission.

### PERMISSIONS

# -*- mode: sh -*-

#ignore caps.drop
#ignore no-new-privs
#ignore seccomp

###
# before including other permissions...
###

## bin
#
#ignore private-bin
noblacklist /bin/
noblacklist /usr/bin/


## etc
##
ignore private-etc
noblacklist /etc/


## lib
#
ignore private-lib #normally never set to private-lib
noblacklist /lib/
noblacklist /lib64/
noblacklist /usr/lib/
noblacklist /usr/lib64/
#
noblacklist /odm/lib/
noblacklist /odm/lib64/
noblacklist /system/lib/
noblacklist /system/lib64/
noblacklist /system/vendor/lib/
noblacklist /system/vendor/lib64/
noblacklist /vendor/lib/
noblacklist /vendor/lib64/
noblacklist /usr/libexec/droid-hybris/system/lib/
noblacklist /usr/libexec/droid-hybris/system/lib64/
noblacklist /apex/com.android.vndk.v30/lib/
noblacklist /apex/com.android.vndk.v30/lib64/


## tmp
#
ignore private-tmp
noblacklist /tmp/


## usr/share
#
noblacklist /usr/share/themes


## var
#
noblacklist /var/log/
writable-var-log
noblacklist /var/log/defender_*
#####



###
# Including NOT Base and other permissions...
###
#include /etc/sailjail/permissions/booster-browser.profile
#include /etc/sailjail/permissions/booster-silica-qt5.profile
#
include /etc/sailjail/permissions/Defender.permission
#include /etc/sailjail/permissions/Base.permission
include /etc/sailjail/permissions/Compatibility.permission
include /etc/sailjail/permissions/Internet.permission
#
#DOH!!! include /etc/sailjail/permissions/defender.profile
# do not include profiles in permissions, but only permissions in profles
#####



###
# After including Base and others...
###

# TRYing to scale the panel size (worked before before found /etc/dconf - themes://silica whitelisting)
#env QT_SCALE_FACTOR=1.8
#env QT_QPA_PLATFORM=wayland (try for browser enabling)


# TRYing to access error.log with browser (doh!), noblacklisting for browser, but browser has only Docuents.permission
#noblacklist ${HOME}/.config/harbour-defender/
#whitelist ${HOME}/.config/harbour-defender/
#read-write ${HOME}/.config/harbour-defender/


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


## whitelistings

# cookies
whitelist ${HOME}/.mozilla/mozembed/
whitelist ${HOME}/.mozilla/mozembed/cookies.sqlite*
read-write ${HOME}/.mozilla/mozembed/cookies.sqlite*
whitelist ${HOME}/.local/share/org.sailfishos/browser/.mozilla/
mkfile ${HOME}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite-shm
mkfile ${HOME}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite-wal
whitelist ${HOME}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite*
read-write ${HOME}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite*


## bin
# as whitelisting not allowed, try with
# ignoring private-bin and noblacklisting, but also does not work, 
# need private-bin
#ignore private-bin
#doh: whitelist /bin/
noblacklist /bin/
noblacklist /bin/sh
noblacklist /bin/busybox
#doh: whitelist /usr/bin/
noblacklist /usr/bin/
noblacklist /usr/bin/sh
noblacklist /usr/bin/busybox
noblacklist /usr/bin/sailfish-browser # this does also not work, NEED private-bin
#private-bin busybox,echo,grep,ps,sh,sleep,touch,wc,sailfish-browser
private-bin busybox,echo,grep,ps,sh,sleep,touch,wc,sailfish-browser,invoker


## etc
ignore private-etc
noblacklist /etc/
#doh, crashes sailjail: whitelist /etc/

# themes://silica
whitelist /etc/dconf/
read-only /etc/dconf/

# nope: private-etc defender.conf
whitelist /etc/defender.conf
read-write /etc/defender.conf

# Fontconfig
#whitelist /etc/fonts/
whitelist /etc/fonts/fonts.conf
read-only /etc/fonts/fonts.conf

whitelist /etc/hosts*
read-write /etc/hosts*
whitelist /system/etc/hosts*
read-write /system/etc/hosts*
#
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


## lib...
# non-sense the libs here, but just kept anyway
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
# end of nosense for fun, below is enough:
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
# END OF LIB section for Jolla devices
#
# for 10 III libs see at end of file 
#

## tmp
##hmm, seems all not really to work for single files
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


## var/log
noblacklist /var/log/
#doh: mkfile /var/log/defender_last.json
noblacklist /var/log/defender_*
whitelist /var/log/defender_*
whitelist /var/log/defender_err.log
read-write /var/log/defender_err.log
whitelist /var/log/defender_last.json
read-write /var/log/defender_last.json



## usr/share
## non-sense regarding themes://silica, but kept anymway
#doh: whitelist /usr/share/
#read-only /usr/share/
noblacklist /usr/share/themes/
whitelist /usr/share/themes/
read-only /usr/share/themes/
whitelist /usr/share/themes//silica/
read-only /usr/share/themes//silica/
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
whitelist /usr/share/fonts/
read-only /usr/share/fonts/


## python
whitelist /usr/share/harbour-defender/qml/python/
read-only /usr/share/harbour-defender/qml/python/


## default
whitelist ${HOME}/.cache/harbour-defender
whitelist ${HOME}/.config/harbour-defender
whitelist ${HOME}/.local/share/harbour-defender

##
# DOH!!! include /etc/sailjail/permissions/defender.profile
# do not include profiles in permissions, but only permissions in profiles
#####

