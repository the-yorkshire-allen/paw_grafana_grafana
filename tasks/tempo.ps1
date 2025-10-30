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
$CollectionPlaybook = Join-Path $AnsibleDir "roles\tempo\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\tempo"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\tempo"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_tempo_http_api_prefix) {
  $ExtraVars['tempo_http_api_prefix'] = $env:PT_tempo_http_api_prefix
}
if ($env:PT_tempo_report_usage) {
  $ExtraVars['tempo_report_usage'] = $env:PT_tempo_report_usage
}
if ($env:PT_tempo_multitenancy_enabled) {
  $ExtraVars['tempo_multitenancy_enabled'] = $env:PT_tempo_multitenancy_enabled
}
if ($env:PT_tempo_version) {
  $ExtraVars['tempo_version'] = $env:PT_tempo_version
}
if ($env:PT_tempo_uninstall) {
  $ExtraVars['tempo_uninstall'] = $env:PT_tempo_uninstall
}
if ($env:PT_du__tempo_arch) {
  $ExtraVars['__tempo_arch'] = $env:PT_du__tempo_arch
}
if ($env:PT_tempo_download_url_rpm) {
  $ExtraVars['tempo_download_url_rpm'] = $env:PT_tempo_download_url_rpm
}
if ($env:PT_tempo_download_url_deb) {
  $ExtraVars['tempo_download_url_deb'] = $env:PT_tempo_download_url_deb
}
if ($env:PT_tempo_working_path) {
  $ExtraVars['tempo_working_path'] = $env:PT_tempo_working_path
}
if ($env:PT_tempo_http_listen_port) {
  $ExtraVars['tempo_http_listen_port'] = $env:PT_tempo_http_listen_port
}
if ($env:PT_tempo_http_listen_address) {
  $ExtraVars['tempo_http_listen_address'] = $env:PT_tempo_http_listen_address
}
if ($env:PT_tempo_log_level) {
  $ExtraVars['tempo_log_level'] = $env:PT_tempo_log_level
}
if ($env:PT_tempo_server) {
  $ExtraVars['tempo_server'] = $env:PT_tempo_server
}
if ($env:PT_tempo_query_frontend) {
  $ExtraVars['tempo_query_frontend'] = $env:PT_tempo_query_frontend
}
if ($env:PT_tempo_distributor) {
  $ExtraVars['tempo_distributor'] = $env:PT_tempo_distributor
}
if ($env:PT_tempo_metrics_generator) {
  $ExtraVars['tempo_metrics_generator'] = $env:PT_tempo_metrics_generator
}
if ($env:PT_tempo_storage) {
  $ExtraVars['tempo_storage'] = $env:PT_tempo_storage
}
if ($env:PT_tempo_overrides) {
  $ExtraVars['tempo_overrides'] = $env:PT_tempo_overrides
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
