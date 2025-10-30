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
$CollectionPlaybook = Join-Path $AnsibleDir "roles\promtail\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\promtail"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\promtail"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_flag) {
  $ExtraVars['flag'] = $env:PT_flag
}
if ($env:PT_each_dir) {
  $ExtraVars['each_dir'] = $env:PT_each_dir
}
if ($env:PT_each_log) {
  $ExtraVars['each_log'] = $env:PT_each_log
}
if ($env:PT_promtail_version) {
  $ExtraVars['promtail_version'] = $env:PT_promtail_version
}
if ($env:PT_promtail_uninstall) {
  $ExtraVars['promtail_uninstall'] = $env:PT_promtail_uninstall
}
if ($env:PT_promtail_http_listen_port) {
  $ExtraVars['promtail_http_listen_port'] = $env:PT_promtail_http_listen_port
}
if ($env:PT_promtail_http_listen_address) {
  $ExtraVars['promtail_http_listen_address'] = $env:PT_promtail_http_listen_address
}
if ($env:PT_promtail_expose_port) {
  $ExtraVars['promtail_expose_port'] = $env:PT_promtail_expose_port
}
if ($env:PT_promtail_positions_path) {
  $ExtraVars['promtail_positions_path'] = $env:PT_promtail_positions_path
}
if ($env:PT_promtail_runtime_mode) {
  $ExtraVars['promtail_runtime_mode'] = $env:PT_promtail_runtime_mode
}
if ($env:PT_promtail_extra_flags) {
  $ExtraVars['promtail_extra_flags'] = $env:PT_promtail_extra_flags
}
if ($env:PT_promtail_user_append_groups) {
  $ExtraVars['promtail_user_append_groups'] = $env:PT_promtail_user_append_groups
}
if ($env:PT_promtail_download_url_rpm) {
  $ExtraVars['promtail_download_url_rpm'] = $env:PT_promtail_download_url_rpm
}
if ($env:PT_promtail_download_url_deb) {
  $ExtraVars['promtail_download_url_deb'] = $env:PT_promtail_download_url_deb
}
if ($env:PT_promtail_server) {
  $ExtraVars['promtail_server'] = $env:PT_promtail_server
}
if ($env:PT_promtail_positions) {
  $ExtraVars['promtail_positions'] = $env:PT_promtail_positions
}
if ($env:PT_promtail_clients) {
  $ExtraVars['promtail_clients'] = $env:PT_promtail_clients
}
if ($env:PT_promtail_scrape_configs) {
  $ExtraVars['promtail_scrape_configs'] = $env:PT_promtail_scrape_configs
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
