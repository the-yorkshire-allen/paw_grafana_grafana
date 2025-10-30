# paw_grafana_grafana::grafana
# @summary Manage paw_grafana_grafana configuration
#
# @param k
# @param v
# @param section
# @param sub_key
# @param sub_value
# @param grafana_version
# @param grafana_manage_repo
# @param grafana_yum_repo
# @param grafana_yum_key
# @param grafana_rhsm_subscription
# @param grafana_rhsm_repo
# @param grafana_apt_release_channel
# @param grafana_apt_arch
# @param grafana_apt_repo_uri
# @param grafana_apt_repo
# @param grafana_apt_key
# @param grafana_apt_name
# @param grafana_use_provisioning Should we use the provisioning capability when possible (provisioning require grafana >= 5.0)
# @param grafana_provisioning_synced Should the provisioning be kept synced. If true, previous provisioned objects will be removed if not referenced anymore.
# @param grafana_provisioning_dashboards_from_file_structure Should we provision dashboards by following the files structure. This sets the foldersFromFilesStructure option
# @param grafana_cap_net_bind_service Get informed by reading: http://man7.org/linux/man-pages/man7/capabilities.7.html
# @param grafana_ini_default
# @param grafana_api_url
# @param grafana_ldap
# @param grafana_plugins Plugins to install from https://grafana.com/plugins
# @param grafana_dashboards Dashboards from https://grafana.com/dashboards
# @param grafana_dashboards_dir
# @param grafana_alert_notifications Alert notification channels to configure
# @param grafana_alert_resources Alert resources channels to configure
# @param grafana_datasources Datasources to configure
# @param grafana_api_keys API keys to configure
# @param grafana_api_keys_dir The location where the keys should be stored.
# @param grafana_environment
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_grafana_grafana::grafana (
  Optional[String] $k = undef,
  Optional[String] $v = undef,
  Optional[String] $section = undef,
  Optional[String] $sub_key = undef,
  Optional[String] $sub_value = undef,
  String $grafana_version = 'latest',
  Boolean $grafana_manage_repo = true,
  String $grafana_yum_repo = 'https://rpm.grafana.com',
  String $grafana_yum_key = 'https://rpm.grafana.com/gpg.key',
  Optional[String] $grafana_rhsm_subscription = undef,
  Optional[String] $grafana_rhsm_repo = undef,
  String $grafana_apt_release_channel = 'stable',
  String $grafana_apt_arch = '{{ \'arm64\' if ansible_facts[\'architecture\'] == \'aarch64\' else \'amd64\' }}',
  String $grafana_apt_repo_uri = 'https://apt.grafana.com/',
  String $grafana_apt_repo = 'deb [arch={{ grafana_apt_arch }} signed-by=/usr/share/keyrings/grafana.asc] {{ grafana_apt_repo_uri }} {{ grafana_apt_release_channel }} main',
  String $grafana_apt_key = 'https://apt.grafana.com/gpg.key',
  String $grafana_apt_name = 'grafana',
  Boolean $grafana_use_provisioning = true,
  Boolean $grafana_provisioning_synced = false,
  Boolean $grafana_provisioning_dashboards_from_file_structure = false,
  Boolean $grafana_cap_net_bind_service = false,
  Hash $grafana_ini_default = { 'instance_name' => '{{ ansible_facts[\'fqdn\'] | default(ansible_host) | default(inventory_hostname) }}', 'paths' => { 'logs' => '/var/log/grafana', 'data' => '/var/lib/grafana' }, 'server' => { 'http_addr' => '0.0.0.0', 'http_port' => 3000, 'domain' => '{{ ansible_facts[\'fqdn\'] | default(ansible_host) | default(\'localhost\') }}', 'protocol' => 'http', 'enforce_domain' => false, 'socket' => '', 'cert_key' => '', 'cert_file' => '', 'enable_gzip' => false, 'static_root_path' => 'public', 'router_logging' => false, 'serve_from_sub_path' => false }, 'security' => { 'admin_user' => 'admin', 'admin_password' => '' }, 'database' => { 'type' => 'sqlite3' }, 'users' => { 'allow_sign_up' => false, 'auto_assign_org_role' => 'Viewer', 'default_theme' => 'dark' }, 'auth' => {} },
  String $grafana_api_url = '{{ grafana_ini.server.root_url }}',
  Hash $grafana_ldap = {},
  Array $grafana_plugins = [],
  Array $grafana_dashboards = [],
  String $grafana_dashboards_dir = 'dashboards',
  Array $grafana_alert_notifications = [],
  Hash $grafana_alert_resources = {},
  Array $grafana_datasources = [],
  Array $grafana_api_keys = [],
  String $grafana_api_keys_dir = '{{ lookup(\'env\', \'HOME\') }}/grafana/keys',
  Hash $grafana_environment = {},
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/grafana_grafana/roles/grafana/playbook.yml"

  par { 'paw_grafana_grafana_grafana-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'k'                                                   => $k,
      'v'                                                   => $v,
      'section'                                             => $section,
      'sub_key'                                             => $sub_key,
      'sub_value'                                           => $sub_value,
      'grafana_version'                                     => $grafana_version,
      'grafana_manage_repo'                                 => $grafana_manage_repo,
      'grafana_yum_repo'                                    => $grafana_yum_repo,
      'grafana_yum_key'                                     => $grafana_yum_key,
      'grafana_rhsm_subscription'                           => $grafana_rhsm_subscription,
      'grafana_rhsm_repo'                                   => $grafana_rhsm_repo,
      'grafana_apt_release_channel'                         => $grafana_apt_release_channel,
      'grafana_apt_arch'                                    => $grafana_apt_arch,
      'grafana_apt_repo_uri'                                => $grafana_apt_repo_uri,
      'grafana_apt_repo'                                    => $grafana_apt_repo,
      'grafana_apt_key'                                     => $grafana_apt_key,
      'grafana_apt_name'                                    => $grafana_apt_name,
      'grafana_use_provisioning'                            => $grafana_use_provisioning,
      'grafana_provisioning_synced'                         => $grafana_provisioning_synced,
      'grafana_provisioning_dashboards_from_file_structure' => $grafana_provisioning_dashboards_from_file_structure,
      'grafana_cap_net_bind_service'                        => $grafana_cap_net_bind_service,
      'grafana_ini_default'                                 => $grafana_ini_default,
      'grafana_api_url'                                     => $grafana_api_url,
      'grafana_ldap'                                        => $grafana_ldap,
      'grafana_plugins'                                     => $grafana_plugins,
      'grafana_dashboards'                                  => $grafana_dashboards,
      'grafana_dashboards_dir'                              => $grafana_dashboards_dir,
      'grafana_alert_notifications'                         => $grafana_alert_notifications,
      'grafana_alert_resources'                             => $grafana_alert_resources,
      'grafana_datasources'                                 => $grafana_datasources,
      'grafana_api_keys'                                    => $grafana_api_keys,
      'grafana_api_keys_dir'                                => $grafana_api_keys_dir,
      'grafana_environment'                                 => $grafana_environment,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}
