# ======================================
# RingWeb Framework
# Course Create View
# ======================================

func getView aData
    # Extract data
    aCategories = aData["categories"]
    aErrors = aData["errors"]
    oOldInput = aData["old"]
    
    cHtml = '
    <div class="container mx-auto px-4 py-8">
        <div class="max-w-3xl mx-auto">
            <h1 class="text-3xl font-bold mb-8">Create New Course</h1>

            <form action="/courses" method="POST" enctype="multipart/form-data" class="space-y-6">
                <input type="hidden" name="_token" value="' + getCSRFToken() + '">

                <!-- Course Title -->
                <div>
                    <label for="title" class="block text-sm font-medium text-gray-700">Course Title</label>
                    <input type="text" 
                           name="title" 
                           id="title"
                           value="' + (oOldInput["title"] ? htmlspecialchars(oOldInput["title"]) : "") + '"
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ' + 
                           (aErrors["title"] ? "border-red-500" : "") + '">
                    ' + if aErrors["title"]
                        cHtml += '<p class="mt-1 text-sm text-red-500">' + aErrors["title"] + '</p>'
                    + '
                </div>

                <!-- Course Description -->
                <div>
                    <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea name="description" 
                              id="description"
                              rows="4"
                              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ' + 
                              (aErrors["description"] ? "border-red-500" : "") + '">' + 
                              (oOldInput["description"] ? htmlspecialchars(oOldInput["description"]) : "") + '</textarea>
                    ' + if aErrors["description"]
                        cHtml += '<p class="mt-1 text-sm text-red-500">' + aErrors["description"] + '</p>'
                    + '
                </div>

                <!-- Course Image -->
                <div>
                    <label for="image" class="block text-sm font-medium text-gray-700">Course Image</label>
                    <input type="file"
                           name="image"
                           id="image"
                           accept="image/*"
                           class="mt-1 block w-full ' + (aErrors["image"] ? "border-red-500" : "") + '">
                    ' + if aErrors["image"]
                        cHtml += '<p class="mt-1 text-sm text-red-500">' + aErrors["image"] + '</p>'
                    + '
                </div>

                <!-- Course Category -->
                <div>
                    <label for="category_id" class="block text-sm font-medium text-gray-700">Category</label>
                    <select name="category_id"
                            id="category_id"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ' + 
                            (aErrors["category_id"] ? "border-red-500" : "") + '">
                        <option value="">Select a category</option>'
                        for oCategory in aCategories {
                            cHtml += '<option value="' + oCategory.id + '"' + 
                                    (oOldInput["category_id"] = oCategory.id ? " selected" : "") + '>' + 
                                    oCategory.name + '</option>'
                        }
                    cHtml += '</select>
                    ' + if aErrors["category_id"]
                        cHtml += '<p class="mt-1 text-sm text-red-500">' + aErrors["category_id"] + '</p>'
                    + '
                </div>

                <!-- Course Level -->
                <div>
                    <label for="level" class="block text-sm font-medium text-gray-700">Level</label>
                    <select name="level"
                            id="level"
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ' + 
                            (aErrors["level"] ? "border-red-500" : "") + '">
                        <option value="">Select a level</option>
                        <option value="beginner"' + (oOldInput["level"] = "beginner" ? " selected" : "") + '>Beginner</option>
                        <option value="intermediate"' + (oOldInput["level"] = "intermediate" ? " selected" : "") + '>Intermediate</option>
                        <option value="advanced"' + (oOldInput["level"] = "advanced" ? " selected" : "") + '>Advanced</option>
                    </select>
                    ' + if aErrors["level"]
                        cHtml += '<p class="mt-1 text-sm text-red-500">' + aErrors["level"] + '</p>'
                    + '
                </div>

                <!-- Course Duration -->
                <div>
                    <label for="duration" class="block text-sm font-medium text-gray-700">Duration (minutes)</label>
                    <input type="number"
                           name="duration"
                           id="duration"
                           min="1"
                           value="' + (oOldInput["duration"] ? htmlspecialchars(oOldInput["duration"]) : "") + '"
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ' + 
                           (aErrors["duration"] ? "border-red-500" : "") + '">
                    ' + if aErrors["duration"]
                        cHtml += '<p class="mt-1 text-sm text-red-500">' + aErrors["duration"] + '</p>'
                    + '
                </div>

                <!-- Course Price -->
                <div>
                    <label for="price" class="block text-sm font-medium text-gray-700">Price ($)</label>
                    <input type="number"
                           name="price"
                           id="price"
                           min="0"
                           step="0.01"
                           value="' + (oOldInput["price"] ? htmlspecialchars(oOldInput["price"]) : "") + '"
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ' + 
                           (aErrors["price"] ? "border-red-500" : "") + '">
                    ' + if aErrors["price"]
                        cHtml += '<p class="mt-1 text-sm text-red-500">' + aErrors["price"] + '</p>'
                    + '
                </div>

                <!-- Featured Course -->
                <div class="flex items-center">
                    <input type="checkbox"
                           name="featured"
                           id="featured"
                           value="1"
                           ' + (oOldInput["featured"] ? "checked" : "") + '
                           class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
                    <label for="featured" class="ml-2 block text-sm text-gray-700">
                        Mark as Featured Course
                    </label>
                </div>

                <div class="flex justify-end space-x-4">
                    <a href="/courses" class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                        Cancel
                    </a>
                    <button type="submit" class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                        Create Course
                    </button>
                </div>
            </form>
        </div>
    </div>
    '
    
    return cHtml
