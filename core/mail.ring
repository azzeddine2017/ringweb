Load "phpmailer.ring"

Class Mail
    # Configuration
    cHost = "smtp.gmail.com"
    nPort = 587
    cUsername = ""
    cPassword = ""
    cEncryption = "tls"
    
    # Email properties
    aTo = []
    aCc = []
    aBcc = []
    cFrom = ""
    cFromName = ""
    cSubject = ""
    cBody = ""
    aAttachments = []
    
    # Template data
    aData = []
    cTemplate = ""
    
    # PHPMailer instance
    oMailer = null
    
    func init
        oMailer = new PHPMailer(true)
        oMailer.isSMTP()
        
    func config aConfig
        if aConfig["host"] != null
            cHost = aConfig["host"]
        if aConfig["port"] != null
            nPort = aConfig["port"]
        if aConfig["username"] != null
            cUsername = aConfig["username"]
        if aConfig["password"] != null
            cPassword = aConfig["password"]
        if aConfig["encryption"] != null
            cEncryption = aConfig["encryption"]
        
        return self
    
    func to xTo
        if type(xTo) = "STRING"
            aTo = [xTo]
        else
            aTo = xTo
        return self
    
    func cc xCc
        if type(xCc) = "STRING"
            aCc = [xCc]
        else
            aCc = xCc
        return self
    
    func bcc xBcc
        if type(xBcc) = "STRING"
            aBcc = [xBcc]
        else
            aBcc = xBcc
        return self
    
    func from cFromEmail, cName = ""
        cFrom = cFromEmail
        cFromName = cName
        return self
    
    func subject cEmailSubject
        cSubject = cEmailSubject
        return self
    
    func body cEmailBody
        cBody = cEmailBody
        return self
    
    func template cTemplatePath
        cTemplate = cTemplatePath
        return self
    
    func with aTemplateData
        aData = aTemplateData
        return self
    
    func attach cPath
        if type(cPath) = "STRING"
            aAttachments + cPath
        else
            for cFile in cPath
                aAttachments + cFile
            next
        return self
    
    func send cCustomTemplate = null
        try
            # Configure mailer
            oMailer.Host = cHost
            oMailer.Port = nPort
            oMailer.Username = cUsername
            oMailer.Password = cPassword
            oMailer.SMTPSecure = cEncryption
            oMailer.SMTPAuth = true
            
            # Set sender
            if cFrom != ""
                oMailer.setFrom(cFrom, cFromName)
            else
                oMailer.setFrom(cUsername)
            ok
            
            # Add recipients
            for cEmail in aTo
                oMailer.addAddress(cEmail)
            next
            
            # Add CC recipients
            for cEmail in aCc
                oMailer.addCC(cEmail)
            next
            
            # Add BCC recipients
            for cEmail in aBcc
                oMailer.addBCC(cEmail)
            next
            
            # Set subject
            oMailer.Subject = cSubject
            
            # Set body
            if cCustomTemplate != null
                cTemplate = cCustomTemplate
            ok
            
            if cTemplate != ""
                cBody = this.renderTemplate(cTemplate, aData)
            ok
            
            oMailer.Body = cBody
            oMailer.isHTML(true)
            
            # Add attachments
            for cFile in aAttachments
                oMailer.addAttachment(cFile)
            next
            
            # Send email
            return oMailer.send()
            
        catch e
            log("Mail error: " + e.getMessage())
            return false
        done
    
    private
    
    func renderTemplate cTemplate, aData
        # Load template file
        cTemplateFile = "resources/views/" + cTemplate + ".ring"
        if not exists(cTemplateFile)
            throw("Template file not found: " + cTemplateFile)
        ok
        
        cContent = read(cTemplateFile)
        
        # Replace variables in template
        for cKey, xValue in aData
            cContent = substr(cContent, "{{ " + cKey + " }}", string(xValue))
        next
        
        return cContent
    
    func log cMessage
        cLogFile = "storage/logs/mail.log"
        write(cLogFile, date() + " " + time() + ": " + cMessage + nl)
