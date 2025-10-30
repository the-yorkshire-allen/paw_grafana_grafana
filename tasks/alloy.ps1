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
$CollectionPlaybook = Join-Path $AnsibleDir "roles\alloy\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\alloy"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\alloy"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_key) {
  $ExtraVars['key'] = $env:PT_key
}
if ($env:PT_value) {
  $ExtraVars['value'] = $env:PT_value
}
if ($env:PT_alloy_config) {
  $ExtraVars['alloy_config'] = $env:PT_alloy_config
}
if ($env:PT_alloy_systemd_override) {
  $ExtraVars['alloy_systemd_override'] = $env:PT_alloy_systemd_override
}
if ($env:PT_alloy_version) {
  $ExtraVars['alloy_version'] = $env:PT_alloy_version
}
if ($env:PT_alloy_uninstall) {
  $ExtraVars['alloy_uninstall'] = $env:PT_alloy_uninstall
}
if ($env:PT_alloy_expose_port) {
  $ExtraVars['alloy_expose_port'] = $env:PT_alloy_expose_port
}
if ($env:PT_alloy_github_api_url) {
  $ExtraVars['alloy_github_api_url'] = $env:PT_alloy_github_api_url
}
if ($env:PT_alloy_download_url_rpm) {
  $ExtraVars['alloy_download_url_rpm'] = $env:PT_alloy_download_url_rpm
}
if ($env:PT_alloy_download_url_deb) {
  $ExtraVars['alloy_download_url_deb'] = $env:PT_alloy_download_url_deb
}
if ($env:PT_alloy_readiness_check_use_https) {
  $ExtraVars['alloy_readiness_check_use_https'] = $env:PT_alloy_readiness_check_use_https
}
if ($env:PT_alloy_readiness_check_use_proxy) {
  $ExtraVars['alloy_readiness_check_use_proxy'] = $env:PT_alloy_readiness_check_use_proxy
}
if ($env:PT_alloy_user_groups) {
  $ExtraVars['alloy_user_groups'] = $env:PT_alloy_user_groups
}
if ($env:PT_alloy_env_file_vars) {
  $ExtraVars['alloy_env_file_vars'] = $env:PT_alloy_env_file_vars
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
