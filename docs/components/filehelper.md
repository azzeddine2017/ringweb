# FileHelper Component Documentation

## Overview
The FileHelper component provides a comprehensive set of methods for file system operations.

## Methods

### Basic File Operations

#### extension(cPath)
Gets the file extension.
```ring
cExt = FileHelper.extension("image.jpg") # Returns "jpg"
```

#### basename(cPath)
Gets the base name of the file.
```ring
cName = FileHelper.basename("path/to/image.jpg") # Returns "image.jpg"
```

#### size(cPath)
Gets the file size in bytes.
```ring
nSize = FileHelper.size("file.txt")
```

#### formatSize(nSize)
Formats file size to human-readable format.
```ring
cSize = FileHelper.formatSize(1024) # Returns "1 KB"
```

### Directory Operations

#### createDirectory(cPath)
Creates a directory recursively.
```ring
FileHelper.createDirectory("path/to/new/dir")
```

#### deleteDirectory(cPath)
Deletes a directory and its contents.
```ring
FileHelper.deleteDirectory("path/to/dir")
```

#### copyDirectory(cSource, cDest)
Copies a directory and its contents.
```ring
FileHelper.copyDirectory("source/dir", "dest/dir")
```

### File Management

#### copy(cSource, cDest)
Copies a file.
```ring
FileHelper.copy("source.txt", "dest.txt")
```

#### delete(cPath)
Deletes a file.
```ring
FileHelper.delete("file.txt")
```

#### exists(cPath)
Checks if a file exists.
```ring
if FileHelper.exists("file.txt") {
    # File exists
}
```

### MIME Types

#### mime(cPath)
Gets the MIME type of a file.
```ring
cMime = FileHelper.mime("image.jpg") # Returns "image/jpeg"
```

### File Upload

#### upload(oFile, cDestination, cFilename = null)
Handles file upload.
```ring
FileHelper.upload(request("file"), "uploads/images")
```

## Best Practices

### Security
1. Always validate file types before upload
2. Use secure file permissions
3. Sanitize file names
4. Check file sizes
5. Implement proper error handling

### Performance
1. Use streaming for large files
2. Implement caching when appropriate
3. Clean up temporary files
4. Use batch operations for multiple files

### Examples

#### File Upload with Validation
```ring
func uploadImage
    # Validate file
    if not validateFile(request("image"), ["jpg", "png"]) {
        return false
    }
    
    # Generate unique filename
    cFilename = generateUniqueFilename()
    
    # Upload file
    return FileHelper.upload(
        request("image"),
        "uploads/images",
        cFilename
    )
```

#### Directory Backup
```ring
func backupDirectory
    cSource = "path/to/source"
    cBackup = "path/to/backup/" + date("Y-m-d")
    
    # Create backup directory
    FileHelper.createDirectory(cBackup)
    
    # Copy files
    return FileHelper.copyDirectory(cSource, cBackup)
```

## Error Handling
The component throws exceptions for various error conditions:
- FileNotFoundException
- DirectoryNotFoundException
- PermissionDeniedException
- InvalidFileTypeException

Always wrap file operations in try-catch blocks:
```ring
try {
    FileHelper.copy("source.txt", "dest.txt")
catch e
    log("File copy failed: " + e.message)
}
```
