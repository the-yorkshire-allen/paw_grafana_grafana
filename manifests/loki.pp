# paw_grafana_grafana::loki
# @summary Manage paw_grafana_grafana configuration
#
# @param loki_target
# @param loki_auth_enabled Default Variables for /etc/loki/config.yml
# @param loki_ballast_bytes
# @param loki_version defaults file for loki
# @param loki_uninstall
# @param loki_http_listen_port
# @param loki_http_listen_address
# @param loki_expose_port
# @param loki_download_url_rpm
# @param loki_download_url_deb
# @param loki_working_path
# @param loki_ruler_alert_path
# @param loki_server
# @param loki_common
# @param loki_query_range
# @param loki_schema_config
# @param loki_ruler
# @param loki_analytics
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_grafana_grafana::loki (
  String $loki_target = 'all',
  Boolean $loki_auth_enabled = false,
  Integer $loki_ballast_bytes = 0,
  String $loki_version = 'latest',
  Boolean $loki_uninstall = false,
  Integer $loki_http_listen_port = 3100,
  String $loki_http_listen_address = '0.0.0.0',
  Boolean $loki_expose_port = false,
  String $loki_download_url_rpm = 'https://github.com/grafana/loki/releases/download/v{{ loki_version }}/loki-{{ loki_version }}.{{ __loki_arch }}.rpm',
  String $loki_download_url_deb = 'https://github.com/grafana/loki/releases/download/v{{ loki_version }}/loki_{{ loki_version }}_{{ __loki_arch }}.deb',
  String $loki_working_path = '/var/lib/loki',
  String $loki_ruler_alert_path = '{{ loki_working_path }}/rules/fake',
  Hash $loki_server = { 'http_listen_address' => '{{ loki_http_listen_address }}', 'http_listen_port' => '{{ loki_http_listen_port }}', 'grpc_listen_port' => 9096 },
  Hash $loki_common = { 'instance_addr' => '127.0.0.1', 'path_prefix' => '{{ loki_working_path }}', 'storage' => { 'filesystem' => { 'chunks_directory' => '{{ loki_working_path }}/chunks', 'rules_directory' => '{{ loki_working_path }}/rules' } }, 'replication_factor' => 1, 'ring' => { 'kvstore' => { 'store' => 'inmemory' } } },
  Hash $loki_query_range = { 'results_cache' => { 'cache' => { 'embedded_cache' => { 'enabled' => true, 'max_size_mb' => 100 } } } },
  Hash $loki_schema_config = { 'configs' => [{ 'from' => '2020-10-24', 'store' => 'tsdb', 'object_store' => 'filesystem', 'schema' => 'v13', 'index' => { 'prefix' => 'index_', 'period' => '24h' } }] },
  Hash $loki_ruler = { 'storage' => { 'type' => 'local', 'local' => { 'directory' => '{{ loki_working_path }}/rules' } }, 'rule_path' => '{{ loki_working_path }}/rules_tmp', 'ring' => { 'kvstore' => { 'store' => 'inmemory' } }, 'enable_api' => true, 'enable_alertmanager_v2' => true, 'alertmanager_url' => 'http://localhost:9093' },
  Hash $loki_analytics = { 'reporting_enabled' => false },
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/grafana_grafana/roles/loki/playbook.yml"

  par { 'paw_grafana_grafana_loki-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'loki_target'              => $loki_target,
      'loki_auth_enabled'        => $loki_auth_enabled,
      'loki_ballast_bytes'       => $loki_ballast_bytes,
      'loki_version'             => $loki_version,
      'loki_uninstall'           => $loki_uninstall,
      'loki_http_listen_port'    => $loki_http_listen_port,
      'loki_http_listen_address' => $loki_http_listen_address,
      'loki_expose_port'         => $loki_expose_port,
      'loki_download_url_rpm'    => $loki_download_url_rpm,
      'loki_download_url_deb'    => $loki_download_url_deb,
      'loki_working_path'        => $loki_working_path,
      'loki_ruler_alert_path'    => $loki_ruler_alert_path,
      'loki_server'              => $loki_server,
      'loki_common'              => $loki_common,
      'loki_query_range'         => $loki_query_range,
      'loki_schema_config'       => $loki_schema_config,
      'loki_ruler'               => $loki_ruler,
      'loki_analytics'           => $loki_analytics,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}
