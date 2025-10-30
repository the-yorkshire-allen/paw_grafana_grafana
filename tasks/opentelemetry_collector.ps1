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
$CollectionPlaybook = Join-Path $AnsibleDir "roles\opentelemetry_collector\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\opentelemetry_collector"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\opentelemetry_collector"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_otel_collector_installation_dir) {
  $ExtraVars['otel_collector_installation_dir'] = $env:PT_otel_collector_installation_dir
}
if ($env:PT_otel_collector_executable) {
  $ExtraVars['otel_collector_executable'] = $env:PT_otel_collector_executable
}
if ($env:PT_otel_collector_config_dir) {
  $ExtraVars['otel_collector_config_dir'] = $env:PT_otel_collector_config_dir
}
if ($env:PT_otel_collector_config_file) {
  $ExtraVars['otel_collector_config_file'] = $env:PT_otel_collector_config_file
}
if ($env:PT_otel_collector_service_user) {
  $ExtraVars['otel_collector_service_user'] = $env:PT_otel_collector_service_user
}
if ($env:PT_otel_collector_service_group) {
  $ExtraVars['otel_collector_service_group'] = $env:PT_otel_collector_service_group
}
if ($env:PT_otel_collector_service_statedirectory) {
  $ExtraVars['otel_collector_service_statedirectory'] = $env:PT_otel_collector_service_statedirectory
}
if ($env:PT_otel_collector_version) {
  $ExtraVars['otel_collector_version'] = $env:PT_otel_collector_version
}
if ($env:PT_otel_collector_binary_url) {
  $ExtraVars['otel_collector_binary_url'] = $env:PT_otel_collector_binary_url
}
if ($env:PT_otel_collector_latest_url) {
  $ExtraVars['otel_collector_latest_url'] = $env:PT_otel_collector_latest_url
}
if ($env:PT_arch_mapping) {
  $ExtraVars['arch_mapping'] = $env:PT_arch_mapping
}
if ($env:PT_otel_collector_arch) {
  $ExtraVars['otel_collector_arch'] = $env:PT_otel_collector_arch
}
if ($env:PT_otel_collector_service_name) {
  $ExtraVars['otel_collector_service_name'] = $env:PT_otel_collector_service_name
}
if ($env:PT_otel_collector_type) {
  $ExtraVars['otel_collector_type'] = $env:PT_otel_collector_type
}
if ($env:PT_otel_collector_receivers) {
  $ExtraVars['otel_collector_receivers'] = $env:PT_otel_collector_receivers
}
if ($env:PT_otel_collector_exporters) {
  $ExtraVars['otel_collector_exporters'] = $env:PT_otel_collector_exporters
}
if ($env:PT_otel_collector_processors) {
  $ExtraVars['otel_collector_processors'] = $env:PT_otel_collector_processors
}
if ($env:PT_otel_collector_extensions) {
  $ExtraVars['otel_collector_extensions'] = $env:PT_otel_collector_extensions
}
if ($env:PT_otel_collector_service) {
  $ExtraVars['otel_collector_service'] = $env:PT_otel_collector_service
}
if ($env:PT_otel_collector_connectors) {
  $ExtraVars['otel_collector_connectors'] = $env:PT_otel_collector_connectors
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
