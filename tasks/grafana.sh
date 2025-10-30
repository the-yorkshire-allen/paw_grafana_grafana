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
if [ -d "$ANSIBLE_DIR/roles" ] && [ -f "$ANSIBLE_DIR/roles/grafana/playbook.yml" ]; then
  # Collection structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/roles/grafana/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR/roles/grafana"
elif [ -f "$ANSIBLE_DIR/playbook.yml" ]; then
  # Standalone role structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR"
else
  echo "{\"_error\": {\"msg\": \"playbook.yml not found in $ANSIBLE_DIR or $ANSIBLE_DIR/roles/grafana\", \"kind\": \"puppet-ansible-converter/playbook-not-found\"}}"
  exit 1
fi

# Build extra-vars from PT_* environment variables (excluding par_* control params)
EXTRA_VARS="{"
FIRST=true
if [ -n "$PT_k" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"k\": \"$PT_k\""
fi
if [ -n "$PT_v" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"v\": \"$PT_v\""
fi
if [ -n "$PT_section" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"section\": \"$PT_section\""
fi
if [ -n "$PT_sub_key" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"sub_key\": \"$PT_sub_key\""
fi
if [ -n "$PT_sub_value" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"sub_value\": \"$PT_sub_value\""
fi
if [ -n "$PT_grafana_version" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_version\": \"$PT_grafana_version\""
fi
if [ -n "$PT_grafana_manage_repo" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_manage_repo\": \"$PT_grafana_manage_repo\""
fi
if [ -n "$PT_grafana_yum_repo" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_yum_repo\": \"$PT_grafana_yum_repo\""
fi
if [ -n "$PT_grafana_yum_key" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_yum_key\": \"$PT_grafana_yum_key\""
fi
if [ -n "$PT_grafana_rhsm_subscription" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_rhsm_subscription\": \"$PT_grafana_rhsm_subscription\""
fi
if [ -n "$PT_grafana_rhsm_repo" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_rhsm_repo\": \"$PT_grafana_rhsm_repo\""
fi
if [ -n "$PT_grafana_apt_release_channel" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_apt_release_channel\": \"$PT_grafana_apt_release_channel\""
fi
if [ -n "$PT_grafana_apt_arch" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_apt_arch\": \"$PT_grafana_apt_arch\""
fi
if [ -n "$PT_grafana_apt_repo_uri" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_apt_repo_uri\": \"$PT_grafana_apt_repo_uri\""
fi
if [ -n "$PT_grafana_apt_repo" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_apt_repo\": \"$PT_grafana_apt_repo\""
fi
if [ -n "$PT_grafana_apt_key" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_apt_key\": \"$PT_grafana_apt_key\""
fi
if [ -n "$PT_grafana_apt_name" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_apt_name\": \"$PT_grafana_apt_name\""
fi
if [ -n "$PT_grafana_use_provisioning" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_use_provisioning\": \"$PT_grafana_use_provisioning\""
fi
if [ -n "$PT_grafana_provisioning_synced" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_provisioning_synced\": \"$PT_grafana_provisioning_synced\""
fi
if [ -n "$PT_grafana_provisioning_dashboards_from_file_structure" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_provisioning_dashboards_from_file_structure\": \"$PT_grafana_provisioning_dashboards_from_file_structure\""
fi
if [ -n "$PT_grafana_cap_net_bind_service" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_cap_net_bind_service\": \"$PT_grafana_cap_net_bind_service\""
fi
if [ -n "$PT_grafana_ini_default" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_ini_default\": \"$PT_grafana_ini_default\""
fi
if [ -n "$PT_grafana_api_url" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_api_url\": \"$PT_grafana_api_url\""
fi
if [ -n "$PT_grafana_ldap" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_ldap\": \"$PT_grafana_ldap\""
fi
if [ -n "$PT_grafana_plugins" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_plugins\": \"$PT_grafana_plugins\""
fi
if [ -n "$PT_grafana_dashboards" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_dashboards\": \"$PT_grafana_dashboards\""
fi
if [ -n "$PT_grafana_dashboards_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_dashboards_dir\": \"$PT_grafana_dashboards_dir\""
fi
if [ -n "$PT_grafana_alert_notifications" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_alert_notifications\": \"$PT_grafana_alert_notifications\""
fi
if [ -n "$PT_grafana_alert_resources" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_alert_resources\": \"$PT_grafana_alert_resources\""
fi
if [ -n "$PT_grafana_datasources" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_datasources\": \"$PT_grafana_datasources\""
fi
if [ -n "$PT_grafana_api_keys" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_api_keys\": \"$PT_grafana_api_keys\""
fi
if [ -n "$PT_grafana_api_keys_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_api_keys_dir\": \"$PT_grafana_api_keys_dir\""
fi
if [ -n "$PT_grafana_environment" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"grafana_environment\": \"$PT_grafana_environment\""
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
