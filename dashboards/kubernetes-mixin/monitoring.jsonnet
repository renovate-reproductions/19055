(import "kubernetes-mixin/mixin.libsonnet") {
  _config+:: {
    cadvisorSelector: 'job="kubelet"',
    diskDeviceSelector: 'device=~"/dev/(%s)"' % std.join('|', self.diskDevices),
    kubeApiserverSelector: 'job="apiserver"',
    showMultiCluster: true,
  },
}.grafanaDashboards
