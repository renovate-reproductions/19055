local utils = import "mixin-utils/utils.libsonnet";
local loki = (import "loki-mixin/mixin.libsonnet") {
  grafanaDashboards+: {
    "loki-operational.json"+: {
      showMultiCluster: false,
      matchers:: {
        cortexgateway: [utils.selector.re("job", "(loki-loki-distributed)-cortex-gw")],
        distributor: [utils.selector.re("job", "(loki-loki-distributed)-distributor")],
        ingester: [utils.selector.re("job", "(loki-loki-distributed)-ingester")],
        querier: [utils.selector.re("job", "(loki-loki-distributed)-querier")],
      },
      local replacePodMatchers(expr) = std.strReplace(expr, 'pod=~"', 'pod=~"loki-loki-distributed-'),
      panels: [
        p {
          datasource: super.datasource,
          targets: if std.objectHas(p, 'targets') then [
            e {
              expr: replacePodMatchers(e.expr),
            }
            for e in p.targets
          ] else [],
          panels: if std.objectHas(p, 'panels') then [
            sp {
              datasource: super.datasource,
              targets: if std.objectHas(sp, 'targets') then [
                e {
                  expr: replacePodMatchers(e.expr),
                }
                for e in sp.targets
              ] else [],
              panels: if std.objectHas(sp, 'panels') then [
                ssp {
                  datasource: super.datasource,
                  targets: if std.objectHas(ssp, 'targets') then [
                    e {
                      expr: replacePodMatchers(e.expr),
                    }
                    for e in ssp.targets
                  ] else [],
                }
                for ssp in sp.panels
              ] else [],
            }
            for sp in p.panels
          ] else [],
        }
        for p in super.panels if !std.member(["Azure Blob", "Consul", "Big Table", "GCS", "Dynamo", "Cassandra"], p.title)
      ],
    }
  }
};

{
  ["dashboards/" + name]: loki.grafanaDashboards[name] for name in std.objectFields(loki.grafanaDashboards)
}
