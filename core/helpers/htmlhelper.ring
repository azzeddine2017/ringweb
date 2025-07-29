# ======================================
# RingWeb Framework
# HTML Helper Functions
# ======================================

Package System.RingWeb

Class HTMLHelper

    # Create HTML tag
    func tag cName, aAttributes, cContent
        cHtml = "<" + cName
        
        # Add attributes
        if type(aAttributes) = "LIST" {
            for item in aAttributes {
                cHtml += " " + item[1] + '=\"' + string(item[2]) + '\"'
            }
        }
        
        if cContent = null {
            return cHtml + " />"
        }
        
        return cHtml + ">" + cContent + "</" + cName + ">"
    
    # Create link tag
    func link cHref, cText, aAttributes 
        aAttr = aAttributes + [["href", cHref]]
        return tag("a", aAttr, cText)
    
    # Create image tag
    func image cSrc, cAlt , aAttributes 
        aAttr = aAttributes + [["src", cSrc], ["alt", cAlt]]
        return tag("img", aAttr, null)
    
    # Create form tag
    func form cAction, cMethod, aAttributes 
        aAttr = aAttributes + [["action", cAction], ["method", cMethod]]
        return tag("form", aAttr, null)
    
    # Create input tag
    func input cType, cName, xValue, aAttributes
        aAttr = aAttributes + [
            ["type", cType],
            ["name", cName],
            ["value", string(xValue)]
        ]
        return tag("input", aAttr, null)
    
    # Create select tag
    func select cName, aOptions, xSelected, aAttributes
        aAttr = aAttributes + [["name", cName]]
        cContent = ""
        
        for item in aOptions {
            aOptAttr = [["value", item[1]]]
            if string(item[1]) = string(xSelected) {
                aOptAttr + [["selected", "selected"]]
            }
            cContent += tag("option", aOptAttr, item[2])
        }
        
        return tag("select", aAttr, cContent)
    
    # Create table tag
    func table aData, aHeaders, aAttributes
        cContent = ""
        
        # Add headers
        if len(aHeaders) > 0 {
            cHeaders = ""
            for cHeader in aHeaders {
                cHeaders += tag("th", [], cHeader)
            }
            cContent += tag("tr", [], cHeaders)
        }
        
        # Add rows
        for aRow in aData {
            cCells = ""
            for xValue in aRow {
                cCells += tag("td", [], string(xValue))
            }
            cContent += tag("tr", [], cCells)
        }
        
        return tag("table", aAttributes, cContent)
    
    # Escape HTML special characters
    func escape cText
        aReplacements = [
            ["&", "&amp;"],
            ["<", "&lt;"],
            [">", "&gt;"],
            ['\"', "&quot;"],
            ["'", "&#039;"]
        ]
        
        for aReplace in aReplacements {
            cText = substr(cText, aReplace[1], aReplace[2])
        }
        return cText
