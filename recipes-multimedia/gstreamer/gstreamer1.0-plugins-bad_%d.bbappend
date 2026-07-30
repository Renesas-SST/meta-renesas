PACKAGECONFIG:append = " faac faad"

PACKAGECONFIG:remove = "introspection"
EXTRA_OEMESON += "-Dintrospection=disabled"
