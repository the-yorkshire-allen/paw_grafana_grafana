# paw_grafana_grafana::mimir
# @summary Manage paw_grafana_grafana configuration
#
# @param mimir_version defaults file for mimir
# @param mimir_uninstall
# @param du__mimir_arch
# @param mimir_download_url_rpm
# @param mimir_download_url_deb
# @param mimir_working_path
# @param mimir_ruler_alert_path
# @param mimir_http_listen_port
# @param mimir_http_listen_address
# @param arch_mapping
# @param mimir_server
# @param mimir_ruler
# @param mimir_alertmanager
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_grafana_grafana::mimir (
  String $mimir_version = 'latest',
  Boolean $mimir_uninstall = false,
  String $du__mimir_arch = '{{ arch_mapping[ansible_facts[\'architecture\']] | default(\'amd64\') }}',
  String $mimir_download_url_rpm = 'https://github.com/grafana/mimir/releases/download/mimir-{{ mimir_version }}/mimir-{{ mimir_version }}_{{ __mimir_arch }}.rpm',
  String $mimir_download_url_deb = 'https://github.com/grafana/mimir/releases/download/mimir-{{ mimir_version }}/mimir-{{ mimir_version }}_{{ __mimir_arch }}.deb',
  String $mimir_working_path = '/var/lib/mimir',
  String $mimir_ruler_alert_path = '{{ mimir_working_path }}/ruler',
  Integer $mimir_http_listen_port = 8080,
  String $mimir_http_listen_address = '0.0.0.0',
  Hash $arch_mapping = { 'x86_64' => 'amd64', 'aarch64' => 'arm64', 'armv7l' => 'armhf', 'i386' => 'i386', 'ppc64le' => 'ppc64le' },
  Hash $mimir_server = { 'http_listen_port' => '{{ mimir_http_listen_port }}', 'http_listen_address' => '{{ mimir_http_listen_address }}' },
  Hash $mimir_ruler = { 'rule_path' => '{{ mimir_working_path }}/ruler', 'alertmanager_url' => 'http://localhost:{{ mimir_http_listen_port }}/alertmanager' },
  Hash $mimir_alertmanager = { 'data_dir' => '{{ mimir_working_path }}/alertmanager', 'external_url' => 'http://localhost:{{ mimir_http_listen_port }}/alertmanager' },
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/grafana_grafana/roles/mimir/playbook.yml"

  par { 'paw_grafana_grafana_mimir-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'mimir_version'             => $mimir_version,
      'mimir_uninstall'           => $mimir_uninstall,
      '__mimir_arch'              => $du__mimir_arch,
      'mimir_download_url_rpm'    => $mimir_download_url_rpm,
      'mimir_download_url_deb'    => $mimir_download_url_deb,
      'mimir_working_path'        => $mimir_working_path,
      'mimir_ruler_alert_path'    => $mimir_ruler_alert_path,
      'mimir_http_listen_port'    => $mimir_http_listen_port,
      'mimir_http_listen_address' => $mimir_http_listen_address,
      'arch_mapping'              => $arch_mapping,
      'mimir_server'              => $mimir_server,
      'mimir_ruler'               => $mimir_ruler,
      'mimir_alertmanager'        => $mimir_alertmanager,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}
