# paw_grafana_grafana::opentelemetry_collector
# @summary Manage paw_grafana_grafana configuration
#
# @param otel_collector_installation_dir
# @param otel_collector_executable
# @param otel_collector_config_dir
# @param otel_collector_config_file
# @param otel_collector_service_user
# @param otel_collector_service_group
# @param otel_collector_service_statedirectory
# @param otel_collector_version
# @param otel_collector_binary_url
# @param otel_collector_latest_url
# @param arch_mapping
# @param otel_collector_arch
# @param otel_collector_service_name
# @param otel_collector_type
# @param otel_collector_receivers
# @param otel_collector_exporters
# @param otel_collector_processors
# @param otel_collector_extensions
# @param otel_collector_service
# @param otel_collector_connectors
# @param par_connection Ansible connection type (e.g., 'local', 'ssh')
# @param par_timeout Ansible playbook execution timeout in seconds
# @param par_environment Additional environment variables for ansible-playbook
# @param par_working_directory Working directory for ansible-playbook execution
# @param par_extra_flags Additional flags to pass to ansible-playbook
class paw_grafana_grafana::opentelemetry_collector (
  String $otel_collector_installation_dir = '/etc/otel-collector',
  String $otel_collector_executable = '{% if otel_collector_type == \'contrib\' %}otelcol-contrib{% else %}otelcol{% endif %}',
  String $otel_collector_config_dir = '/etc/otel-collector',
  String $otel_collector_config_file = 'config.yaml',
  String $otel_collector_service_user = 'otel',
  String $otel_collector_service_group = 'otel',
  String $otel_collector_service_statedirectory = 'otel-collector',
  String $otel_collector_version = '0.90.1',
  String $otel_collector_binary_url = 'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v{{ otel_collector_version }}/{% if otel_collector_type == \'contrib\' %}otelcol-contrib_{{ otel_collector_version }}_linux_{{ otel_collector_arch }}{% else %}otelcol_{{ otel_collector_version }}_linux_{{ otel_collector_arch }}{% endif %}.tar.gz',
  String $otel_collector_latest_url = 'https://api.github.com/repos/open-telemetry/opentelemetry-collector-releases/releases/latest',
  Hash $arch_mapping = { 'x86_64' => 'amd64', 'aarch64' => 'arm64', 'armv7l' => 'armhf', 'i386' => 'i386', 'ppc64le' => 'ppc64le' },
  String $otel_collector_arch = '{{ arch_mapping[ansible_facts[\'architecture\']] | default(\'amd64\') }}',
  String $otel_collector_service_name = 'otel-collector',
  String $otel_collector_type = 'contrib',
  Optional[String] $otel_collector_receivers = undef,
  Optional[String] $otel_collector_exporters = undef,
  Optional[String] $otel_collector_processors = undef,
  Optional[String] $otel_collector_extensions = undef,
  Optional[String] $otel_collector_service = undef,
  Optional[String] $otel_collector_connectors = undef,
  Optional[String] $par_connection = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[Hash] $par_environment = undef,
  Optional[String] $par_working_directory = undef,
  Optional[Array[String]] $par_extra_flags = undef
) {
  # Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = pick($facts['puppet_vardir'], $settings::vardir, '/opt/puppetlabs/puppet/cache')
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/grafana_grafana/roles/opentelemetry_collector/playbook.yml"

  par { 'paw_grafana_grafana_opentelemetry_collector-main':
    ensure            => present,
    playbook          => $playbook_path,
    playbook_vars     => {
      'otel_collector_installation_dir'       => $otel_collector_installation_dir,
      'otel_collector_executable'             => $otel_collector_executable,
      'otel_collector_config_dir'             => $otel_collector_config_dir,
      'otel_collector_config_file'            => $otel_collector_config_file,
      'otel_collector_service_user'           => $otel_collector_service_user,
      'otel_collector_service_group'          => $otel_collector_service_group,
      'otel_collector_service_statedirectory' => $otel_collector_service_statedirectory,
      'otel_collector_version'                => $otel_collector_version,
      'otel_collector_binary_url'             => $otel_collector_binary_url,
      'otel_collector_latest_url'             => $otel_collector_latest_url,
      'arch_mapping'                          => $arch_mapping,
      'otel_collector_arch'                   => $otel_collector_arch,
      'otel_collector_service_name'           => $otel_collector_service_name,
      'otel_collector_type'                   => $otel_collector_type,
      'otel_collector_receivers'              => $otel_collector_receivers,
      'otel_collector_exporters'              => $otel_collector_exporters,
      'otel_collector_processors'             => $otel_collector_processors,
      'otel_collector_extensions'             => $otel_collector_extensions,
      'otel_collector_service'                => $otel_collector_service,
      'otel_collector_connectors'             => $otel_collector_connectors,
    },
    connection        => $par_connection,
    timeout           => $par_timeout,
    environment       => $par_environment,
    working_directory => $par_working_directory,
    extra_flags       => $par_extra_flags,
  }
}
