#!/bin/bash
set -e

# Puppet task for executing Ansible role: grafana_grafana
# This script runs the entire role via ansible-playbook

# Determine the ansible modules directory
if [ -n "$PT__installdir" ]; then
  ANSIBLE_DIR="$PT__installdir/lib/puppet_x/ansible_modules/grafana_grafana"
else
  # Fallback to /opt/puppetlabs/puppet/cache/lib/puppet_x/ansible_modules
  ANSIBLE_DIR="/opt/puppetlabs/puppet/cache/lib/puppet_x/ansible_modules/grafana_grafana"
fi

# Check if ansible-playbook is available
if ! command -v ansible-playbook &> /dev/null; then
  echo '{"_error": {"msg": "ansible-playbook command not found. Please install Ansible.", "kind": "puppet-ansible-converter/ansible-not-found"}}'
  exit 1
fi

# Check if the role directory exists
if [ ! -d "$ANSIBLE_DIR" ]; then
  echo "{\"_error\": {\"msg\": \"Ansible role directory not found: $ANSIBLE_DIR\", \"kind\": \"puppet-ansible-converter/role-not-found\"}}"
  exit 1
fi

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
if [ -d "$ANSIBLE_DIR/roles" ] && [ -f "$ANSIBLE_DIR/roles/opentelemetry_collector/playbook.yml" ]; then
  # Collection structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/roles/opentelemetry_collector/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR/roles/opentelemetry_collector"
elif [ -f "$ANSIBLE_DIR/playbook.yml" ]; then
  # Standalone role structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR"
else
  echo "{\"_error\": {\"msg\": \"playbook.yml not found in $ANSIBLE_DIR or $ANSIBLE_DIR/roles/opentelemetry_collector\", \"kind\": \"puppet-ansible-converter/playbook-not-found\"}}"
  exit 1
fi

# Build extra-vars from PT_* environment variables (excluding par_* control params)
EXTRA_VARS="{"
FIRST=true
if [ -n "$PT_otel_collector_installation_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_installation_dir\": \"$PT_otel_collector_installation_dir\""
fi
if [ -n "$PT_otel_collector_executable" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_executable\": \"$PT_otel_collector_executable\""
fi
if [ -n "$PT_otel_collector_config_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_config_dir\": \"$PT_otel_collector_config_dir\""
fi
if [ -n "$PT_otel_collector_config_file" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_config_file\": \"$PT_otel_collector_config_file\""
fi
if [ -n "$PT_otel_collector_service_user" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_service_user\": \"$PT_otel_collector_service_user\""
fi
if [ -n "$PT_otel_collector_service_group" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_service_group\": \"$PT_otel_collector_service_group\""
fi
if [ -n "$PT_otel_collector_service_statedirectory" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_service_statedirectory\": \"$PT_otel_collector_service_statedirectory\""
fi
if [ -n "$PT_otel_collector_version" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_version\": \"$PT_otel_collector_version\""
fi
if [ -n "$PT_otel_collector_binary_url" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_binary_url\": \"$PT_otel_collector_binary_url\""
fi
if [ -n "$PT_otel_collector_latest_url" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_latest_url\": \"$PT_otel_collector_latest_url\""
fi
if [ -n "$PT_arch_mapping" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"arch_mapping\": \"$PT_arch_mapping\""
fi
if [ -n "$PT_otel_collector_arch" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_arch\": \"$PT_otel_collector_arch\""
fi
if [ -n "$PT_otel_collector_service_name" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_service_name\": \"$PT_otel_collector_service_name\""
fi
if [ -n "$PT_otel_collector_type" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_type\": \"$PT_otel_collector_type\""
fi
if [ -n "$PT_otel_collector_receivers" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_receivers\": \"$PT_otel_collector_receivers\""
fi
if [ -n "$PT_otel_collector_exporters" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_exporters\": \"$PT_otel_collector_exporters\""
fi
if [ -n "$PT_otel_collector_processors" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_processors\": \"$PT_otel_collector_processors\""
fi
if [ -n "$PT_otel_collector_extensions" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_extensions\": \"$PT_otel_collector_extensions\""
fi
if [ -n "$PT_otel_collector_service" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_service\": \"$PT_otel_collector_service\""
fi
if [ -n "$PT_otel_collector_connectors" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"otel_collector_connectors\": \"$PT_otel_collector_connectors\""
fi
EXTRA_VARS="$EXTRA_VARS}"

# Build ansible-playbook command with control parameters
ANSIBLE_CMD="ansible-playbook playbook.yml"
ANSIBLE_CMD="$ANSIBLE_CMD --extra-vars \"$EXTRA_VARS\""

# Add connection type (default: local)
CONNECTION="${PT_par_connection:-local}"
ANSIBLE_CMD="$ANSIBLE_CMD --connection=$CONNECTION"

# Add inventory
ANSIBLE_CMD="$ANSIBLE_CMD --inventory=localhost,"

# Add timeout if specified
if [ -n "$PT_par_timeout" ]; then
  ANSIBLE_CMD="$ANSIBLE_CMD --timeout=$PT_par_timeout"
fi

# Add extra flags if specified
if [ -n "$PT_par_extra_flags" ]; then
  # Parse JSON array of extra flags
  EXTRA_FLAGS=$(echo "$PT_par_extra_flags" | sed 's/\[//;s/\]//;s/"//g;s/,/ /g')
  ANSIBLE_CMD="$ANSIBLE_CMD $EXTRA_FLAGS"
fi

# Set working directory if specified
if [ -n "$PT_par_working_directory" ]; then
  cd "$PT_par_working_directory"
else
  cd "$PLAYBOOK_DIR"
fi

# Set environment variables if specified
if [ -n "$PT_par_environment" ]; then
  # Parse JSON hash and export variables
  eval $(echo "$PT_par_environment" | sed 's/[{}]//g;s/": "/=/g;s/","/;export /g;s/"//g' | sed 's/^/export /')
fi

# Execute ansible-playbook
eval $ANSIBLE_CMD 2>&1

EXIT_CODE=$?

# Return JSON result
if [ $EXIT_CODE -eq 0 ]; then
  echo '{"status": "success", "role": "grafana_grafana"}'
else
  echo "{\"status\": \"failed\", \"role\": \"grafana_grafana\", \"exit_code\": $EXIT_CODE}"
fi

exit $EXIT_CODE
