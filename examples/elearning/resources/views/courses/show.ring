# ======================================
# RingWeb Framework
# Course Show View
# ======================================

func getView aData
    # Extract data
    oCourse = aData["course"]
    oInstructor = aData["instructor"]
    aModules = aData["modules"]
    nEnrollments = aData["enrollments_count"]
    bIsEnrolled = aData["is_enrolled"]
    
    cHtml = '
    <div class="container mx-auto px-4 py-8">
        <!-- Course Header -->
        <div class="bg-white rounded-lg shadow-lg overflow-hidden mb-8">
            <div class="relative">
                ' + if oCourse.image {
                    cHtml += '<img src="/storage/' + oCourse.image + '"
                         alt="' + oCourse.title + '"
                         class="w-full h-96 object-cover">'
                } else {
                    cHtml += '<div class="w-full h-96 bg-gray-200 flex items-center justify-center">
                        <span class="text-gray-400">No Image</span>
                    </div>'
                } + '

                ' + if oCourse.featured {
                    cHtml += '<span class="absolute top-4 right-4 px-4 py-2 bg-yellow-500 text-white rounded">
                        Featured
                    </span>'
                } + '
            </div>

            <div class="p-8">
                <div class="flex justify-between items-start">
                    <div>
                        <h1 class="text-4xl font-bold mb-4">' + oCourse.title + '</h1>
                        <div class="flex items-center gap-4 text-gray-600 mb-6">
                            <span>' + oCourse.duration + ' mins</span>
                            <span>' + oCourse.level + '</span>
                            <span>' + nEnrollments + ' students enrolled</span>
                        </div>
                    </div>
                    <div class="text-right">
                        <div class="text-3xl font-bold mb-4">$' + oCourse.price + '</div>
                        ' + if isLoggedIn() {
                            if bIsEnrolled {
                                cHtml += '<a href="/courses/' + oCourse.id + '/learn" 
                                    class="inline-block bg-green-500 text-white px-8 py-3 rounded-lg w-full text-center">
                                    Continue Learning
                                </a>'
                            else
                                cHtml += '<form action="/courses/' + oCourse.id + '/enroll" method="POST">
                                    <input type="hidden" name="_token" value="' + getCSRFToken() + '">
                                    <button class="bg-blue-500 hover:bg-blue-600 text-white px-8 py-3 rounded-lg w-full">
                                        Enroll Now
                                    </button>
                                </form>'
                            }
                        else
                            cHtml += '<a href="/login" 
                               class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-8 py-3 rounded-lg w-full text-center">
                                Login to Enroll
                            </a>'
                        } + '
                    </div>
                </div>

                <!-- Instructor Info -->
                <div class="flex items-center mt-8 p-4 bg-gray-50 rounded-lg">
                    <img src="' + (oInstructor.avatar ? '/storage/' + oInstructor.avatar : '/images/default-avatar.png') + '"
                         alt="' + oInstructor.name + '"
                         class="w-16 h-16 rounded-full mr-4">
                    <div>
                        <h3 class="text-xl font-semibold">' + oInstructor.name + '</h3>
                        <p class="text-gray-600">Instructor</p>
                    </div>
                </div>

                <!-- Course Description -->
                <div class="mt-8">
                    <h2 class="text-2xl font-semibold mb-4">About This Course</h2>
                    <div class="prose max-w-none">
                        ' + oCourse.description + '
                    </div>
                </div>
            </div>
        </div>

        <!-- Course Content -->
        <div class="bg-white rounded-lg shadow-lg overflow-hidden">
            <div class="p-8">
                <h2 class="text-2xl font-semibold mb-6">Course Content</h2>

                ' + if len(aModules) > 0 {
                    cHtml += '<div class="space-y-4">'
                    for oModule in aModules {
                        cHtml += '<div class="border rounded-lg">
                            <div class="p-4 bg-gray-50 flex justify-between items-center">
                                <h3 class="text-lg font-semibold">
                                    Module ' + oModule.order + ': ' + oModule.title + '
                                </h3>
                                <span class="text-gray-600">
                                    ' + len(oModule.lessons) + ' lessons
                                </span>
                            </div>'

                        if isLoggedIn() and (bIsEnrolled or getCurrentUserId() = oCourse.instructor_id) {
                            cHtml += '<div class="p-4 space-y-2">'
                            for oLesson in oModule.lessons {
                                cHtml += '<div class="flex items-center justify-between py-2">
                                    <div class="flex items-center">'
                                if oLesson.content_type = "video" {
                                    cHtml += '<i class="fas fa-play-circle mr-2"></i>'
                                } else if oLesson.content_type = "document" {
                                    cHtml += '<i class="fas fa-file-alt mr-2"></i>'
                                } else {
                                    cHtml += '<i class="fas fa-question-circle mr-2"></i>'
                                }
                                cHtml += '<span>' + oLesson.title + '</span>
                                    </div>
                                    <span class="text-gray-600">
                                        ' + oLesson.duration + ' mins
                                    </span>
                                </div>'
                            }
                            cHtml += '</div>'
                        } else {
                            cHtml += '<div class="p-4 text-gray-600">
                                <p>Enroll to view course content</p>
                            </div>'
                        }
                        cHtml += '</div>'
                    }
                    cHtml += '</div>'
                } else {
                    cHtml += '<p class="text-gray-600">No content available yet.</p>'
                } + '

                ' + if isLoggedIn() and getCurrentUserId() = oCourse.instructor_id {
                    cHtml += '<div class="mt-8">
                        <a href="/courses/' + oCourse.id + '/modules/create"
                           class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
                            Add Module
                        </a>
                    </div>'
                } + '
            </div>
        </div>
    </div>
    '
    
    return cHtml
