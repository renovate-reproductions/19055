local utils = import "mixin-utils/utils.libsonnet";
local tempo = (import "tempo-mixin/mixin.libsonnet") {
  _config+: {
    namespace: "tempo",
  },
  jobMatcher(job)::
    'cluster=~"$cluster", job=~"tempo-tempo-distributed-%s"' % job,
  grafanaDashboards+: {
    "tempo-operational.json"+: {
      local replaceJobMatchers(expr) = std.strReplace(std.strReplace(expr, 'job=~"$namespace/', 'job=~"tempo-tempo-distributed-'), 'job="$namespace/', 'job="tempo-tempo-distributed-'),
      panels: [
        p {
          datasource: super.datasource,
          targets: if std.objectHas(p, 'targets') then [
            e {
              expr: replaceJobMatchers(e.expr),
            }
            for e in p.targets
          ] else [],
          panels: if std.objectHas(p, 'panels') then [
            sp {
              datasource: super.datasource,
              targets: if std.objectHas(sp, 'targets') then [
                e {
                  expr: replaceJobMatchers(e.expr),
                }
                for e in sp.targets
              ] else [],
              panels: if std.objectHas(sp, 'panels') then [
                ssp {
                  datasource: super.datasource,
                  targets: if std.objectHas(ssp, 'targets') then [
                    e {
                      expr: replaceJobMatchers(e.expr),
                    }
                    for e in ssp.targets
                  ] else [],
                }
                for ssp in sp.panels
              ] else [],
            }
            for sp in p.panels if !std.member(["bad words", "Pushes/sec (gateway)", "Push Latency (Gateway)"], sp.title)
          ] else [],
        }
        for p in super.panels if !std.member(["Queries/Sec (cortex-gw)", "Query Latency (Gateway)", "Search Queries/Sec (cortex-gw)", "Search Query Latency (Gateway)"], p.title)
      ],
      templating+: {
        list: [
          if item.name == "ds" then item + {current+: {text: "fsn1-root-staging", value: "fsn1-root-staging", selected: true}} else item
            for item in super.list
        ],
      },
    },
    "tempo-reads.json"+: {
      rows: [row for row in super.rows if !std.member(["Gateway"], row.title)]
    },
    "tempo-resources.json"+: {
      rows: [row for row in super.rows if !std.member(["Gateway"], row.title)]
    },
    "tempo-writes.json"+: {
      rows: [row for row in super.rows if !std.member(["Gateway", "Envoy Proxy"], row.title)]
    },
  }
};
{
  [name]: tempo.grafanaDashboards[name] for name in std.objectFields(tempo.grafanaDashboards)
}
