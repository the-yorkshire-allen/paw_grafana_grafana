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
if [ -d "$ANSIBLE_DIR/roles" ] && [ -f "$ANSIBLE_DIR/roles/promtail/playbook.yml" ]; then
  # Collection structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/roles/promtail/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR/roles/promtail"
elif [ -f "$ANSIBLE_DIR/playbook.yml" ]; then
  # Standalone role structure
  PLAYBOOK_PATH="$ANSIBLE_DIR/playbook.yml"
  PLAYBOOK_DIR="$ANSIBLE_DIR"
else
  echo "{\"_error\": {\"msg\": \"playbook.yml not found in $ANSIBLE_DIR or $ANSIBLE_DIR/roles/promtail\", \"kind\": \"puppet-ansible-converter/playbook-not-found\"}}"
  exit 1
fi

# Build extra-vars from PT_* environment variables (excluding par_* control params)
EXTRA_VARS="{"
FIRST=true
if [ -n "$PT_flag" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"flag\": \"$PT_flag\""
fi
if [ -n "$PT_each_dir" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"each_dir\": \"$PT_each_dir\""
fi
if [ -n "$PT_each_log" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"each_log\": \"$PT_each_log\""
fi
if [ -n "$PT_promtail_version" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_version\": \"$PT_promtail_version\""
fi
if [ -n "$PT_promtail_uninstall" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_uninstall\": \"$PT_promtail_uninstall\""
fi
if [ -n "$PT_promtail_http_listen_port" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_http_listen_port\": \"$PT_promtail_http_listen_port\""
fi
if [ -n "$PT_promtail_http_listen_address" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_http_listen_address\": \"$PT_promtail_http_listen_address\""
fi
if [ -n "$PT_promtail_expose_port" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_expose_port\": \"$PT_promtail_expose_port\""
fi
if [ -n "$PT_promtail_positions_path" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_positions_path\": \"$PT_promtail_positions_path\""
fi
if [ -n "$PT_promtail_runtime_mode" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_runtime_mode\": \"$PT_promtail_runtime_mode\""
fi
if [ -n "$PT_promtail_extra_flags" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_extra_flags\": \"$PT_promtail_extra_flags\""
fi
if [ -n "$PT_promtail_user_append_groups" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_user_append_groups\": \"$PT_promtail_user_append_groups\""
fi
if [ -n "$PT_promtail_download_url_rpm" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_download_url_rpm\": \"$PT_promtail_download_url_rpm\""
fi
if [ -n "$PT_promtail_download_url_deb" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_download_url_deb\": \"$PT_promtail_download_url_deb\""
fi
if [ -n "$PT_promtail_server" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_server\": \"$PT_promtail_server\""
fi
if [ -n "$PT_promtail_positions" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_positions\": \"$PT_promtail_positions\""
fi
if [ -n "$PT_promtail_clients" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_clients\": \"$PT_promtail_clients\""
fi
if [ -n "$PT_promtail_scrape_configs" ]; then
  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    EXTRA_VARS="$EXTRA_VARS,"
  fi
  EXTRA_VARS="$EXTRA_VARS\"promtail_scrape_configs\": \"$PT_promtail_scrape_configs\""
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
