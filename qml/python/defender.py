import configparser
import os
import sqlite3
from stat import S_IREAD, S_IRGRP, S_IROTH, S_IWUSR
from subprocess import check_output
import json
import datetime

APP_NAME = 'defender'

#CONFIG_HOME_DIR = '/home/nemo/.config/harbour-' + APP_NAME
HOME_DIR = os.environ['HOME']
os.system("echo -n '" + HOME_DIR + "' > /tmp/defender.dir")
CONFIG_HOME_DIR = HOME_DIR + '/.config/harbour-' + APP_NAME
CONFIG_ETC_DIR = '/etc'

CONFIG_ETC_PATH = CONFIG_ETC_DIR + '/'  + APP_NAME + '.conf'
CONFIG_HOME_PATH = CONFIG_HOME_DIR + '/'  + APP_NAME + '.conf'

UPDATE_FILE_PATH = CONFIG_HOME_DIR + '/' + 'update'
UPDLOOP_FILE_PATH = CONFIG_HOME_DIR + '/' + 'updLoop'
ADRESTART_FILE_PATH = CONFIG_HOME_DIR + '/' + 'adRestart'
ERRLOG_FILE_PATH = CONFIG_HOME_DIR + '/' + 'error.log'
LOGFILE_LAST = '/var/log/'+ APP_NAME +'_last.json'

cookies_path = HOME_DIR + '/.local/share/org.sailfishos/browser/.mozilla/' + 'cookies.sqlite'
if not os.path.isfile(cookies_path):
    cookies_path = HOME_DIR + '/.mozilla/mozembed/' + 'cookies.sqlite'
#nope, cookies_path += '?immutable=1'

def initialize():
    if not os.path.isdir(CONFIG_HOME_DIR):
        os.makedirs(CONFIG_HOME_DIR)

initialize()

def merge_source_configs(config1, config2, force=False, enabled='no'):
    output = []
    config2 = rebuild_config(config1, config2, force, enabled)
    for entry in config1.sections():
        if entry in ['SETTINGS', 'DEFAULT']:
            pass
        else:
            source_dict = dict(config1._sections[entry].copy())
            source_dict['source_id'] = entry
            #if entry in config2.sections() and 'SourceEnabled' in config2[entry]:
            source_dict['sourceenabled'] = config2.getboolean(entry, 'SourceEnabled', fallback=config1.getboolean(entry, 'SourceEnabled', fallback=False))
            output.append(source_dict)
    return output



def load_sources(force=False, enabled='no'):
    config_etc = configparser.ConfigParser()
    config_etc.read(CONFIG_ETC_PATH)
    config_home = configparser.ConfigParser()
    config_home.read(CONFIG_HOME_PATH)
    output = merge_source_configs(config_etc, config_home, force, enabled)
    return output

def change_config(section, key, value):
    if type(value) == type(True):
        if value:
            value = 'yes'
        else:
            value = 'no'
    elif type(value) == type(1):
        value = str(value)
    config_home = configparser.ConfigParser()
    config_home.read(CONFIG_HOME_PATH)
    config_home[section][key] = value
    with open(CONFIG_HOME_PATH, 'w') as configfile:
        config_home.write(configfile)
    return True

def get_config_bool(section, key, fallback):
    config_home = configparser.ConfigParser()
    config_home.read(CONFIG_ETC_PATH)
    config_home.read(CONFIG_HOME_PATH)
    return config_home.getboolean(section, key, fallback=True)

def rebuild_config(config1, config2, force=False, enabled='no'):
    if not os.path.isdir(CONFIG_HOME_DIR):
        os.makedirs(CONFIG_HOME_DIR)
    if (set(config1.sections()) != set(config2.sections())) or force:
        new_config = configparser.ConfigParser()
        for entry in config1.sections():
            new_config.add_section(entry)
            if entry in ['SETTINGS', 'DEFAULT']:
                if force:
                    new_config.set(entry, 'DomainBlacklist', '')
                    new_config.set(entry, 'DomainWhitelist', '')
            else:
                if force:
                    new_config.set(entry, 'SourceEnabled', enabled)
                elif entry in config2.sections() and 'SourceEnabled' in config2[entry]:
                    new_config.set(entry, 'SourceEnabled', config2[entry]['SourceEnabled'])
                else:
                    new_config.set(entry, 'SourceEnabled', config1[entry]['SourceEnabled'])
        with open(CONFIG_HOME_PATH, 'w') as configfile:
            new_config.write(configfile)
        return new_config
    else:
        return config2

def disable_all():
    output = load_sources(force=True, enabled='no')
    update_now()
    return output

def clear_update_loop():
    #os.system("ps aux | grep -v grep | grep defender_updater | tr -s ' ' | cut -d' ' -f2 | xargs kill")
    os.system("ps aux | grep -v grep | grep defender_updater; \
               if [ 0 == $? ]; then \
                   echo '--' >> " + ERRLOG_FILE_PATH + "; \
                   echo 'INFO: update was still running - cancelled' >> " + ERRLOG_FILE_PATH + "; \
                   `#systemctl stop harbour-defender; \
                   #above would need root rights (defender_updater), possibly via service/path unit:` \
                   touch " + UPDLOOP_FILE_PATH + "; sleep 1; \
               fi;")
    show_error_log()
    if os.path.isfile(UPDATE_FILE_PATH):
        os.remove(UPDATE_FILE_PATH)
    if os.path.isfile(UPDLOOP_FILE_PATH):
        os.remove(UPDLOOP_FILE_PATH)

def show_error_log():
    if os.path.isfile(ERRLOG_FILE_PATH):
        os.system("sailfish-browser " + ERRLOG_FILE_PATH + " &")

def restart_android_support():
    #os.system("systemctl restart aliendalvik")
    #os.system("systemctl restart appsupport")
    ##above would need root rights (defender_updater), possibly via service/path unit:
    os.system("touch " + ADRESTART_FILE_PATH + "; sleep 1;")
    if os.path.isfile(ADRESTART_FILE_PATH):
        os.remove(ADRESTART_FILE_PATH)

def update_now():
    """
    Creates a file in the config directory, which triggers an update.
    """
    if os.path.isfile(UPDATE_FILE_PATH):
        os.remove(UPDATE_FILE_PATH)
    touch(UPDATE_FILE_PATH)
    return 0

def check_update():
    return os.path.isfile(UPDATE_FILE_PATH)

def touch(path):
    with open(path, 'a'):
        os.utime(path, None)

def load_query(cur, searchStr=None):
    if searchStr and searchStr.isalnum():
        query = cur.execute("SELECT * FROM moz_cookies WHERE host LIKE ? ORDER BY host, creationTime", ('%'+searchStr+'%',))
    else:
        query = cur.execute('SELECT * FROM moz_cookies ORDER BY host, creationTime')
    colname = [ d[0] for d in query.description ]
    result_list = [ dict(zip(colname, r)) for r in query.fetchall() ]
    return result_list

def load_cookies(searchStr=None):
    cur = sqlite3.connect(cookies_path).cursor()
    result_list = load_query(cur, searchStr)
    cur.connection.close()
    return result_list

def cookie_delete_single(cookieId, searchStr=None):
    cur = sqlite3.connect(cookies_path).cursor()
    data = cur.execute("DELETE FROM moz_cookies WHERE id=?", (cookieId,))
    cur.connection.commit()
    result_list = load_query(cur, searchStr)
    cur.connection.close()
    return result_list

def cookie_delete_domain(cookieDomain, searchStr=None):
    cur = sqlite3.connect(cookies_path).cursor()
    data = cur.execute("DELETE FROM moz_cookies WHERE host=?", (cookieDomain,))
    cur.connection.commit()
    result_list = load_query(cur, searchStr)
    cur.connection.close()
    return result_list

def cookie_delete_blacklist(cookieBlacklist, searchStr=None):
    cur = sqlite3.connect(cookies_path).cursor()
    sql = "DELETE FROM moz_cookies WHERE host IN ({seq})".format(
    seq=','.join(['?']*len(cookieBlacklist)))
    cur.execute(sql, cookieBlacklist)
    cur.connection.commit()
    result_list = load_query(cur, searchStr)
    cur.connection.close()
    return result_list

def cookie_delete_whitelist(cookieWhitelist, searchStr=None):
    cur = sqlite3.connect(cookies_path).cursor()
    sql = "DELETE FROM moz_cookies WHERE host NOT IN ({seq})".format(
    seq=','.join(['?']*len(cookieWhitelist)))
    cur.execute(sql, cookieWhitelist)
    cur.connection.commit()
    result_list = load_query(cur, searchStr)
    cur.connection.close()
    return result_list

def cookie_load_list(blacklist = False):
    if blacklist:
        key = 'DomainBlacklist'
    else:
        key = 'DomainWhitelist'
    config_home = configparser.ConfigParser()
    config_home.read(CONFIG_HOME_PATH)
    try:
        result = config_home.get('SETTINGS', key).split(',')
    except:
        result = []
    return result

def cookie_write_list(domainList, blacklist = False):
    if blacklist:
        key = 'DomainBlacklist'
    else:
        key = 'DomainWhitelist'
    domainListStr = ','.join(domainList)
    config_home = configparser.ConfigParser()
    config_home.read(CONFIG_HOME_PATH)
    if "SETTINGS" not in config_home.sections():
        config_home.add_section('SETTINGS')
    config_home.set('SETTINGS', key, domainListStr)
    with open(CONFIG_HOME_PATH, 'w') as configfile:
        config_home.write(configfile)
    return 0

def cookie_locker(lock = False):
    """
    Locks the cookie file against changes. That way one can limit the cookies
    saved to only those that are already present.
    """
    if lock:
        os.chmod(cookies_path, S_IREAD|S_IRGRP|S_IROTH)
    else:
        os.chmod(cookies_path, S_IWUSR|S_IREAD)
    return 0

def cookie_is_locked():
    """
    Returns boolean
    """
    st = os.stat(cookies_path)
    return not bool(st.st_mode & S_IWUSR)

def get_stats():
    hosts_lines = int(check_output(["wc", "-l", "/etc/hosts"]).decode("utf-8").split(' ')[0])
    hosts_editable_lines = int(check_output(["wc", "-l", "/etc/hosts.editable"]).decode("utf-8").split(' ')[0])
    config_etc = configparser.ConfigParser()
    config_etc.read(CONFIG_ETC_PATH)
    config_home = configparser.ConfigParser()
    config_home.read(CONFIG_HOME_PATH)
    sources = merge_source_configs(config_etc, config_home)
    sources_count = len(sources)
    sources_enabled_count = 0
    for src in sources:
        if src['sourceenabled']:
            sources_enabled_count += 1
    cur = sqlite3.connect(cookies_path).cursor()
    cookies_count, domains_count = cur.execute("SELECT COUNT(*) AS cookies_count, COUNT(DISTINCT host) AS domains_count FROM moz_cookies").fetchall()[0]
    cur.connection.close()
    cookie_bl_count = len(cookie_load_list(blacklist = True))
    if os.path.isfile(LOGFILE_LAST):
        with open(LOGFILE_LAST) as data_file:    
            data = json.load(data_file)
            last_time = data['time']
            last_sources = data['sources']
    else:
        last_time = 0
        last_sources = 0
    return {'hosts_lines': hosts_lines, 'hosts_editable_lines': hosts_editable_lines, 'sources_count': sources_count, 'sources_enabled_count': sources_enabled_count, 'cookies_count': cookies_count, 'domains_count': domains_count, 'cookie_bl_count': cookie_bl_count, 'last_time': datetime.datetime.fromtimestamp(int(last_time)), 'last_sources': last_sources}
    
