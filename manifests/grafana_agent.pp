# paw_grafana_grafana::grafana_agent
# @summary Manage paw_grafana_grafana configuration
#
# @param grafana_agent_mode Docs: https://grafana.com/docs/agent/latest/flow/
# @param key
# @param value
# @param grafana_agent_user os user to create for the agent to run as
# @param grafana_agent_user_group os user group to create for the agent
# @param grafana_agent_data_dir data directory to create for the wal and positions
# @param grafana_agent_config_dir directory to store the configuration files in
# @param grafana_agent_env_file name of the environment file loaded by the system unit file
# @param grafana_agent_install_dir directory to install the binary to
# @param grafana_agent_binary name to use for the binary
# @param flag
# @param flag_value
# @param flag_value_item
# @param grafana_agent_config_filename name of the configuration file for the agent
# @param grafana_agent_positions_dir positions directory to use, should be a sub-folder of grafana_agent_data_dir, will automatically be created when the agent starts
# @param grafana_agent_wal_dir wal directory to use, should be a sub-folder of grafana_agent_data_dir, will automatically be created when the agent starts
# @param grafana_agent_version version of the agent to install
# @param grafana_agent_base_download_url base download url. Github or mirror to download from
# @param grafana_agent_service_extra dictionary of additional custom settings for the systemd service file
# @param grafana_agent_local_tmp_dir temporary directory to create on the controller/localhost where the archive will be downloaded to
# @param grafana_agent_user_groups (See https://github.com/grafana/grafana-ansible-collection/issues/40)
# @param grafana_agent_user_shell the shell for the user
# @param grafana_agent_user_createhome whether or not to create a home directory for the user
# @param grafana_agent_local_binary_file manually downloaded the binary
# @param grafana_agent_flags_extra Docs: https://grafana.com/docs/agent/latest/static/configuration/flags/
# @param grafana_agent_env_vars sets Environment variables in the systemd service configuration.
# @param grafana_agent_env_file_vars be aware of boolean values, when output they will result in the proper-cased string "True" and "False"
# @param grafana_agent_provisioned_config_file path to a config file on the controller that will be used instead of the provided configs below if specified.
# @param grafana_agent_server_config the entire dictionary value for this object is copied to the server: block in the config file
# @param grafana_agent_metrics_config the entire dictionary value for this object is copied to the metrics: block in the config file
# @param grafana_agent_logs_config the entire dictionary value for this object is copied to the logs: block in the config file
# @param grafana_agent_traces_config the entire dictionary value for this object is copied to the traces: block in the config file
# @param grafana_agent_integrations_config the entire dictionary value for this object is copied to the integrations: block in the config file
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_grafana_grafana::grafana_agent (
  String $grafana_agent_mode = 'static',
  Optional[String] $key = undef,
  Optional[String] $value = undef,
  String $grafana_agent_user = 'grafana-agent',
  String $grafana_agent_user_group = 'grafana-agent',
  String $grafana_agent_data_dir = '/var/lib/grafana-agent',
  String $grafana_agent_config_dir = '/etc/grafana-agent',
  String $grafana_agent_env_file = 'service.env',
  String $grafana_agent_install_dir = '/opt/grafana-agent/bin',
  String $grafana_agent_binary = 'grafana-agent',
  Optional[String] $flag = undef,
  Optional[String] $flag_value = undef,
  Optional[String] $flag_value_item = undef,
  String $grafana_agent_config_filename = 'config.yaml',
  String $grafana_agent_positions_dir = '{{ grafana_agent_data_dir }}/positions',
  String $grafana_agent_wal_dir = '{{ grafana_agent_data_dir }}/wal',
  String $grafana_agent_version = 'latest',
  String $grafana_agent_base_download_url = 'https://github.com/{{ _grafana_agent_github_org }}/{{ _grafana_agent_github_repo }}/releases/download',
  Hash $grafana_agent_service_extra = {},
  String $grafana_agent_local_tmp_dir = '/tmp/grafana-agent',
  Array $grafana_agent_user_groups = [],
  String $grafana_agent_user_shell = '/usr/sbin/nologin',
  Boolean $grafana_agent_user_createhome = false,
  Optional[String] $grafana_agent_local_binary_file = undef,
  Hash $grafana_agent_flags_extra = { 'config.expand-env' => 'true', 'config.enable-read-api' => 'false', 'server.register-instrumentation' => 'true', 'server.http.address' => '127.0.0.1:12345', 'server.grpc.address' => '127.0.0.1:12346' },
  Hash $grafana_agent_env_vars = {},
  Hash $grafana_agent_env_file_vars = {},
  Optional[String] $grafana_agent_provisioned_config_file = undef,
  Hash $grafana_agent_server_config = { 'log_level' => 'info' },
  Hash $grafana_agent_metrics_config = { 'global' => { 'scrape_interval' => '1m', 'scrape_timeout' => '10s', 'external_labels' => {}, 'remote_write' => [] }, 'configs' => [], 'wal_directory' => '{{ grafana_agent_wal_dir }}', 'wal_cleanup_age' => '12h', 'wal_cleanup_period' => '30m' },
  Hash $grafana_agent_logs_config = { 'positions_directory' => '{{ grafana_agent_positions_dir }}', 'global' => { 'clients' => [] } },
  Hash $grafana_agent_traces_config = { 'configs' => [] },
  Hash $grafana_agent_integrations_config = { 'scrape_integrations' => true, 'agent' => { 'enabled' => true, 'relabel_configs' => [], 'metric_relabel_configs' => [] }, 'node_exporter' => { 'enabled' => true } },
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/grafana_grafana/roles/grafana_agent/playbook.yml"

  par { 'paw_grafana_grafana_grafana_agent-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'grafana_agent_mode'                    => $grafana_agent_mode,
      'key'                                   => $key,
      'value'                                 => $value,
      'grafana_agent_user'                    => $grafana_agent_user,
      'grafana_agent_user_group'              => $grafana_agent_user_group,
      'grafana_agent_data_dir'                => $grafana_agent_data_dir,
      'grafana_agent_config_dir'              => $grafana_agent_config_dir,
      'grafana_agent_env_file'                => $grafana_agent_env_file,
      'grafana_agent_install_dir'             => $grafana_agent_install_dir,
      'grafana_agent_binary'                  => $grafana_agent_binary,
      'flag'                                  => $flag,
      'flag_value'                            => $flag_value,
      'flag_value_item'                       => $flag_value_item,
      'grafana_agent_config_filename'         => $grafana_agent_config_filename,
      'grafana_agent_positions_dir'           => $grafana_agent_positions_dir,
      'grafana_agent_wal_dir'                 => $grafana_agent_wal_dir,
      'grafana_agent_version'                 => $grafana_agent_version,
      'grafana_agent_base_download_url'       => $grafana_agent_base_download_url,
      'grafana_agent_service_extra'           => $grafana_agent_service_extra,
      'grafana_agent_local_tmp_dir'           => $grafana_agent_local_tmp_dir,
      'grafana_agent_user_groups'             => $grafana_agent_user_groups,
      'grafana_agent_user_shell'              => $grafana_agent_user_shell,
      'grafana_agent_user_createhome'         => $grafana_agent_user_createhome,
      'grafana_agent_local_binary_file'       => $grafana_agent_local_binary_file,
      'grafana_agent_flags_extra'             => $grafana_agent_flags_extra,
      'grafana_agent_env_vars'                => $grafana_agent_env_vars,
      'grafana_agent_env_file_vars'           => $grafana_agent_env_file_vars,
      'grafana_agent_provisioned_config_file' => $grafana_agent_provisioned_config_file,
      'grafana_agent_server_config'           => $grafana_agent_server_config,
      'grafana_agent_metrics_config'          => $grafana_agent_metrics_config,
      'grafana_agent_logs_config'             => $grafana_agent_logs_config,
      'grafana_agent_traces_config'           => $grafana_agent_traces_config,
      'grafana_agent_integrations_config'     => $grafana_agent_integrations_config,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}
