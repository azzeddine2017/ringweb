# ======================================
# RingWeb Framework
# User Create View
# ======================================

func getView aData
    cHtml = '
    <div class="container">
        <h1>Add New User</h1>
        
        ' + showFlashMessages() + '
        
        <div class="card">
            <div class="card-body">
                <form method="POST" action="/users">
                    <div class="mb-3">
                        <label for="name" class="form-label">Name</label>
                        <input type="text" class="form-control" id="name" name="name" 
                               value="' + old("name") + '">
                        ' + showError("name") + '
                    </div>
                    
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email"
                               value="' + old("email") + '">
                        ' + showError("email") + '
                    </div>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password">
                        ' + showError("password") + '
                    </div>
                    
                    <div class="mb-3">
                        <button type="submit" class="btn btn-primary">Save</button>
                        <a href="/users" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    '
    return cHtml
