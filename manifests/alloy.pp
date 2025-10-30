# paw_grafana_grafana::alloy
# @summary Manage paw_grafana_grafana configuration
#
# @param key
# @param value
# @param alloy_config
# @param alloy_systemd_override
# @param alloy_version defaults file for alloy
# @param alloy_uninstall
# @param alloy_expose_port
# @param alloy_github_api_url
# @param alloy_download_url_rpm
# @param alloy_download_url_deb
# @param alloy_readiness_check_use_https
# @param alloy_readiness_check_use_proxy
# @param alloy_user_groups
# @param alloy_env_file_vars
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_grafana_grafana::alloy (
  Optional[String] $key = undef,
  Optional[String] $value = undef,
  Hash $alloy_config = {},
  Hash $alloy_systemd_override = {},
  String $alloy_version = 'latest',
  Boolean $alloy_uninstall = false,
  Boolean $alloy_expose_port = false,
  String $alloy_github_api_url = 'https://api.github.com/repos/grafana/alloy/releases/latest',
  String $alloy_download_url_rpm = 'https://github.com/grafana/alloy/releases/download/v{{ alloy_version }}/alloy-{{ alloy_version }}-1.{{ __alloy_arch }}.rpm',
  String $alloy_download_url_deb = 'https://github.com/grafana/alloy/releases/download/v{{ alloy_version }}/alloy-{{ alloy_version }}-1.{{ __alloy_arch }}.deb',
  Boolean $alloy_readiness_check_use_https = false,
  Boolean $alloy_readiness_check_use_proxy = true,
  Array $alloy_user_groups = [],
  Hash $alloy_env_file_vars = {},
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/grafana_grafana/roles/alloy/playbook.yml"

  par { 'paw_grafana_grafana_alloy-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'key'                             => $key,
      'value'                           => $value,
      'alloy_config'                    => $alloy_config,
      'alloy_systemd_override'          => $alloy_systemd_override,
      'alloy_version'                   => $alloy_version,
      'alloy_uninstall'                 => $alloy_uninstall,
      'alloy_expose_port'               => $alloy_expose_port,
      'alloy_github_api_url'            => $alloy_github_api_url,
      'alloy_download_url_rpm'          => $alloy_download_url_rpm,
      'alloy_download_url_deb'          => $alloy_download_url_deb,
      'alloy_readiness_check_use_https' => $alloy_readiness_check_use_https,
      'alloy_readiness_check_use_proxy' => $alloy_readiness_check_use_proxy,
      'alloy_user_groups'               => $alloy_user_groups,
      'alloy_env_file_vars'             => $alloy_env_file_vars,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}
