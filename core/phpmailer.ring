Load "internetlib.ring"

Class PHPMailer
    # SMTP properties
    Host = ""
    Port = 587
    Username = ""
    Password = ""
    SMTPSecure = "tls"
    SMTPAuth = true
    
    # Email properties
    From = ""
    FromName = ""
    Subject = ""
    Body = ""
    IsHTML = true
    
    # Recipients
    aTo = []
    aCc = []
    aBcc = []
    
    # Attachments
    aAttachments = []
    
    func init lException = true
    
    func isSMTP
        # Set mailer to use SMTP
        return self
    
    func setFrom cEmail, cName = ""
        From = cEmail
        FromName = cName
        return self
    
    func addAddress cEmail, cName = ""
        aTo + [cEmail, cName]
        return self
    
    func addCC cEmail, cName = ""
        aCc + [cEmail, cName]
        return self
    
    func addBCC cEmail, cName = ""
        aBcc + [cEmail, cName]
        return self
    
    func addAttachment cPath, cName = ""
        aAttachments + [cPath, cName]
        return self
    
    func isHTML lValue
        IsHTML = lValue
        return self
    
    func send
        try
            # Create email content
            cContent = "From: " + FromName + " <" + From + ">" + nl
            
            # Add To recipients
            for aRecipient in aTo
                cContent += "To: "
                if aRecipient[2] != ""
                    cContent += aRecipient[2] + " "
                ok
                cContent += "<" + aRecipient[1] + ">" + nl
            next
            
            # Add CC recipients
            for aRecipient in aCc
                cContent += "Cc: "
                if aRecipient[2] != ""
                    cContent += aRecipient[2] + " "
                ok
                cContent += "<" + aRecipient[1] + ">" + nl
            next
            
            # Add BCC recipients
            for aRecipient in aBcc
                cContent += "Bcc: "
                if aRecipient[2] != ""
                    cContent += aRecipient[2] + " "
                ok
                cContent += "<" + aRecipient[1] + ">" + nl
            next
            
            # Add subject
            cContent += "Subject: " + Subject + nl
            
            # Add content type
            if IsHTML
                cContent += "Content-Type: text/html; charset=UTF-8" + nl
            else
                cContent += "Content-Type: text/plain; charset=UTF-8" + nl
            ok
            
            # Add body
            cContent += nl + Body
            
            # Create SMTP connection
            oSMTP = new SMTP(Host, Port)
            
            # Start TLS if required
            if SMTPSecure = "tls"
                oSMTP.starttls()
            ok
            
            # Authenticate if required
            if SMTPAuth
                oSMTP.auth(Username, Password)
            ok
            
            # Send email
            oSMTP.send(From, aTo[1][1], cContent)
            
            # Close connection
            oSMTP.close()
            
            return true
            
        catch e
            throw(e)
            return false
        done
    
Class SMTP
    # Connection properties
    cHost = ""
    nPort = 0
    oSocket = null
    
    func init cHost, nPort
        this.cHost = cHost
        this.nPort = nPort
        oSocket = new Socket
        
        # Connect to SMTP server
        if not oSocket.connect(cHost, nPort)
            throw("Could not connect to SMTP server")
        ok
        
        # Read greeting
        this.getResponse()
    
    func starttls
        # Send STARTTLS command
        oSocket.send("STARTTLS" + nl)
        if not this.checkResponse(220)
            throw("STARTTLS failed")
        ok
        
        # Upgrade to TLS
        oSocket = oSocket.ssl()
    
    func auth cUsername, cPassword
        # Send AUTH LOGIN command
        oSocket.send("AUTH LOGIN" + nl)
        if not this.checkResponse(334)
            throw("AUTH LOGIN failed")
        ok
        
        # Send username
        oSocket.send(base64_encode(cUsername) + nl)
        if not this.checkResponse(334)
            throw("Username rejected")
        ok
        
        # Send password
        oSocket.send(base64_encode(cPassword) + nl)
        if not this.checkResponse(235)
            throw("Authentication failed")
        ok
    
    func send cFrom, cTo, cContent
        # Send MAIL FROM command
        oSocket.send("MAIL FROM:<" + cFrom + ">" + nl)
        if not this.checkResponse(250)
            throw("MAIL FROM failed")
        ok
        
        # Send RCPT TO command
        oSocket.send("RCPT TO:<" + cTo + ">" + nl)
        if not this.checkResponse(250)
            throw("RCPT TO failed")
        ok
        
        # Send DATA command
        oSocket.send("DATA" + nl)
        if not this.checkResponse(354)
            throw("DATA command failed")
        ok
        
        # Send email content
        oSocket.send(cContent + nl + "." + nl)
        if not this.checkResponse(250)
            throw("Message send failed")
        ok
    
    func close
        # Send QUIT command
        oSocket.send("QUIT" + nl)
        oSocket.close()
    
    private
    
    func getResponse
        return oSocket.recv(1024)
    
    func checkResponse nExpectedCode
        cResponse = this.getResponse()
        return left(cResponse, 3) = string(nExpectedCode)
