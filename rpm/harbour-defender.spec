%global shortname defender
%global shortnameUpper Defender
%global _unitdir %{_sysconfdir}/systemd/system
%global _sailjaildir %{_sysconfdir}/sailjail/permissions
%global _a1configdir /system%{_sysconfdir}
%global _a2configdir /opt/alien/system%{_sysconfdir}
%global organization leinchen.peter

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{!?qtc_lrelease:%define qtc_lrelease lrelease}
#
%{?qtc_builddir:%define _builddir %qtc_builddir}

Name:       harbour-defender
Summary:    A privacy guard for SFOS
Version:    0.9.1
Release:    1
Group:      Qt/Qt
License:    GPLv3
URL:        https://github.com/peterleinchen/harbour-defender
Source:     %{name}-%{version}.tar.bz2
BuildArch:  noarch
BuildRequires:  desktop-file-utils
BuildRequires:  qt5-qttools-linguist
BuildRequires:  systemd
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
Requires:   pyotherside-qml-plugin-python3-qt5
Requires:   sailfishsilica-qt5 >= 0.10.9
Conflicts:  noadshosts
Conflicts:  sailfishos-hosts-adblock

%description
Configurable adblocker and privacy tuner for SFOS

%if "%{?vendor}" == "chum" || "%{?vendor}" == "harbour"
PackageName: Defender
Categories:
 - System
 - Network
Icon: https://raw.githubusercontent.com/peterleinchen/harbour-defender/master/qml/pages/images/harbour-defender.svg
%endif

%prep
%setup -q -n %{name}-%{version}

%build
# dirs
%qtc_qmake5 CONFDIR=%{_sysconfdir} UNITDIR=%{_unitdir} SAILJAILDIR=%{_sailjaildir}
# make
%qtc_make %{?_smp_mflags}
# as we use noarch sailfish-qml, there is no need to build, but we keep above: 
# so please see section in .pro file
# translations, should already be handled with pro file
%qtc_lrelease translations/*.ts

%install
ls -R . # debugging only
#
rm -rf %{buildroot}
%qmake5_install
#
pwd # debugging only

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

# nope, no trailing slash:
# install -D -p -m 644 %%{name}.profile %%{buildroot}/%%{_sailjaildir}/
# would be okay:            
# install -D -p -m 644 %%{name}.profile %%{buildroot}/%%{_sailjaildir}
# but common practice is: 
mkdir -p %{buildroot}/%{_sailjaildir}
install -p -m 644 %{name}.profile* %{buildroot}/%{_sailjaildir}
install -p -m 644 %{shortnameUpper}.permission %{buildroot}/%{_sailjaildir}

# translations, should already be handled within pro file
#mkdir -p %{buildroot}/%{_datadir}/%{name}/translations
#install -p -m 644 translations/%{name}*.qm %{buildroot}/%{_datadir}/%{name}/translations

%files
%defattr(-,root,root,-)
# as we use noarch sailfish-qml, no need for binary: 
# %%{_bindir}/*
%{_datadir}/%{name}
# not needed explicitly (included already with above)
# %%{_datadir}/%%{name}/translations/*
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_sailjaildir}/*
%attr(0644,root,root) %{_unitdir}/%{name}*.path
%attr(0644,root,root) %{_unitdir}/%{name}*.service
%attr(0644,root,root) %{_unitdir}/%{name}.timer
%attr(0644,root,root) %{_sysconfdir}/%{shortname}.conf
%exclude %{_datadir}/%{name}/qml/python/*.pyc
%exclude %{_datadir}/%{name}/qml/python/*.pyo
%exclude %{_datadir}/%{name}/qml/python/python_hosts/*.pyc
%exclude %{_datadir}/%{name}/qml/python/python_hosts/*.pyo
# a ghost config to not have it somehow overwritten, both cannot work. user dirs not allow
# %%ghost %%config ${HOME}/.config/%%{organization}/%%{name}/%%{shortname}.conf
#%ghost %config %{_home_dir}/.config/%{organization}/%%{name}/%{shortname}.conf

# >> files
# << files

%pre
%if "%{?vendor}" == "harbour"
  version_id=$(grep VERSION_ID /etc/os-release | cut -f2 -d'=')
  if [[ $(echo $version_id | cut -f1 -d'.') -le 4  && $(echo $version_id | cut -f2 -d'.') -lt 6 ]]; then
    echo 'ERROR: Installation of Defender from Jolla store not supported below SFOS 4.6.0.15!' >&2
    exit 1
  fi
%endif
# >> install pre
# << install pre

%post
[ -f %{_sysconfdir}/hosts ] && echo "Info: /etc/hosts exists" || echo -e "127.0.0.1               localhost.localdomain localhost\n::1             localhost6.localdomain6 localhost6\n" >> %{_sysconfdir}/hosts
[ -f %{_sysconfdir}/hosts.editable ] && echo "Info: /etc/hosts.editable exists" || cp %{_sysconfdir}/hosts %{_sysconfdir}/hosts.editable 2>/dev/null :
# Android files
if [ -d "%{_a1configdir}" ]; then
  # Only if the dir exists
  [ -f %{_a1configdir}/hosts ] && echo "Info: %{_a1configdir}/hosts exists" || echo -e "127.0.0.1                   localhost\n" >> %{_a1configdir}/hosts :
  [ -f %{_a1configdir}/hosts.editable ] && echo "Info: %{_a1configdir}/hosts.editable exists" || cp %{_a1configdir}/hosts %{_a1configdir}/hosts.editable 2>/dev/null :
fi
if [ -d "%{_a2configdir}" ]; then
  # Only if the dir exists
  [ -f %{_a2configdir}/hosts ] && echo "%{_a2configdir}/hosts exists" || echo -e "127.0.0.1                   localhost\n" >> %{_a2configdir}/hosts :
  [ -f %{_a2configdir}/hosts.editable ] && echo "%{_a2configdir}/hosts.editable exists" || cp %{_a2configdir}/hosts %{_a2configdir}/hosts.editable 2>/dev/null :
fi

if [ -f /usr/lib/systemd/system/sailfish-unlock-agent.service ]; then
  # exchange the path unit's WantedBy in case of ENcrypted devices, 
  # normally the default for X.. (and 10) devices and/or SW >= 3.3 flashed
  sed -e 's/^WantedBy=.*/WantedBy=sailfish-unlock-agent.service/' -i /etc/systemd/system/%{name}.path
  sed -e 's/^WantedBy=.*/WantedBy=sailfish-unlock-agent.service/' -i /etc/systemd/system/%{name}-adRestart.path
  sed -e 's/^WantedBy=.*/WantedBy=sailfish-unlock-agent.service/' -i /etc/systemd/system/%{name}-updLoop.path
else if [ -f /usr/lib/systemd/system/decrypt-home_encrypted.service ]; then
  # exchange the path unit's WantedBy in case of ENrypted devices, 
  # normally the default for X.. devices and SW >= 3.3 flashed
  # but different for community ports!
  sed -e 's/^WantedBy=.*/WantedBy=decrypt-home_encrypted.service/' -i /etc/systemd/system/%{name}.path
  sed -e 's/^WantedBy=.*/WantedBy=decrypt-home_encrypted.service/' -i /etc/systemd/system/%{name}-adRestart.path
  sed -e 's/^WantedBy=.*/WantedBy=decrypt-home_encrypted.service/' -i /etc/systemd/system/%{name}-updLoop.path
else
  # exchange the path unit's WantedBy in case of NOT encrypted devices, 
  # for older devices not supporting or having activated  encryption
  sed -e 's/^WantedBy=.*/WantedBy=default.target/' -i /etc/systemd/system/%{name}.path
  sed -e 's/^WantedBy=.*/WantedBy=default.target/' -i /etc/systemd/system/%{name}-adRestart.path
  sed -e 's/^WantedBy=.*/WantedBy=default.target/' -i /etc/systemd/system/%{name}-updLoop.path
  fi
fi
#
systemctl daemon-reload
systemctl disable --now %{name}.path; # this one may be needed on upgrade
systemctl enable --now %{name}.path
systemctl enable --now %{name}-adRestart.path
systemctl enable --now %{name}-updLoop.path
systemctl enable --now %{name}.timer

# sed the version number into DocsPage
sed -e 's/text: \"[0-9]\.[0-9]\.[0-9]\"/text: \"%{version}\"/' -i %{_datadir}/%{name}/qml/pages/DocsPage.qml

# temporary hack, until Jolla fixes aliendalvik bind mount of /system/etc/hosts
# this bas been "fixed" via AppSupport but still needed for older versions
if [ -d /var/lib/lxc/aliendalvik ]; then 
    grep -q '^lxc\.mount\.entry.=./system/etc/hosts system/etc/hosts' /var/lib/lxc/aliendalvik/extra_config &>/dev/null
    if [ 0 != $? ]; then
        echo "lxc.mount.entry = /system/etc/hosts system/etc/hosts none bind,ro 0 0" >> /var/lib/lxc/aliendalvik/extra_config
    fi
fi

# temporary hack, until Jolla fixes nsswitch.conf problematic
# has also been fixed by Jolla, but again: older versions
# old: if [ 0 != `grep -q '^private-etc.*nsswitch.conf' /etc/sailjail/permissions/Internet.permission` ]; then
grep -q '^private-etc.*nsswitch.conf' /etc/sailjail/permissions/Internet.permission
if [ 0 != $? ]; then
    sed -e 's/^private-etc /private-etc nsswitch.conf,/' -i /etc/sailjail/permissions/Internet.permission
fi

# disable sailjail for all older SFOS versions 
# was introduced with 4.0.1 (Koli), became mandatory on 4.4.0 (Vanha Rauma) 
# and fully working since 4.6.0.15 (Sauna), the last version supporting 
# the Tablet and the X
# So for easing, we only sailjail from SFOS 5.0 onwards ;)
# if [ $(grep VERSION_ID /etc/os-release  | cut -f2 -d'=' | cut -f1 -d'.') -lt 5 ]; then
# Changed to sailjail from 4.6, matured enough and allows installation on older devices
version_id=$(grep VERSION_ID /etc/os-release  | cut -f2 -d'=')
if [[ $(echo $version_id | cut -f1 -d'.') -le 4  && $(echo $version_id | cut -f2 -d'.') -lt 6 ]]; then
    #sed -i 's/^#X-Nemo-Application/X-Nemo-Application/' /usr/share/applications/harbour-defender.desktop
    #sed -i 's/^#Exec=harbour-defender/Exec=harbour-defender/' /usr/share/applications/harbour-defender.desktop
    #sed -i 's/^Exec=\/usr\/bin\/sailjail/#Exec=\/usr\/bin\/sailjail/' /usr/share/applications/harbour-defender.desktop
    sed -i 's/^#Sandboxing=Disabled/Sandboxing=Disabled/' /usr/share/applications/%{name}.desktop
fi

# for Xperia 10 devices we need a LOT more libs in sailjailed environment
# causing the app to take >35sec to start
if [ $(grep 'NAME=' /etc/hw-release | grep -q 'Xperia 10'; echo $?) -eq 0 ]; then
    cat /etc/sailjail/permissions/%{name}.profile.partial_Xperia10 >> /etc/sailjail/permissions/%{name}.profile 
fi
rm /etc/sailjail/permissions/%{name}.profile.partial* &>/dev/null

## small fix for sailjail, as /var/log/ and mkfile do not like each other
#touch /var/log/defender_last.json
#touch /var/log/defender_err.log
#chmod o+w /var/log/defender_*
# >> install post
# << install post

%preun
# stop and disable all services
systemctl disable --now %{name}.timer
systemctl disable --now %{name}.path
systemctl disable --now %{name}-updLoop.path
systemctl disable --now %{name}-adRestart.path
systemctl disable --now %{name}
#systemctl daemon-reload

# check for existence of the partial Xperia10 profile and touch to suppress rpm warning
[ -f /etc/sailjail/permissions/%{name}.profile.partial_Xperia10 ] || touch /etc/sailjail/permissions/%{name}.profile.partial_Xperia10 :

# in case of removal
if [ "$1" = "0" ]; then    
    for xuser in nemo defaultuser; do
        # unlock cookies (in case of cookies are locked on uninstall)
        #[ -f /home/defaultuser/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite ] && chmod u+w /home/defaultuser/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite* || [ -f /home/nemo/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite ] && chmod u+w /home/nemo/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite*
        [ -f /home/${xuser}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite ] && chmod u+w /home/${xuser}/.local/share/org.sailfishos/browser/.mozilla/cookies.sqlite* :
    
        # remove temporary files
        [ -d /tmp/defender ] && rm -fr /tmp/defender :
        #[ -f /var/log/defender_last.json ] && rm /var/log/defender_last.json :
        #[ -f /var/log/defender_err.log ] && rm /var/log/defender_err.log :
        
        # clean sailjail dirs
        config_dir="/home/${xuser}/.config/%{organization}/%{name}"
        cache_dir="/home/${xuser}/.cache/%{organization}/%{name}"
        data_dir="/home/${xuser}/.local/share/%{organization}/%{name}"
        #[ -d "${config_dir}" ] && rm -fr "${config_dir}"
        [ -d "${cache_dir}" ] && rm -fr "${cache_dir}" :
        [ -d "${data_dir}" ] && rm -fr "${data_dir}" : 
        # backup the personal config
        config_bak=${configdir}.bak
        [ -d /home/$xuser ] && [ -d "$config_bak" ] || echo "mkdir -p $config_bak" | su - $xuser :
        cp -ar "${config_dir}/*" "${config_bak}/" &>/dev/null
        
        # public dir errlog file
        [ -f /home/${xuser}/Public/.%{shortname}_err.log ] && rm /home/${xuser}/Public/.%{shortname}_err.log :
    done
    
    # copy back manually created entries to hosts
    [ -f %{_sysconfdir}/hosts.editable ] && cp %{_sysconfdir}/hosts.editable %{_sysconfdir}/hosts 2>/dev/null || echo "Info: %{_sysconfdir}/hosts.editable does not exist" :
    [ -f %{_a1configdir}/hosts.editable ] && cp %{_a1configdir}/hosts.editable %{_a1configdir}/hosts 2>/dev/null || echo "Info: %{_a1configdir}/hosts.editable does not exist" :
    [ -f %{_a2configdir}/hosts.editable ] && cp %{_a2configdir}/hosts.editable %{_a2configdir}/hosts 2>/dev/null || echo "Info: %{_a2configdir}/hosts.editable does not exist" :
fi

