(import "node-mixin/mixin.libsonnet") {
  _config+:: {
    nodeExporterSelector: 'job="node-exporter"',
    showMultiCluster: true,
  },
  grafanaDashboards+: {
    "node-cluster-rsrc-use.json"+: {
      templating+: {
        list: [
          if item.name == "datasource" then item + {current+: {text: "Mimir", value: "Mimir", selected: true}} else item
            for item in super.list
        ],
      },
    },
    "node-multicluster-rsrc-use.json"+: {
      templating+: {
        list: [
          if item.name == "datasource" then item + {current+: {text: "Mimir", value: "Mimir", selected: true}} else item
            for item in super.list
        ],
      },
    },
    "node-rsrc-use.json"+: {
      templating+: {
        list: [
          if item.name == "datasource" then item + {current+: {text: "Mimir", value: "Mimir", selected: true}} else item
            for item in super.list
        ],
      },
    },
    "nodes.json"+: {
      templating+: {
        list: [
          if item.name == "datasource" then item + {current+: {text: "Mimir", value: "Mimir", selected: true}} else item
            for item in super.list
        ],
      },
    },
  }
}.grafanaDashboards
