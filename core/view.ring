# ======================================
# RingWeb Framework
# View Engine Class
# ======================================

Package System.RingWeb

Class View
    # View properties
    cViewPath = "views/"
    cLayoutPath = "views/layouts/"
    cPartialPath = "views/partials/"
    cExtension = ".ring"
    
    # Cache settings
    bUseCache = false
    aViewCache = []
    
    # View data
    aData = []
    
    func init
        # Initialize view cache if enabled
        if bUseCache {
            loadCache()
        }
    
    # Set view path
    func setViewPath cPath
        cViewPath = cPath
        return self
    
    # Render a view with data
    func renderView cView, aViewData
        # Merge view data
        mergeData(aViewData)
        
        # Get view content
        cContent = getViewContent(cView)
        
        # Parse and evaluate view
        return evaluateView(cContent)
    
    # Render a layout with content
    func renderLayout cLayout, cViewContent
        # Store view content in data
        aData["content"] = cViewContent
        
        # Get layout content
        cContent = getLayoutContent(cLayout)
        
        # Parse and evaluate layout
        return evaluateView(cContent)
    
    # Render a partial view
    func renderPartial cPartial, aPartialData
        # Get partial content
        cContent = getPartialContent(cPartial)
        
        # Create temporary view with partial data
        oTempView = new View()
        return oTempView.renderView(cContent, aPartialData)
    
    private
        # Load view content
        func getViewContent cView
            cFile = cViewPath + cView + cExtension
            return loadViewFile(cFile)
        
        # Load layout content
        func getLayoutContent cLayout
            cFile = cLayoutPath + cLayout + cExtension
            return loadViewFile(cFile)
        
        # Load partial content
        func getPartialContent cPartial
            cFile = cPartialPath + cPartial + cExtension
            return loadViewFile(cFile)
        
        # Load view file with cache support
        func loadViewFile cFile
            if bUseCache and aViewCache[cFile] != null {
                return aViewCache[cFile]
            }
            
            if not fexists(cFile) {
                raise("View file not found: " + cFile)
            }
            
            cContent = read(cFile)
            
            if bUseCache {
                aViewCache[cFile] = cContent
            }
            
            return cContent
        
        # Merge view data
        func mergeData aViewData
            if type(aViewData) = "LIST" {
                for item in aViewData {
                    aData[item[1]] = item[2]
                }
            }
        
        # Evaluate view content
        func evaluateView cContent
            # Replace variables {{ varName }}
            cResult = cContent
            for item in aData {
                cResult = substr(cResult, "{{" + item[1] + "}}", string(item[2]))
            }
            
            # Handle control structures
            # @if, @else, @endif
            # @for, @endfor
            # @while, @endwhile
            
            return cResult
        
        # Initialize cache
        func loadCache
            aViewCache = []
