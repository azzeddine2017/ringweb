# ======================================
# RingWeb Framework
# File Helper Functions
# ======================================

Package System.RingWeb

Class FileHelper

    # Get file extension
    func getExtension cPath
        nPos = substr(cPath, ".")
        if nPos = 0 { return "" }
        return substr(cPath, nPos + 1)
    
    # Get file name without extension
    func getBaseName cPath
        cFile = filename(cPath)
        nPos = substr(cFile, ".")
        if nPos = 0 { return cFile }
        return left(cFile, nPos - 1)
    
    # Get human readable file size
    func formatSize nSize
        aUnits = ["B", "KB", "MB", "GB", "TB"]
        nIndex = 1
        nValue = nSize
        
        while nValue >= 1024 and nIndex < len(aUnits) {
            nValue = nValue / 1024
            nIndex++
        }
        
        return string(round(nValue, 2)) + " " + aUnits[nIndex]
    
    # Create directory recursively
    func makeDirectory cPath
        if dirExists(cPath) { return true }
        
        # Create parent directories
        cParent = justpath(cPath)
        if not dirExists(cParent) {
            makeDirectory(cParent)
        }
        
        # Create directory
        system("mkdir " + cPath)
        return dirExists(cPath)
    
    # Copy file
    func copyFile cSource, cTarget
        if not fexists(cSource) { return false }
        
        # Create target directory if not exists
        cTargetDir = justpath(cTarget)
        if not dirExists(cTargetDir) {
            makeDirectory(cTargetDir)
        }
        
        # Copy file
        write(cTarget, read(cSource))
        return fexists(cTarget)
    
    # Delete file or directory
    func delete cPath
        if fexists(cPath) {
            remove(cPath)
            return not fexists(cPath)
        }
        if dirExists(cPath) {
            system("rmdir /s /q " + cPath)
            return not dirExists(cPath)
        }
        return false
    
    # Get MIME type
    func getMimeType cPath
        aMimeTypes = [
            :txt = "text/plain",
            :html = "text/html",
            :css = "text/css",
            :js = "application/javascript",
            :json = "application/json",
            :xml = "application/xml",
            :jpg = "image/jpeg",
            :jpeg = "image/jpeg",
            :png = "image/png",
            :gif = "image/gif",
            :pdf = "application/pdf",
            :zip = "application/zip"
        ]
        
        cExt = lower(getExtension(cPath))
        if aMimeTypes[cExt] != null {
            return aMimeTypes[cExt]
        }
        return "application/octet-stream"
