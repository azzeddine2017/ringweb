# ======================================
# RingWeb Framework
# Users Index View
# ======================================

func getView aData
    cHtml = '
    <div class="container">
        <h1>Users List</h1>
        
        ' + showFlashMessages() + '
        
        <div class="mb-3">
            <a href="/users/create" class="btn btn-primary">
                Add New User
            </a>
        </div>
        
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Created At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        ' + for user in aData[:users] {
                            '<tr>
                                <td>' + user.id + '</td>
                                <td>' + user.name + '</td>
                                <td>' + user.email + '</td>
                                <td>' + user.created_at + '</td>
                                <td>
                                    <a href="/users/' + user.id + '" class="btn btn-info btn-sm">
                                        View
                                    </a>
                                    <a href="/users/' + user.id + '/edit" class="btn btn-warning btn-sm">
                                        Edit
                                    </a>
                                    <form method="POST" action="/users/' + user.id + '/delete" class="d-inline">
                                        <button type="submit" class="btn btn-danger btn-sm" 
                                                onclick="return confirm(\'Are you sure you want to delete?\')">
                                            Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>'
                        } + '
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    '
    return cHtml
