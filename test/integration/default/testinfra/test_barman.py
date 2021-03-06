import testinfra

def test_barman_is_installed(host):
    barman = host.package("barman")
    assert barman.is_installed

def test_config_file(host):
    barman = host.file("/etc/barman.conf")
    assert barman.contains("log_level")
    assert barman.contains("gzip")

def test_host_config_file_for_streaming(host):
    barman = host.file("/etc/barman.d/pgsql1.conf")
    assert barman.contains("pgsql1")
    assert barman.contains("barman")
    assert barman.contains("postgres")

def  test_host_config_file_for_rsync(host):
    barman = host.file("/etc/barman.d/pgsql2.conf")
    assert barman.contains("pgsql2")
    assert barman.contains("link")
    assert barman.contains("rsync")
