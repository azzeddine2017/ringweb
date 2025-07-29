# ======================================
# RingWeb Framework
# Autoloader Class
# ======================================

Package System.RingWeb

Class Autoloader
    # Properties
    aNamespaces = []      # Namespace mappings [[:namespace = "path"], ...]
    aClassMap = []        # Direct class to file mappings [[:class = "path"], ...]
    aLoadedFiles = []     # Track loaded files
    cBasePath = null      # Base path for relative paths
    
    func init
        # Set base path to framework root
        cBasePath = currentdir()
        
        # Register default namespace
        registerNamespace("System.RingWeb", "core")
    
    # Register a namespace with its base directory
    func registerNamespace cNamespace, cBasePath
        if right(cNamespace, 1) != "." { cNamespace += "." }
        if right(cBasePath, 1) != "/" { cBasePath += "/" }
        
        # Convert relative path to absolute
        if left(cBasePath, 1) != "/" {
            cBasePath = self.cBasePath + "/" + cBasePath
        }
        
        aNamespaces + [cNamespace, cBasePath]
        return self
    
    # Register a direct class to file mapping
    func registerClass cClassName, cFilePath
        # Convert relative path to absolute
        if left(cFilePath, 1) != "/" {
            cFilePath = self.cBasePath + "/" + cFilePath
        }
        
        aClassMap + [cClassName, cFilePath]
        return self
    
    # Load a class by its name
    func loadClass cClassName
        # Check if class is already loaded
        if isLoaded(cClassName) { return true }
        
        # Try direct class mapping first
        for item in aClassMap {
            if item[1] = cClassName {
                return loadFile(item[2])
            }
        }
        
        # Try namespace mapping
        for ns in aNamespaces {
            cNamespace = ns[1]
            cPath = ns[2]
            if left(cClassName, len(cNamespace)) = cNamespace {
                # Convert class name to path
                cRelativePath = substr(cClassName, len(cNamespace) + 1)
                cRelativePath = lower(cRelativePath)
                cRelativePath = substr(cRelativePath, ".", "/")
                cFilePath = cPath + cRelativePath + ".ring"
                
                if loadFile(cFilePath) { return true }
            }
        }
        
        return false
    
    # Load a file
    func loadFile cFilePath
        if not fExists(cFilePath) { return false }
        if isFileLoaded(cFilePath) { return true }
        
        try {
            load cFilePath
            aLoadedFiles + cFilePath
            return true
        catch
            return false
        }
    
    # Check if class is loaded
    func isLoaded cClassName
        try {
            eval("new " + cClassName)
            return true
        catch
            return false
        }
    
    # Check if file is loaded
    func isFileLoaded cFilePath
        return find(aLoadedFiles, cFilePath) 
    
    # Get registered namespaces
    func getNamespaces
        return aNamespaces
    
    # Get class map
    func getClassMap
        return aClassMap
    
    # Get loaded files
    func getLoadedFiles
        return aLoadedFiles
