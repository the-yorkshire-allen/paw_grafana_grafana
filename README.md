# paw_grafana_grafana

## Description

This Puppet module was Converted from Ansible collection: **grafana.grafana**

Ansible collection to manage Grafana resources

## Conversion Details

- **Converted on**: 2025-10-30
- **Original Collection**: grafana.grafana v6.0.6
- **Authors**: Grafana Labs <grafana.com>, Ishan Jain <ishan.jain@grafana.com>, Gerard van Engelen <g.vanengelen@codepeople.nl>
- **License**: ["GPL-3.0-or-later"]

## Roles Included

This collection includes the following roles:

- **grafana**: Use `include paw_grafana_grafana::grafana`
- **promtail**: Use `include paw_grafana_grafana::promtail`
- **alloy**: Use `include paw_grafana_grafana::alloy`
- **mimir**: Use `include paw_grafana_grafana::mimir`
- **opentelemetry_collector**: Use `include paw_grafana_grafana::opentelemetry_collector`
- **loki**: Use `include paw_grafana_grafana::loki`
- **tempo**: Use `include paw_grafana_grafana::tempo`
- **grafana_agent**: Use `include paw_grafana_grafana::grafana_agent`

## Usage

Include specific roles from the collection:

```puppet
include paw_grafana_grafana::grafana
include paw_grafana_grafana::promtail
```

Or use classes with parameters:

```puppet
class { 'paw_grafana_grafana::grafana':
  # Add your parameters here
}
```

## Parameters

See individual class files in `manifests/` for available parameters.

## Requirements

- Puppet 6.0 or higher
- puppet_agent_runonce module for task execution
- Ansible installed on target nodes for task execution

## License

["GPL-3.0-or-later"]
