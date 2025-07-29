# ======================================
# Quiz Controller
# ======================================

Package App.Controllers

Load "app/models/quiz.ring"
Load "app/models/quiz_question.ring"
Load "app/auth/auth.ring"

Class QuizController
    # Properties
    oQuiz
    oQuestion
    oAuth
    
    func init
        oQuiz = new Quiz()
        oQuestion = new QuizQuestion()
        oAuth = new Auth().initFromSession()
    
    func create cModuleId
        # Check if user is instructor
        if not oAuth.check() or not oAuth.user().isInstructor() {
            return redirect("/courses")
                   .withError("unauthorized", "You are not authorized to create quizzes")
        }
        
        return view("quizzes/create", ["module_id" = cModuleId])
    
    func store cModuleId
        # Check if user is instructor
        if not oAuth.check() or not oAuth.user().isInstructor() {
            return redirect("/courses")
                   .withError("unauthorized", "You are not authorized to create quizzes")
        }
        
        # Validate request
        if not validate(oQuiz.rules()) {
            return redirect("/modules/" + cModuleId + "/quizzes/create")
                   .withErrors(getValidationErrors())
                   .withInput()
        }
        
        # Create quiz
        oNewQuiz = oQuiz.create([
            "module_id" = cModuleId,
            "title" = request("title"),
            "description" = request("description"),
            "duration" = request("duration"),
            "passing_score" = request("passing_score"),
            "attempts_allowed" = request("attempts_allowed")
        ])
        
        # Create questions
        aQuestions = request("questions")
        nOrder = 1
        
        for oQuestionData in aQuestions {
            oQuestion.create([
                "quiz_id" = oNewQuiz.id,
                "question" = oQuestionData["question"],
                "type" = oQuestionData["type"],
                "options" = oQuestionData["options"],
                "correct_answer" = oQuestionData["correct_answer"],
                "points" = oQuestionData["points"],
                "order" = nOrder++
            ])
        }
        
        return redirect("/modules/" + cModuleId)
               .withSuccess("quiz_created", "Quiz created successfully")
    
    func take nQuizId
        # Check if user is enrolled
        oQuizData = oQuiz.find(nQuizId)
        if not oAuth.check() or not oAuth.user().isEnrolled(oQuizData.module.course) {
            return redirect("/courses")
                   .withError("unauthorized", "You must be enrolled to take this quiz")
        }
        
        # Check remaining attempts
        nAttempts = oQuizData.getAttemptsCount(oAuth.user())
        if nAttempts >= oQuizData.attempts_allowed {
            return redirect("/courses")
                   .withError("max_attempts", "You have reached the maximum number of attempts")
        }
        
        return view("quizzes/take", ["quiz" = oQuizData])
    
    func submit nQuizId
        # Check if user is enrolled
        oQuizData = oQuiz.find(nQuizId)
        if not oAuth.check() or not oAuth.user().isEnrolled(oQuizData.module.course) {
            return redirect("/courses")
                   .withError("unauthorized", "You must be enrolled to take this quiz")
        }
        
        # Calculate score
        nTotalPoints = 0
        nEarnedPoints = 0
        aAnswers = request("answers")
        
        for oQuestion in oQuizData.questions {
            nTotalPoints += oQuestion.points
            if aAnswers[oQuestion.id] = oQuestion.correct_answer {
                nEarnedPoints += oQuestion.points
            }
        }
        
        nScore = (nEarnedPoints / nTotalPoints) * 100
        
        # Create attempt record
        oQuizData.createAttempt([
            "user_id" = oAuth.user().id,
            "score" = nScore,
            "answers" = aAnswers
        ])
        
        # Check if passed
        if nScore >= oQuizData.passing_score {
            # Generate certificate if all module quizzes are passed
            if oQuizData.module.allQuizzesPassed(oAuth.user()) {
                oQuizData.module.generateCertificate(oAuth.user())
            }
            
            return redirect("/quizzes/" + nQuizId + "/results")
                   .withSuccess("quiz_passed", "Congratulations! You passed the quiz")
        }
        
        return redirect("/quizzes/" + nQuizId + "/results")
               .withError("quiz_failed", "Sorry, you did not pass the quiz")
