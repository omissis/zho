config.define_string_list("services")

parsed_config = config.parse()

# Set default trigger mode to manual
trigger_mode(TRIGGER_MODE_MANUAL)

# Disable analytics
analytics_settings(False)

# Disable secrets scrubbing
secret_settings(disable_scrub=True)

# Allow only kind-zho k8s context
allow_k8s_contexts("kind-zho")

# Install Tilt extensions
load("ext://namespace", "namespace_create")
load("ext://namespace", "namespace_inject")

# Create namespaces
namespace_create("zho")

# Create tls secrets
zho_tls = read_file("./configs/kubernetes-manifests/zho.dev-tls.yaml")
zho_wildcard_tls = read_file("./configs/kubernetes-manifests/wildcard.zho.dev-tls.yaml")
k8s_yaml(namespace_inject(zho_tls, "default"))
k8s_yaml(namespace_inject(zho_tls, "zho"))
k8s_yaml(namespace_inject(zho_wildcard_tls, "default"))
k8s_yaml(namespace_inject(zho_wildcard_tls, "zho"))

# Load Services Tiltfiles
for service in parsed_config.get("services", []):
  load_dynamic("./configs/tiltfiles/%s.tiltfile" % (service))
