# ======================================
# Forum Controller
# ======================================

load "controller.ring"
load "../models/forumtopic.ring"
load "../models/forumreply.ring"
load "../models/course.ring"
load "../auth/auth.ring"

class ForumController from Controller
    # Properties
    oTopic
    oReply
    oCourse
    oAuth
    
    func init
        oTopic = new ForumTopic()
        oReply = new ForumReply()
        oCourse = new Course()
        oAuth = new Auth().initFromSession()
    
    # Show forum topics for course
    func index
        courseId = request("course_id")
        course = oCourse.find(courseId)
        if !course return redirect("/404")
        
        # Check if user is enrolled or instructor
        if !oAuth.check() or (!oAuth.user().isInstructor() and !course.isUserEnrolled(oAuth.user().id))
            return redirect("/courses/" + courseId).withError("unauthorized", "You must be enrolled to view forum topics")
        
        topics = oTopic.where("course_id = ?", [courseId])
                      .orderBy("created_at", "DESC")
                      .get()
        
        return view("forum/index", {
            "course": course,
            "topics": topics
        })
    
    # Show topic creation form
    func create
        courseId = request("course_id")
        course = oCourse.find(courseId)
        if !course return redirect("/404")
        
        # Check if user is enrolled or instructor
        if !oAuth.check() or (!oAuth.user().isInstructor() and !course.isUserEnrolled(oAuth.user().id))
            return redirect("/courses/" + courseId).withError("unauthorized", "You must be enrolled to create topics")
        
        return view("forum/create", {
            "course": course
        })
    
    # Store new topic
    func store
        courseId = request("course_id")
        course = oCourse.find(courseId)
        if !course return redirect("/404")
        
        # Check if user is enrolled or instructor
        if !oAuth.check() or (!oAuth.user().isInstructor() and !course.isUserEnrolled(oAuth.user().id))
            return redirect("/courses/" + courseId).withError("unauthorized", "You must be enrolled to create topics")
        
        # Create topic
        topicId = oTopic.create({
            "course_id": courseId,
            "user_id": oAuth.user().id,
            "title": request("title"),
            "content": request("content"),
            "status": "open"
        })
        
        # Notify course instructor
        if oAuth.user().id != course.instructor_id
            query("INSERT INTO notifications (
                user_id, 
                type, 
                data, 
                created_at, 
                updated_at
            ) VALUES (?, ?, ?, NOW(), NOW())", [
                course.instructor_id,
                "new_topic",
                json_encode({
                    "course_id": courseId,
                    "topic_id": topicId,
                    "user_name": oAuth.user().name
                })
            ])
        
        return redirect("/courses/" + courseId + "/forum/" + topicId)
    
    # Show topic details
    func show
        topicId = request("id")
        topic = oTopic.find(topicId)
        if !topic return redirect("/404")
        
        course = oCourse.find(topic.course_id)
        
        # Check if user is enrolled or instructor
        if !oAuth.check() or (!oAuth.user().isInstructor() and !course.isUserEnrolled(oAuth.user().id))
            return redirect("/courses/" + course.id).withError("unauthorized", "You must be enrolled to view topics")
        
        # Increment view count
        query("UPDATE forum_topics SET views = views + 1 WHERE id = ?", [topicId])
        
        # Get replies
        replies = oReply.where("topic_id = ?", [topicId])
                       .orderBy("created_at", "ASC")
                       .get()
        
        return view("forum/show", {
            "topic": topic,
            "course": course,
            "replies": replies
        })
    
    # Store new reply
    func reply
        topicId = request("topic_id")
        topic = oTopic.find(topicId)
        if !topic return redirect("/404")
        
        course = oCourse.find(topic.course_id)
        
        # Check if user is enrolled or instructor
        if !oAuth.check() or (!oAuth.user().isInstructor() and !course.isUserEnrolled(oAuth.user().id))
            return redirect("/courses/" + course.id).withError("unauthorized", "You must be enrolled to reply")
        
        # Create reply
        replyId = oReply.create({
            "topic_id": topicId,
            "user_id": oAuth.user().id,
            "content": request("content")
        })
        
        # Notify topic creator if different from reply creator
        if oAuth.user().id != topic.user_id
            query("INSERT INTO notifications (
                user_id, 
                type, 
                data, 
                created_at, 
                updated_at
            ) VALUES (?, ?, ?, NOW(), NOW())", [
                topic.user_id,
                "new_reply",
                json_encode({
                    "topic_id": topicId,
                    "reply_id": replyId,
                    "user_name": oAuth.user().name
                })
            ])
        
        return redirect("/courses/" + course.id + "/forum/" + topicId)
    
    # Mark reply as solution
    func markSolution
        replyId = request("reply_id")
        reply = oReply.find(replyId)
        if !reply return redirect("/404")
        
        topic = oTopic.find(reply.topic_id)
        course = oCourse.find(topic.course_id)
        
        # Check if user is topic creator or instructor
        if !oAuth.check() or (oAuth.user().id != topic.user_id and !oAuth.user().isInstructor())
            return redirect("/courses/" + course.id + "/forum/" + topic.id)
                   .withError("unauthorized", "You are not authorized to mark solutions")
        
        # Update reply and topic
        query("UPDATE forum_replies SET is_solution = 1 WHERE id = ?", [replyId])
        query("UPDATE forum_topics SET status = 'solved' WHERE id = ?", [topic.id])
        
        # Notify reply creator
        if oAuth.user().id != reply.user_id
            query("INSERT INTO notifications (
                user_id, 
                type, 
                data, 
                created_at, 
                updated_at
            ) VALUES (?, ?, ?, NOW(), NOW())", [
                reply.user_id,
                "solution_marked",
                json_encode({
                    "topic_id": topic.id,
                    "reply_id": replyId
                })
            ])
        
        return redirect("/courses/" + course.id + "/forum/" + topic.id)
