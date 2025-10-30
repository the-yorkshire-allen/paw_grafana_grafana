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
if [ -d "$ANSIBLE_DIR/roles" ] && [ -f "$ANSIBLE_DIR/roles/grafana_agent/playbook.yml" ]; then
  # Collection structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/roles/grafana_agent/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR/roles/grafana_agent"
elif [ -f "$ANSIBLE_DIR/playbook.yml" ]; then
  # Standalone role structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR"
else
  echo "{\"_error\": {\"msg\": \"playbook.yml not found in $ANSIBLE_DIR or $ANSIBLE_DIR/roles/grafana_agent\", \"kind\": \"puppet-ansible-converter/playbook-not-found\"}}"
  exit 1
fi

# Build extra-vars from PT_* environment variables (excluding par_* control params)
EXTRA_VARS="{"
FIRST=true
if [ -n "$PT_grafana_agent_mode" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_mode\": \"$PT_grafana_agent_mode\""
fi
if [ -n "$PT_key" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"key\": \"$PT_key\""
fi
if [ -n "$PT_value" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"value\": \"$PT_value\""
fi
if [ -n "$PT_grafana_agent_user" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_user\": \"$PT_grafana_agent_user\""
fi
if [ -n "$PT_grafana_agent_user_group" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_user_group\": \"$PT_grafana_agent_user_group\""
fi
if [ -n "$PT_grafana_agent_data_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_data_dir\": \"$PT_grafana_agent_data_dir\""
fi
if [ -n "$PT_grafana_agent_config_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_config_dir\": \"$PT_grafana_agent_config_dir\""
fi
if [ -n "$PT_grafana_agent_env_file" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_env_file\": \"$PT_grafana_agent_env_file\""
fi
if [ -n "$PT_grafana_agent_install_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_install_dir\": \"$PT_grafana_agent_install_dir\""
fi
if [ -n "$PT_grafana_agent_binary" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_binary\": \"$PT_grafana_agent_binary\""
fi
if [ -n "$PT_flag" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"flag\": \"$PT_flag\""
fi
if [ -n "$PT_flag_value" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"flag_value\": \"$PT_flag_value\""
fi
if [ -n "$PT_flag_value_item" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"flag_value_item\": \"$PT_flag_value_item\""
fi
if [ -n "$PT_grafana_agent_config_filename" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_config_filename\": \"$PT_grafana_agent_config_filename\""
fi
if [ -n "$PT_grafana_agent_positions_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_positions_dir\": \"$PT_grafana_agent_positions_dir\""
fi
if [ -n "$PT_grafana_agent_wal_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_wal_dir\": \"$PT_grafana_agent_wal_dir\""
fi
if [ -n "$PT_grafana_agent_version" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_version\": \"$PT_grafana_agent_version\""
fi
if [ -n "$PT_grafana_agent_base_download_url" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_base_download_url\": \"$PT_grafana_agent_base_download_url\""
fi
if [ -n "$PT_grafana_agent_service_extra" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_service_extra\": \"$PT_grafana_agent_service_extra\""
fi
if [ -n "$PT_grafana_agent_local_tmp_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_local_tmp_dir\": \"$PT_grafana_agent_local_tmp_dir\""
fi
if [ -n "$PT_grafana_agent_user_groups" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_user_groups\": \"$PT_grafana_agent_user_groups\""
fi
if [ -n "$PT_grafana_agent_user_shell" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_user_shell\": \"$PT_grafana_agent_user_shell\""
fi
if [ -n "$PT_grafana_agent_user_createhome" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_user_createhome\": \"$PT_grafana_agent_user_createhome\""
fi
if [ -n "$PT_grafana_agent_local_binary_file" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_local_binary_file\": \"$PT_grafana_agent_local_binary_file\""
fi
if [ -n "$PT_grafana_agent_flags_extra" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_flags_extra\": \"$PT_grafana_agent_flags_extra\""
fi
if [ -n "$PT_grafana_agent_env_vars" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_env_vars\": \"$PT_grafana_agent_env_vars\""
fi
if [ -n "$PT_grafana_agent_env_file_vars" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_env_file_vars\": \"$PT_grafana_agent_env_file_vars\""
fi
if [ -n "$PT_grafana_agent_provisioned_config_file" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_provisioned_config_file\": \"$PT_grafana_agent_provisioned_config_file\""
fi
if [ -n "$PT_grafana_agent_server_config" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_server_config\": \"$PT_grafana_agent_server_config\""
fi
if [ -n "$PT_grafana_agent_metrics_config" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_metrics_config\": \"$PT_grafana_agent_metrics_config\""
fi
if [ -n "$PT_grafana_agent_logs_config" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_logs_config\": \"$PT_grafana_agent_logs_config\""
fi
if [ -n "$PT_grafana_agent_traces_config" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_traces_config\": \"$PT_grafana_agent_traces_config\""
fi
if [ -n "$PT_grafana_agent_integrations_config" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_agent_integrations_config\": \"$PT_grafana_agent_integrations_config\""
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
