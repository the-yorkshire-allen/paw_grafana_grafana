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
$CollectionPlaybook = Join-Path $AnsibleDir "roles\grafana\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\grafana"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\grafana"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_k) {
  $ExtraVars['k'] = $env:PT_k
}
if ($env:PT_v) {
  $ExtraVars['v'] = $env:PT_v
}
if ($env:PT_section) {
  $ExtraVars['section'] = $env:PT_section
}
if ($env:PT_sub_key) {
  $ExtraVars['sub_key'] = $env:PT_sub_key
}
if ($env:PT_sub_value) {
  $ExtraVars['sub_value'] = $env:PT_sub_value
}
if ($env:PT_grafana_version) {
  $ExtraVars['grafana_version'] = $env:PT_grafana_version
}
if ($env:PT_grafana_manage_repo) {
  $ExtraVars['grafana_manage_repo'] = $env:PT_grafana_manage_repo
}
if ($env:PT_grafana_yum_repo) {
  $ExtraVars['grafana_yum_repo'] = $env:PT_grafana_yum_repo
}
if ($env:PT_grafana_yum_key) {
  $ExtraVars['grafana_yum_key'] = $env:PT_grafana_yum_key
}
if ($env:PT_grafana_rhsm_subscription) {
  $ExtraVars['grafana_rhsm_subscription'] = $env:PT_grafana_rhsm_subscription
}
if ($env:PT_grafana_rhsm_repo) {
  $ExtraVars['grafana_rhsm_repo'] = $env:PT_grafana_rhsm_repo
}
if ($env:PT_grafana_apt_release_channel) {
  $ExtraVars['grafana_apt_release_channel'] = $env:PT_grafana_apt_release_channel
}
if ($env:PT_grafana_apt_arch) {
  $ExtraVars['grafana_apt_arch'] = $env:PT_grafana_apt_arch
}
if ($env:PT_grafana_apt_repo_uri) {
  $ExtraVars['grafana_apt_repo_uri'] = $env:PT_grafana_apt_repo_uri
}
if ($env:PT_grafana_apt_repo) {
  $ExtraVars['grafana_apt_repo'] = $env:PT_grafana_apt_repo
}
if ($env:PT_grafana_apt_key) {
  $ExtraVars['grafana_apt_key'] = $env:PT_grafana_apt_key
}
if ($env:PT_grafana_apt_name) {
  $ExtraVars['grafana_apt_name'] = $env:PT_grafana_apt_name
}
if ($env:PT_grafana_use_provisioning) {
  $ExtraVars['grafana_use_provisioning'] = $env:PT_grafana_use_provisioning
}
if ($env:PT_grafana_provisioning_synced) {
  $ExtraVars['grafana_provisioning_synced'] = $env:PT_grafana_provisioning_synced
}
if ($env:PT_grafana_provisioning_dashboards_from_file_structure) {
  $ExtraVars['grafana_provisioning_dashboards_from_file_structure'] = $env:PT_grafana_provisioning_dashboards_from_file_structure
}
if ($env:PT_grafana_cap_net_bind_service) {
  $ExtraVars['grafana_cap_net_bind_service'] = $env:PT_grafana_cap_net_bind_service
}
if ($env:PT_grafana_ini_default) {
  $ExtraVars['grafana_ini_default'] = $env:PT_grafana_ini_default
}
if ($env:PT_grafana_api_url) {
  $ExtraVars['grafana_api_url'] = $env:PT_grafana_api_url
}
if ($env:PT_grafana_ldap) {
  $ExtraVars['grafana_ldap'] = $env:PT_grafana_ldap
}
if ($env:PT_grafana_plugins) {
  $ExtraVars['grafana_plugins'] = $env:PT_grafana_plugins
}
if ($env:PT_grafana_dashboards) {
  $ExtraVars['grafana_dashboards'] = $env:PT_grafana_dashboards
}
if ($env:PT_grafana_dashboards_dir) {
  $ExtraVars['grafana_dashboards_dir'] = $env:PT_grafana_dashboards_dir
}
if ($env:PT_grafana_alert_notifications) {
  $ExtraVars['grafana_alert_notifications'] = $env:PT_grafana_alert_notifications
}
if ($env:PT_grafana_alert_resources) {
  $ExtraVars['grafana_alert_resources'] = $env:PT_grafana_alert_resources
}
if ($env:PT_grafana_datasources) {
  $ExtraVars['grafana_datasources'] = $env:PT_grafana_datasources
}
if ($env:PT_grafana_api_keys) {
  $ExtraVars['grafana_api_keys'] = $env:PT_grafana_api_keys
}
if ($env:PT_grafana_api_keys_dir) {
  $ExtraVars['grafana_api_keys_dir'] = $env:PT_grafana_api_keys_dir
}
if ($env:PT_grafana_environment) {
  $ExtraVars['grafana_environment'] = $env:PT_grafana_environment
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
