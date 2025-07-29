# ======================================
# RingWeb Framework
# Bootstrap File
# ======================================

# Load core files
load "core/autoloader.ring"

# Initialize autoloader
oAutoloader = new System.RingWeb.Autoloader()

# Register core namespaces
oAutoloader.registerNamespace("System.RingWeb.Core", "core")
oAutoloader.registerNamespace("System.RingWeb.Core.Cache", "core/cache")
oAutoloader.registerNamespace("System.RingWeb.Core.Helpers", "core/helpers")

# Register autoload function
AutoLoad = func cClassName {
    return oAutoloader.loadClass(cClassName)
}
