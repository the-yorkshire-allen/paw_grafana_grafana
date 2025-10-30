# Puppet task for executing Ansible role: grafana_grafana
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\grafana_grafana"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\grafana_grafana"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\grafana_agent\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\grafana_agent"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\grafana_agent"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_grafana_agent_mode) {
  $ExtraVars['grafana_agent_mode'] = $env:PT_grafana_agent_mode
}
if ($env:PT_key) {
  $ExtraVars['key'] = $env:PT_key
}
if ($env:PT_value) {
  $ExtraVars['value'] = $env:PT_value
}
if ($env:PT_grafana_agent_user) {
  $ExtraVars['grafana_agent_user'] = $env:PT_grafana_agent_user
}
if ($env:PT_grafana_agent_user_group) {
  $ExtraVars['grafana_agent_user_group'] = $env:PT_grafana_agent_user_group
}
if ($env:PT_grafana_agent_data_dir) {
  $ExtraVars['grafana_agent_data_dir'] = $env:PT_grafana_agent_data_dir
}
if ($env:PT_grafana_agent_config_dir) {
  $ExtraVars['grafana_agent_config_dir'] = $env:PT_grafana_agent_config_dir
}
if ($env:PT_grafana_agent_env_file) {
  $ExtraVars['grafana_agent_env_file'] = $env:PT_grafana_agent_env_file
}
if ($env:PT_grafana_agent_install_dir) {
  $ExtraVars['grafana_agent_install_dir'] = $env:PT_grafana_agent_install_dir
}
if ($env:PT_grafana_agent_binary) {
  $ExtraVars['grafana_agent_binary'] = $env:PT_grafana_agent_binary
}
if ($env:PT_flag) {
  $ExtraVars['flag'] = $env:PT_flag
}
if ($env:PT_flag_value) {
  $ExtraVars['flag_value'] = $env:PT_flag_value
}
if ($env:PT_flag_value_item) {
  $ExtraVars['flag_value_item'] = $env:PT_flag_value_item
}
if ($env:PT_grafana_agent_config_filename) {
  $ExtraVars['grafana_agent_config_filename'] = $env:PT_grafana_agent_config_filename
}
if ($env:PT_grafana_agent_positions_dir) {
  $ExtraVars['grafana_agent_positions_dir'] = $env:PT_grafana_agent_positions_dir
}
if ($env:PT_grafana_agent_wal_dir) {
  $ExtraVars['grafana_agent_wal_dir'] = $env:PT_grafana_agent_wal_dir
}
if ($env:PT_grafana_agent_version) {
  $ExtraVars['grafana_agent_version'] = $env:PT_grafana_agent_version
}
if ($env:PT_grafana_agent_base_download_url) {
  $ExtraVars['grafana_agent_base_download_url'] = $env:PT_grafana_agent_base_download_url
}
if ($env:PT_grafana_agent_service_extra) {
  $ExtraVars['grafana_agent_service_extra'] = $env:PT_grafana_agent_service_extra
}
if ($env:PT_grafana_agent_local_tmp_dir) {
  $ExtraVars['grafana_agent_local_tmp_dir'] = $env:PT_grafana_agent_local_tmp_dir
}
if ($env:PT_grafana_agent_user_groups) {
  $ExtraVars['grafana_agent_user_groups'] = $env:PT_grafana_agent_user_groups
}
if ($env:PT_grafana_agent_user_shell) {
  $ExtraVars['grafana_agent_user_shell'] = $env:PT_grafana_agent_user_shell
}
if ($env:PT_grafana_agent_user_createhome) {
  $ExtraVars['grafana_agent_user_createhome'] = $env:PT_grafana_agent_user_createhome
}
if ($env:PT_grafana_agent_local_binary_file) {
  $ExtraVars['grafana_agent_local_binary_file'] = $env:PT_grafana_agent_local_binary_file
}
if ($env:PT_grafana_agent_flags_extra) {
  $ExtraVars['grafana_agent_flags_extra'] = $env:PT_grafana_agent_flags_extra
}
if ($env:PT_grafana_agent_env_vars) {
  $ExtraVars['grafana_agent_env_vars'] = $env:PT_grafana_agent_env_vars
}
if ($env:PT_grafana_agent_env_file_vars) {
  $ExtraVars['grafana_agent_env_file_vars'] = $env:PT_grafana_agent_env_file_vars
}
if ($env:PT_grafana_agent_provisioned_config_file) {
  $ExtraVars['grafana_agent_provisioned_config_file'] = $env:PT_grafana_agent_provisioned_config_file
}
if ($env:PT_grafana_agent_server_config) {
  $ExtraVars['grafana_agent_server_config'] = $env:PT_grafana_agent_server_config
}
if ($env:PT_grafana_agent_metrics_config) {
  $ExtraVars['grafana_agent_metrics_config'] = $env:PT_grafana_agent_metrics_config
}
if ($env:PT_grafana_agent_logs_config) {
  $ExtraVars['grafana_agent_logs_config'] = $env:PT_grafana_agent_logs_config
}
if ($env:PT_grafana_agent_traces_config) {
  $ExtraVars['grafana_agent_traces_config'] = $env:PT_grafana_agent_traces_config
}
if ($env:PT_grafana_agent_integrations_config) {
  $ExtraVars['grafana_agent_integrations_config'] = $env:PT_grafana_agent_integrations_config
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "grafana_grafana"
    }
  } else {
    $result = @{
      status = "failed"
      role = "grafana_grafana"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
