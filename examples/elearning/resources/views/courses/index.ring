# ======================================
# RingWeb Framework
# Courses Index View
# ======================================

func getView aData
    # Extract data
    aCourses = aData["courses"]
    aCategories = aData["categories"]
    aFilters = aData["filters"]
    
    cHtml = '
    <div class="container mx-auto px-4 py-8">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold">Courses</h1>
            ' + if isLoggedIn() and isInstructor() 
                cHtml += '<a href="/courses/create" 
                   class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
                    Create Course
                </a>'
            + '
        </div>

        <!-- Categories Filter -->
        <div class="mb-8">
            <h2 class="text-xl font-semibold mb-4">Categories</h2>
            <div class="flex flex-wrap gap-2">'
                for oCategory in aCategories {
                    cHtml += '<a href="/courses?category=' + oCategory.id + '"
                       class="px-4 py-2 rounded ' + 
                       (aFilters["category"] = oCategory.id ? "bg-blue-500 text-white" : "bg-gray-100 hover:bg-gray-200") + 
                       '">' + oCategory.name + '</a>'
                }
            cHtml += '</div>
        </div>

        <!-- Courses Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">'
            if len(aCourses) > 0 
                for oCourse in aCourses {
                    cHtml += '<div class="bg-white rounded-lg shadow-lg overflow-hidden">
                        <div class="relative">
                            ' + if oCourse.image 
                                cHtml += '<img src="/storage/' + oCourse.image + '"
                                     alt="' + oCourse.title + '"
                                     class="w-full h-48 object-cover">'
                            else
                                cHtml += '<div class="w-full h-48 bg-gray-200 flex items-center justify-center">
                                    <span class="text-gray-400">No Image</span>
                                </div>'
                            + '
                            ' + if oCourse.featured 
                                cHtml += '<span class="absolute top-4 right-4 px-4 py-2 bg-yellow-500 text-white rounded">
                                    Featured
                                </span>'
                            + '
                        </div>
                        <div class="p-6">
                            <h3 class="text-xl font-semibold mb-2">' + oCourse.title + '</h3>
                            <p class="text-gray-600 mb-4">' + substr(oCourse.description, 1, 150) + '...</p>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center">
                                    <img src="' + (oCourse.instructor.avatar ? '/storage/' + oCourse.instructor.avatar : '/images/default-avatar.png') + '"
                                         alt="' + oCourse.instructor.name + '"
                                         class="w-8 h-8 rounded-full mr-2">
                                    <span class="text-gray-700">' + oCourse.instructor.name + '</span>
                                </div>
                                <span class="text-lg font-bold">$' + oCourse.price + '</span>
                            </div>
                            <a href="/courses/' + oCourse.id + '"
                               class="mt-4 block text-center bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
                                View Course
                            </a>
                        </div>
                    </div>'
                }
            else
                cHtml += '<div class="col-span-full text-center py-8">
                    <p class="text-gray-600">No courses found.</p>
                </div>'
            + '
        </div>
    </div>
    '
    
    return cHtml
