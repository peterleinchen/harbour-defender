%global shortname defender
%global _unitdir %{_sysconfdir}/systemd/system
%global _a1configdir /system%{_sysconfdir}
%global _a2configdir /opt/alien/system%{_sysconfdir}

Name:       harbour-defender

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Privacy watcher
Version:    0.7.0
Release:    1
Group:      Qt/Qt
License:    GPLv3
URL:        https://github.com/peterleinchen/harbour-defender
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   pyotherside-qml-plugin-python3-qt5
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
BuildRequires:  systemd
BuildRequires:  qt5-qttools-linguist
Conflicts:      sailfishos-hosts-adblock
Conflicts:      noadshosts

%description
Configurable adblocker and privacy tuner

%if "%{?vendor}" == "chum"
PackageName: Defender
Categories:
 - System
 - Network
Icon: https://raw.githubusercontent.com/peterleinchen/harbour-defender/master/qml/pages/images/harbour-defender.svg
%endif

%prep
%setup -q -n %{name}-%{version}

%build

%qtc_qmake5 CONFDIR=%{_sysconfdir} UNITDIR=%{_unitdir}

%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/*
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%attr(0644,root,root) %{_unitdir}/%{name}*.service
%attr(0644,root,root) %{_unitdir}/%{name}.timer
%attr(0644,root,root) %{_unitdir}/%{name}*.path
%attr(0644,root,root) %{_sysconfdir}/%{shortname}.conf
%exclude %{_datadir}/%{name}/qml/python/*.pyc
%exclude %{_datadir}/%{name}/qml/python/*.pyo
%exclude %{_datadir}/%{name}/qml/python/python_hosts/*.pyc
%exclude %{_datadir}/%{name}/qml/python/python_hosts/*.pyo
# >> files
# << files


%post
[ -f %{_sysconfdir}/hosts ] && echo "/etc/hosts exists" || echo -e "127.0.0.1               localhost.localdomain localhost\n::1             localhost6.localdomain6 localhost6\n" >> %{_sysconfdir}/hosts
[ -f %{_sysconfdir}/hosts.editable ] && echo "/etc/hosts.editable exists" || cp %{_sysconfdir}/hosts %{_sysconfdir}/hosts.editable 2>/dev/null || :
# Android files
if [ -d "%{_a1configdir}" ]; then
  # Only if the dir exists
  [ -f %{_a1configdir}/hosts ] && echo "%{_a1configdir}/hosts exists" || echo -e "127.0.0.1                   localhost\n" >> %{_a1configdir}/hosts
  [ -f %{_a1configdir}/hosts.editable ] && echo "%{_a1configdir}/hosts.editable exists" || cp %{_a1configdir}/hosts %{_a1configdir}/hosts.editable 2>/dev/null || :
fi
if [ -d "%{_a2configdir}" ]; then
  # Only if the dir exists
  [ -f %{_a2configdir}/hosts ] && echo "%{_a2configdir}/hosts exists" || echo -e "127.0.0.1                   localhost\n" >> %{_a2configdir}/hosts
  [ -f %{_a2configdir}/hosts.editable ] && echo "%{_a2configdir}/hosts.editable exists" || cp %{_a2configdir}/hosts %{_a2configdir}/hosts.editable 2>/dev/null || :
fi
if [ -f /usr/lib/systemd/system/sailfish-unlock-agent.service ]; then
  #exchange the path unit's WantedBy in case of ENrypted devices, 
  #normally the default for X.. devices and SW >= 3.3 flashed
  sed -e 's/WantedBy=.*/WantedBy=sailfish-unlock-agent.service/' -i /etc/systemd/system/%{name}.path
  sed -e 's/WantedBy=.*/WantedBy=sailfish-unlock-agent.service/' -i /etc/systemd/system/%{name}-adRestart.path
  sed -e 's/WantedBy=.*/WantedBy=sailfish-unlock-agent.service/' -i /etc/systemd/system/%{name}-updLoop.path
else if [ -f /usr/lib/systemd/system/decrypt-home_encrypted.service ]; then
  #exchange the path unit's WantedBy in case of ENrypted devices, 
  #normally the default for X.. devices and SW >= 3.3 flashed
  #but different for community portss
  sed -e 's/WantedBy=.*/WantedBy=decrypt-home_encrypted.service/' -i /etc/systemd/system/%{name}.path
  sed -e 's/WantedBy=.*/WantedBy=decrypt-home_encrypted.service/' -i /etc/systemd/system/%{name}-adRestart.path
  sed -e 's/WantedBy=.*/WantedBy=decrypt-home_encrypted.service/' -i /etc/systemd/system/%{name}-updLoop.path
else
  # exchange the path unit's WantedBy in case of NOT encrypted devices, 
  # for older devices not supporting or having activated  encryption
  sed -e 's/WantedBy=.*/WantedBy=default.target/' -i /etc/systemd/system/%{name}.path
  sed -e 's/WantedBy=.*/WantedBy=default.target/' -i /etc/systemd/system/%{name}-adRestart.path
  sed -e 's/WantedBy=.*/WantedBy=default.target/' -i /etc/systemd/system/%{name}-updLoop.path
  fi
fi
systemctl start %{name}.timer
systemctl enable %{name}.timer
systemctl start %{name}.path
systemctl disable %{name}.path; # this one may be needed on upgrade
systemctl enable %{name}.path
systemctl start %{name}-adRestart.path
systemctl enable %{name}-adRestart.path
systemctl start %{name}-updLoop.path
systemctl enable %{name}-updLoop.path
#sed the version number
sed -e 's/text: \"[0-9]\.[0-9]\.[0-9]\"/text: \"%{version}\"/' -i %{_datadir}/%{name}/qml/pages/DocsPage.qml
#temporary hack, until Jolla fixes aliendalvik bind mount of /system/etc/hosts
grep -q '^lxc\.mount\.entry.=./system/etc/hosts system/etc/hosts' /var/lib/lxc/aliendalvik/extra_config
if [ 0 != $? ]; then
    echo "lxc.mount.entry = /system/etc/hosts system/etc/hosts none bind,ro 0 0" >> /var/lib/lxc/aliendalvik/extra_config
fi
#temporary hack, until Jolla fixes nsswitch.conf problematic
#if [ 0 != `grep -q '^private-etc.*nsswitch.conf' /etc/sailjail/permissions/Internet.permission` ]; then
grep -q '^private-etc.*nsswitch.conf' /etc/sailjail/permissions/Internet.permission
if [ 0 != $? ]; then
    sed -e 's/^private-etc /private-etc nsswitch.conf,/' -i /etc/sailjail/permissions/Internet.permission
fi
# >> install post
# << install post

%preun
# in case of removal
if [ "$1" = "0" ]; then
    systemctl stop %{name}.timer
    systemctl disable %{name}.timer
    systemctl stop %{name}.path
    systemctl disable %{name}.path
    [ -f /home/defaultuser/%{name}/update ] && rm /home/defaultuser/%{name}/update ] || [ -f /home/nemo/%{name}/update ] && rm /home/nemo/%{name}/update || :
    [ -f %{_sysconfdir}/hosts.editable ] && cp %{_sysconfdir}/hosts.editable %{_sysconfdir}/hosts 2>/dev/null || echo "/etc/hosts.editable does not exist"
    [ -f %{_a1configdir}/hosts.editable ] && cp %{_a1configdir}/hosts.editable %{_a1configdir}/hosts 2>/dev/null || echo "%{_a1configdir}/hosts.editable does not exist"
    [ -f %{_a2configdir}/hosts.editable ] && cp %{_a2configdir}/hosts.editable %{_a2configdir}/hosts 2>/dev/null || echo "%{_a2configdir}/hosts.editable does not exist"
fi
