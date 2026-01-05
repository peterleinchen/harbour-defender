#!/usr/bin/python3


APP_NAME = 'defender'
APP_DIR = '/usr/share/harbour-' + APP_NAME + '/qml/python'

import sys
sys.path.insert(0, APP_DIR)
from python_hosts import Hosts, HostsEntry
from python_hosts import UnableToWriteHosts
from copy import copy
import os
import configparser
from shutil import copyfile
import json
import time
from subprocess import check_output
import socket


#APP_DIR = '/opt/sdk/harbour-' + APP_NAME + '/usr/share/harbour-' + APP_NAME + '/qml/python''

#CONFIG_HOME_DIR = '/home/nemo/.config/harbour-' + APP_NAME
#doh HOME_DIR = os.environ['HOME']
ADMIN_USER = 'defaultuser'
HOME_DIR = '/home/' + ADMIN_USER
if not os.path.isdir(HOME_DIR):
    ADMIN_USER = 'nemo'
    HOME_DIR = '/home/' + ADMIN_USER
                                        
CONFIG_HOME_DIR = HOME_DIR + '/.config/harbour-' + APP_NAME          
CONFIG_ETC_DIR = '/etc'

CONFIG_ETC_PATH = CONFIG_ETC_DIR + '/' + APP_NAME + '.conf'
CONFIG_HOME_PATH = CONFIG_HOME_DIR + '/' + APP_NAME + '.conf'
CONFIG_APP_PATH = APP_DIR + '/' + APP_NAME + '_default.conf'

UPDATE_FILE_PATH = CONFIG_HOME_DIR + '/' + 'update'
ERRLOG_FILE_PATH = CONFIG_HOME_DIR + '/' + 'error.log'

LOGFILE_LAST = '/var/log/'+ APP_NAME +'_last.json'

whitelist = []
urls = []
whitelist_priority = True # whether the whitelist should surpass the blacklist in .editable files
sanitize = True

tmp_dir = '/tmp'
tmp_hosts = '/tmp/hosts'
native_dir="/etc"
native_hosts="/etc/hosts"
android1_dir="/system/etc"
android1_hosts="/system/etc/hosts"
android2_dir="/opt/alien/system/etc"
android2_hosts="/opt/alien/system/etc/hosts"
# the android3 is not needed (as only an empty ro bind from /opt2/appsupport/system.img 
# and Jolla eventually bound the /system/etc/hosts into the container!) 
#android3_dir="/opt/appsupport/rootfs/system/etc"
#android3_hosts="/opt/appsupport/rootfs/system/etc/hosts"

config_etc = configparser.ConfigParser()
config_etc.read(CONFIG_ETC_PATH)
config_home = configparser.ConfigParser()
config_home.read(CONFIG_HOME_PATH)


def load_sources():
    urls = []
    #zip_urls = []
    #config_etc = configparser.ConfigParser()
    #config_etc.read(CONFIG_ETC_PATH)
    #config_home = configparser.ConfigParser()
    #config_home.read(CONFIG_HOME_PATH)
    whitelist = []
    whitelist_priority = True
    sanitize = True

    for entry in config_etc.sections():
        if entry in ['SETTINGS', 'DEFAULT']:
            #wlan_only = config_home.getboolean("SETTINGS", "WlanOnly", fallback = config_etc.getboolean("SETTINGS", "WlanOnly", fallback = True)) 
            whitelist = config_etc.get("SETTINGS", "HostsWhitelist", fallback = '')
            if whitelist:
                whitelist = whitelist.split(',')
            whitelist_priority = config_etc.getboolean("SETTINGS", "HostsWhitelistPriority", fallback = True)
            sanitize = config_etc.getboolean("SETTINGS", "SanitizeSourcedAddresses", fallback = True)
            single_editable = config_etc.getboolean("SETTINGS", "SingleEditable", fallback = False)
        else:
            print(config_etc.get(entry, 'Url'))
            print(config_etc.getboolean(entry, 'sourceenabled', fallback=None))
            print(config_home.getboolean(entry, 'sourceenabled', fallback=None))
            enabled = config_home.getboolean(entry, 'sourceenabled', fallback = config_etc.getboolean(entry, 'sourceenabled', fallback = False))
            if enabled:
                urls.append({'url': config_etc[entry]['Url'], 'single_format': config_etc.getboolean(entry, 'SingleFormat', fallback=False)})
    #if len(urls) > 0:
    #    # getting remote urls
    #    if wlan_only and "Not connected" in check_output(["iw", "dev", "wlan0", "link"]).decode("utf-8"):
    #        print("WLAN not connected")
    #        urls = []
    return urls, whitelist, whitelist_priority, sanitize, single_editable

urls, whitelist, whitelist_priority, sanitize, single_editable = load_sources()

def add_default_entry(hosts, native = False):
    if native:
        hosts.add(entries = [
            HostsEntry(entry_type = 'ipv6',
                        address = '::1', names = ['localhost6.localdomain6', 'localhost6'])
        ])
    else:
        hosts.add(entries = [
            HostsEntry(entry_type = 'ipv4',
                        address = '127.0.0.1', names = ['localhost.localdomain', 'localhost'])
        ])
    return 0

def write_error_log(errlog=None):
    print(errlog)
    oserrlog1 = "echo -e \"" + "--\n$(date)" + "\" >> " + ERRLOG_FILE_PATH + " | su - " + ADMIN_USER
    oserrlog2 = "echo    \"" + errlog        + "\" >> " + ERRLOG_FILE_PATH + " | su - " + ADMIN_USER
    os.system(oserrlog1)
    os.system(oserrlog2)

def write_hosts(hosts, remote_entries=None, path=None, editable_path=None, whitelist=whitelist, android=False):
    # Insert entries
    if remote_entries:
        hosts.entries = list(remote_entries)
    if not editable_path:
        editable_path = path + ".editable"
    check_hosts(editable_path)
    if whitelist_priority:
        hosts.import_file(editable_path)
    # whitelist functionality
    for entry in whitelist:
        hosts.remove_all_matching(name=entry)
    if not whitelist_priority:
        hosts.import_file(editable_path, write_file = False)
    # Add default entries
    add_default_entry(hosts, native = False)
    if not android:
        add_default_entry(hosts, native = True)
    try:
        hosts.write(path=path)
    except UnableToWriteHosts:
        write_error_log("ERROR: could not write " + path)
    return True

def rebuild_hosts(path, android=False):
    #new_hosts = Hosts() #would read all /etc/hosts entries, which we do not want
    new_hosts = Hosts(path) #will except -catched- on populate as this path is yet invalid
    #new_hosts.add(entry_type = 'comment', comment = ">> created by hosts-adblock-plus <<")
    add_default_entry(new_hosts, native = False)
    if not android:
        add_default_entry(new_hosts, native = True)
    try:
        new_hosts.write(path)
    except UnableToWriteHosts:
        write_error_log("ERROR: could not rebuild/write " + path)

def check_hosts(path, android=False):
    if android1_hosts in path:
        android = True
    if not os.path.isfile(path):
        rebuild_hosts(path, android)

def write_all(hosts):
    # Workaround to copy remote entries and keep different .editable files split
    remote_entries = list(hosts.entries)
    
    if os.path.isdir(android1_dir):
        write_hosts(hosts, remote_entries = remote_entries, path = android1_hosts, android = True)
    if os.path.isdir(android2_dir):
        write_hosts(hosts, remote_entries = remote_entries, path = android2_hosts, android = True)
    write_hosts(hosts, remote_entries = remote_entries, path = native_hosts)
    return 0

def update(remote_sources = urls):
    """
    Main update function - takes a list of remote source URLs, writes all available hosts and returns 0.
    """
    hosts = Hosts(path=tmp_hosts)
    if os.path.isfile(ERRLOG_FILE_PATH):
        os.remove(ERRLOG_FILE_PATH)
    
    # Adding remote sources
    for remote_source in remote_sources:
        try:
            print(remote_source['url'])
            hosts.import_url(url = remote_source['url'], single_format = remote_source['single_format'], sanitize = sanitize)
        except Exception as e:
            write_error_log('WARNING: URL ' + remote_source['url'] + ' - ' + str(e))

    # Workaround to copy remote entries and keep different .editable files split
    write_all(hosts)
    if os.path.isfile(tmp_hosts):
        os.remove(tmp_hosts)
    data = {
        'time': time.time(),
        'sources': len(remote_sources)
        }
    with open(LOGFILE_LAST, 'w') as outfile:
        json.dump(data, outfile)
    return 0

def reset_hosts():
    return update(remote_sources = [])



if __name__ == '__main__':
    if not os.path.isfile(CONFIG_ETC_PATH):
        copyfile(CONFIG_APP_PATH, CONFIG_ETC_PATH)
    try:
        print ('Check internet')
        socket.gethostbyname('www.google.com')
        print ('Internet connected')
    except:
        print ('Internet not connected')
        write_error_log('ERROR: no internet - canceling update')
    else:
        #config_etc = configparser.ConfigParser()
        #config_etc.read(CONFIG_ETC_PATH)
        #config_home = configparser.ConfigParser()
        #config_home.read(CONFIG_HOME_PATH)
        for entry in config_etc.sections():
            if entry in ['SETTINGS', 'DEFAULT']:
                wlan_only = config_home.getboolean("SETTINGS", "WlanOnly", fallback = config_etc.getboolean("SETTINGS", "WlanOnly", fallback = True))
        if wlan_only and "Not connected" in check_output(["iw", "dev", "wlan0", "link"]).decode("utf-8"):
            print('WLAN not connected')
            write_error_log('ERROR: WLAN required but not connected - canceling update')
        else:
            update(urls)
    if os.path.isfile(UPDATE_FILE_PATH):
        os.remove(UPDATE_FILE_PATH)
