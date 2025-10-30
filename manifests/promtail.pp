# paw_grafana_grafana::promtail
# @summary Manage paw_grafana_grafana configuration
#
# @param flag
# @param each_dir
# @param each_log
# @param promtail_version defaults file for promtail
# @param promtail_uninstall
# @param promtail_http_listen_port
# @param promtail_http_listen_address
# @param promtail_expose_port
# @param promtail_positions_path
# @param promtail_runtime_mode
# @param promtail_extra_flags
# @param promtail_user_append_groups
# @param promtail_download_url_rpm
# @param promtail_download_url_deb
# @param promtail_server default variables for /etc/promtail/config.yml
# @param promtail_positions
# @param promtail_clients
# @param promtail_scrape_configs
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_grafana_grafana::promtail (
  Optional[String] $flag = undef,
  Optional[String] $each_dir = undef,
  Optional[String] $each_log = undef,
  String $promtail_version = 'latest',
  Boolean $promtail_uninstall = false,
  Integer $promtail_http_listen_port = 9080,
  String $promtail_http_listen_address = '0.0.0.0',
  Boolean $promtail_expose_port = false,
  String $promtail_positions_path = '/var/lib/promtail',
  String $promtail_runtime_mode = 'acl',
  Array $promtail_extra_flags = [],
  Array $promtail_user_append_groups = ['systemd-journal'],
  String $promtail_download_url_rpm = 'https://github.com/grafana/loki/releases/download/v{{ promtail_version }}/promtail-{{ promtail_version }}.{{ __promtail_arch }}.rpm',
  String $promtail_download_url_deb = 'https://github.com/grafana/loki/releases/download/v{{ promtail_version }}/promtail_{{ promtail_version }}_{{ __promtail_arch }}.deb',
  Hash $promtail_server = { 'http_listen_port' => '{{ promtail_http_listen_port }}', 'http_listen_address' => '{{ promtail_http_listen_address }}' },
  Hash $promtail_positions = { 'filename' => '{{ promtail_positions_path }}/positions.yaml' },
  Array $promtail_clients = [],
  Array $promtail_scrape_configs = [],
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/grafana_grafana/roles/promtail/playbook.yml"

  par { 'paw_grafana_grafana_promtail-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'flag'                         => $flag,
      'each_dir'                     => $each_dir,
      'each_log'                     => $each_log,
      'promtail_version'             => $promtail_version,
      'promtail_uninstall'           => $promtail_uninstall,
      'promtail_http_listen_port'    => $promtail_http_listen_port,
      'promtail_http_listen_address' => $promtail_http_listen_address,
      'promtail_expose_port'         => $promtail_expose_port,
      'promtail_positions_path'      => $promtail_positions_path,
      'promtail_runtime_mode'        => $promtail_runtime_mode,
      'promtail_extra_flags'         => $promtail_extra_flags,
      'promtail_user_append_groups'  => $promtail_user_append_groups,
      'promtail_download_url_rpm'    => $promtail_download_url_rpm,
      'promtail_download_url_deb'    => $promtail_download_url_deb,
      'promtail_server'              => $promtail_server,
      'promtail_positions'           => $promtail_positions,
      'promtail_clients'             => $promtail_clients,
      'promtail_scrape_configs'      => $promtail_scrape_configs,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}
