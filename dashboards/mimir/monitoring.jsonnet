local mimir = (import 'mimir-mixin/mixin.libsonnet') {
  _config+: {
    instance_names: {
      compactor: 'mimir-mimir-distributed-compactor.*',
      alertmanager: 'mimir-mimir-distributed-alertmanager.*',
      ingester: 'mimir-mimir-distributed-ingester.*',
      distributor: 'mimir-mimir-distributed-distributor.*',
      querier: 'mimir-mimir-distributed-querier.*',
      ruler: 'mimir-mimir-distributed-ruler.*',
      query_frontend: 'mimir-mimir-distributed-query-frontend.*',
      query_scheduler: 'mimir-mimir-distributed-query-scheduler.*',
      store_gateway: 'mimir-mimir-distributed-store-gateway.*',
      gateway: 'mimir-mimir-distributed-(gateway|cortex-gw|cortex-gw).*',
    },
  }
  // grafanaDashboards+: {
  //   'mimir-operational.json'+: {
  //     matchers+:: {
  //       cortexgateway: [utils.selector.re('job', '(mimir-mimir-distributed)-cortex-gw')],
  //       distributor: [utils.selector.re('job', '(mimir-mimir-distributed)-distributor')],
  //       ingester: [utils.selector.re('job', '(mimir-mimir-distributed)-ingester')],
  //       querier: [utils.selector.re('job', '(mimir-mimir-distributed)-querier')],
  //     }
  //   }
  // }
};
local alerts = mimir.prometheusAlerts;
local dashboards = mimir.grafanaDashboards;
local rules = mimir.prometheusRules;

{
  [name]: dashboards[name] for name in std.objectFields(dashboards)
}
