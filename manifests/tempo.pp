# paw_grafana_grafana::tempo
# @summary Manage paw_grafana_grafana configuration
#
# @param tempo_http_api_prefix
# @param tempo_report_usage
# @param tempo_multitenancy_enabled
# @param tempo_version defaults file for tempo
# @param tempo_uninstall
# @param du__tempo_arch
# @param tempo_download_url_rpm
# @param tempo_download_url_deb
# @param tempo_working_path
# @param tempo_http_listen_port
# @param tempo_http_listen_address
# @param tempo_log_level
# @param tempo_server Default Variables from /etc/tempo/config.yml
# @param tempo_query_frontend
# @param tempo_distributor
# @param tempo_metrics_generator
# @param tempo_storage
# @param tempo_overrides
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_grafana_grafana::tempo (
  Optional[String] $tempo_http_api_prefix = undef,
  Boolean $tempo_report_usage = true,
  Boolean $tempo_multitenancy_enabled = false,
  String $tempo_version = 'latest',
  Boolean $tempo_uninstall = false,
  String $du__tempo_arch = '{{ arch_mapping[ansible_facts[\'architecture\']] | default(\'amd64\') }}',
  String $tempo_download_url_rpm = 'https://github.com/grafana/tempo/releases/download/v{{ tempo_version }}/tempo_{{ tempo_version }}_linux_{{ __tempo_arch }}.rpm',
  String $tempo_download_url_deb = 'https://github.com/grafana/tempo/releases/download/v{{ tempo_version }}/tempo_{{ tempo_version }}_linux_{{ __tempo_arch }}.deb',
  String $tempo_working_path = '/var/lib/tempo',
  Integer $tempo_http_listen_port = 3200,
  String $tempo_http_listen_address = '0.0.0.0',
  String $tempo_log_level = 'warn',
  Hash $tempo_server = { 'http_listen_port' => '{{ tempo_http_listen_port }}', 'http_listen_address' => '{{ tempo_http_listen_address }}', 'log_level' => '{{ tempo_log_level }}' },
  Hash $tempo_query_frontend = { 'search' => { 'duration_slo' => '5s', 'throughput_bytes_slo' => '1073741824.0', 'metadata_slo' => { 'duration_slo' => '5s', 'throughput_bytes_slo' => '1073741824.0' } }, 'trace_by_id' => { 'duration_slo' => '5s' } },
  Hash $tempo_distributor = { 'receivers' => { 'otlp' => { 'protocols' => { 'grpc' => { 'endpoint' => '{{ tempo_http_listen_address }}:4317' } } } } },
  Hash $tempo_metrics_generator = { 'registry' => { 'external_labels' => { 'source' => 'tempo', 'cluster' => 'docker-compose' } }, 'storage' => { 'path' => '{{ tempo_working_path }}/generator/wal', 'remote_write' => [{ 'url' => 'http://prometheus:9090/api/v1/write', 'send_exemplars' => true }] }, 'traces_storage' => { 'path' => '{{ tempo_working_path }}/generator/traces' } },
  Hash $tempo_storage = { 'trace' => { 'backend' => 'local', 'wal' => { 'path' => '{{ tempo_working_path }}/wal' }, 'local' => { 'path' => '{{ tempo_working_path }}/blocks' } } },
  Hash $tempo_overrides = { 'defaults' => { 'metrics_generator' => { 'processors' => ['service-graphs', 'span-metrics', 'local-blocks'], 'generate_native_histograms' => 'both' } } },
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/grafana_grafana/roles/tempo/playbook.yml"

  par { 'paw_grafana_grafana_tempo-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'tempo_http_api_prefix'      => $tempo_http_api_prefix,
      'tempo_report_usage'         => $tempo_report_usage,
      'tempo_multitenancy_enabled' => $tempo_multitenancy_enabled,
      'tempo_version'              => $tempo_version,
      'tempo_uninstall'            => $tempo_uninstall,
      '__tempo_arch'               => $du__tempo_arch,
      'tempo_download_url_rpm'     => $tempo_download_url_rpm,
      'tempo_download_url_deb'     => $tempo_download_url_deb,
      'tempo_working_path'         => $tempo_working_path,
      'tempo_http_listen_port'     => $tempo_http_listen_port,
      'tempo_http_listen_address'  => $tempo_http_listen_address,
      'tempo_log_level'            => $tempo_log_level,
      'tempo_server'               => $tempo_server,
      'tempo_query_frontend'       => $tempo_query_frontend,
      'tempo_distributor'          => $tempo_distributor,
      'tempo_metrics_generator'    => $tempo_metrics_generator,
      'tempo_storage'              => $tempo_storage,
      'tempo_overrides'            => $tempo_overrides,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}
