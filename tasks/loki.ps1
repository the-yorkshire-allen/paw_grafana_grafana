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
$CollectionPlaybook = Join-Path $AnsibleDir "roles\loki\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\loki"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\loki"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_loki_target) {
  $ExtraVars['loki_target'] = $env:PT_loki_target
}
if ($env:PT_loki_auth_enabled) {
  $ExtraVars['loki_auth_enabled'] = $env:PT_loki_auth_enabled
}
if ($env:PT_loki_ballast_bytes) {
  $ExtraVars['loki_ballast_bytes'] = $env:PT_loki_ballast_bytes
}
if ($env:PT_loki_version) {
  $ExtraVars['loki_version'] = $env:PT_loki_version
}
if ($env:PT_loki_uninstall) {
  $ExtraVars['loki_uninstall'] = $env:PT_loki_uninstall
}
if ($env:PT_loki_http_listen_port) {
  $ExtraVars['loki_http_listen_port'] = $env:PT_loki_http_listen_port
}
if ($env:PT_loki_http_listen_address) {
  $ExtraVars['loki_http_listen_address'] = $env:PT_loki_http_listen_address
}
if ($env:PT_loki_expose_port) {
  $ExtraVars['loki_expose_port'] = $env:PT_loki_expose_port
}
if ($env:PT_loki_download_url_rpm) {
  $ExtraVars['loki_download_url_rpm'] = $env:PT_loki_download_url_rpm
}
if ($env:PT_loki_download_url_deb) {
  $ExtraVars['loki_download_url_deb'] = $env:PT_loki_download_url_deb
}
if ($env:PT_loki_working_path) {
  $ExtraVars['loki_working_path'] = $env:PT_loki_working_path
}
if ($env:PT_loki_ruler_alert_path) {
  $ExtraVars['loki_ruler_alert_path'] = $env:PT_loki_ruler_alert_path
}
if ($env:PT_loki_server) {
  $ExtraVars['loki_server'] = $env:PT_loki_server
}
if ($env:PT_loki_common) {
  $ExtraVars['loki_common'] = $env:PT_loki_common
}
if ($env:PT_loki_query_range) {
  $ExtraVars['loki_query_range'] = $env:PT_loki_query_range
}
if ($env:PT_loki_schema_config) {
  $ExtraVars['loki_schema_config'] = $env:PT_loki_schema_config
}
if ($env:PT_loki_ruler) {
  $ExtraVars['loki_ruler'] = $env:PT_loki_ruler
}
if ($env:PT_loki_analytics) {
  $ExtraVars['loki_analytics'] = $env:PT_loki_analytics
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
