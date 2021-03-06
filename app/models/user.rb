class User < ActiveRecord::Base

  default_scope { order('created_at ASC') }
  has_secure_password validations: false

  validates :email, presence: true
  validates_uniqueness_of :email, case_sensitive: false

  validates :name, presence: true, length: {minimum: 2, maximum: 50}
  validates :password, presence: true, length: {minimum: 5, maximum: 20}, on: :create

  has_many :comments
  has_many :articles

  has_many :received_notifications, foreign_key: "receiver_id", class_name: "Notification"
  has_many :sent_notifications, foreign_key: "sent_id", class_name: "Notification"

  has_many :course_users
  has_many :courses, through: :course_users

  has_many :grades
  has_many :lessons, through: :grades

  has_many :user_quizzes
  has_many :quizzes, through: :user_quizzes

  has_many :user_questions
  has_many :questions, through: :user_questions

  has_many :lesson_users
  has_many :lessons, through: :lesson_users

  has_many :user_vocabulary_words
  has_many :vocabulary_words, through: :user_vocabulary_words

  has_many :comment_notifications
  has_many :payments

  has_many :user_actions

  belongs_to :affiliate_payment

  before_create :generate_random_slug

  mount_uploader :picture_url, UserImageUploader

  alias_method :notifications, :received_notifications

  def generate_password_reset_token
    update_column(:password_reset_token, SecureRandom.urlsafe_base64)
  end

  def is_editor?
    role == "editor"
  end

  def is_paid_member?
    membership_level == "paid"
  end

  def to_param
    self.slug
  end

  def is_admin?
    role == "admin"
  end

  def make_paid_member
    update_column(:membership_level, "paid")
  end

  def enroll_in(course)
    if course.published? 
      if is_paid_member? || (!is_paid_member? && !course.premium_course?)
        CourseUser.create(course_id: course.id, user_id: self.id)      
      end
    end 
  end

  def is_enrolled_in?(course)
    !courses.where(id: course.id).empty?
  end

  def taken_quiz?(quiz)
    quizzes.where(id: quiz.id).any?
  end

  def answer_points(question)
    return 0 if !answered_correctly?(question) || !answered_question?(question)
    question.value
  end

  def answered_correctly?(question)
    answer = user_questions.find_by(question_id: question.id)
    return false unless answered_question?(question)
    answer.correct?
  end

  def selected_choice?(choice)
    choices = user_questions.map(&:choice_id)
    choices.include?(choice.id)
  end

  def quiz_score(quiz)
    return 0 unless taken_quiz?(quiz)
    total = 0
    quiz.questions.each do |question|
      total += answer_points(question)
    end
     (total.to_f / quiz.total_points_possible.to_f).round(2)
  end

  def attempt_quiz(quiz, questions_and_answers_array)
    UserQuiz.create(user_id: self.id, quiz_id: quiz.id) unless taken_quiz?(quiz)

    questions_and_answers_array.each do |qa_pair|
      answer_question(qa_pair[0], qa_pair[1])
    end
  end

  def attempted_quizzes
    user_quizzes
  end

  def answered_question?(question)
    user_questions.find_by(question_id: question.id)
  end

  def answered_questions
    user_questions
  end

  def answer_question(question, choice)
    if answered_question?(question)
      change_answer(question, choice)
    else
      UserQuestion.create(question_id: question.id, choice_id: choice.id, user_id: self.id)
    end
  end

  def complete_lesson(lesson_to_test)
    lesson = lessons.find_by(id: lesson_to_test.id)
    if lesson
      lesson_users.find_by(lesson_id: lesson_to_test.id).update_column(:completed, true)
    else
      LessonUser.create(lesson_id: lesson_to_test.id, user_id: id)
    end
  end

  def completed_lesson?(lesson)
    lesson_users.where(lesson_id: lesson.id, completed: true).count > 0
  end

  def next_lesson_in_course(course)
    if course.lessons.all? { |lesson| completed_lesson?(lesson)}
      return course.lessons.last
    end

    course.lessons.each do |lesson|
      return lesson unless completed_lesson?(lesson)
    end
    course.lessons.first
  end

  def add_points(points_to_add)
    new_points = points + points_to_add
    update_column(:points, new_points)
    advance_level_if_enough_points
    true
  end

  def leveled_up?(points_just_added)
    # user's points - points_just_added < user.level.points
    # 100 - 100 < 100
    points - points_just_added <= Level.find_by(number: level).points unless level == 1
  end

  def add_vocabulary_word(word)
    UserVocabularyWord.create(vocabulary_word_id: word.id, user_id: id, review_time: Date.today)
  end


  def practice(type, word, answer)
    question_type = type.to_s.split("_").last.to_sym
    question_type = :main if question_type == :english || question_type == :spoken || question_type == :spelling
    user_word = set_vocabulary_word(word)
    increase_attempted(type.to_s + "_attempted", user_word)
    if add_to_correct_if_correct(word, question_type, answer, user_word, type.to_s + "_correct")
      add_points(10)
    end
  end

  def random_vocabulary_words(n=10)
    vocabulary_words.order("RANDOM()").limit(n)
  end

  def has_unread_notifications?
    notifications.where(read: false).count > 0
  end

  def send_notification(notification_params, list)
    ActiveRecord::Base.transaction do
      list.each do |user|
        Notification.create(sender_id: self.id,
                            receiver_id: user.id,
                            subject: notification_params[:subject],
                            body: notification_params[:body]
                            )
      end
    end #mass transaction
  end

  def member_until
    unless is_paid_member?
      return "not a paid member"
    else
      Time.at(Stripe::Customer.retrieve(stripeid).subscriptions.first["current_period_end"])
    end
  end

  def membership_will_end?
    Stripe::Customer.retrieve(stripeid).
      subscriptions.first["cancel_at_period_end"]
  end

  private

  def add_to_correct_if_correct(word, question, answer, user_word, correct_column)
    correct = (answer == word[question])
    if correct
      old_correct = 0
      if user_word[correct_column]
        old_correct = user_word[correct_column]
      end
      user_word.update_column(correct_column, old_correct  + 1)
    else
      set_correct_column_to_0_on_first_try(correct_column, user_word)
    end
    correct
  end

  def add_to_correct_column(correct_column, user_word)
    old_correct = 0
    if user_word.chinese_to_english_correct
      old_correct = user_word.chinese_to_english_correct
    end
    user_word.update_column(:chinese_to_english_correct, old_correct + 1)
  end

  def set_correct_column_to_0_on_first_try(correct_column, user_word)
    if user_word[correct_column].nil?
        user_word.update_column(correct_column, 0)
    end
  end

  def set_vocabulary_word(word)
    user_vocabulary_words.where(vocabulary_word_id: word.id).first
  end

  def increase_attempted(attempted_column, user_word)
    old_count = 0
    if user_word[attempted_column]
      old_count  = user_word[attempted_column]
    end
    user_word.update_column(attempted_column, old_count + 1)
  end

  def advance_level_if_enough_points
    next_level =  Level.where(number: level + 1).first
    if next_level.nil?
      next_level = {number: 1, points: 10000}
    end
    update_column(:level, next_level.number) if points >= next_level.points
  end

  def change_answer(question, choice)
    user_question = user_questions.find_by(question_id: question.id)
    user_question.update_column(:choice_id, choice.id)
  end

  def generate_random_slug
    self.slug = SecureRandom.urlsafe_base64
  end


end
