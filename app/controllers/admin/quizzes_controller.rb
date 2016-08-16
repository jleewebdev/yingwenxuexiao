class Admin::QuizzesController < ApplicationController

  before_action :set_quiz, only: [:show, :update, :edit]
  before_action :set_lesson, only: [:show, :update, :edit, :new, :create]
  before_action :set_course, only: [:show, :update, :edit, :new, :create]
  before_action :set_choice, only: [:edit]

  add_breadcrumb "Admin", :root_path
  add_breadcrumb "Courses", :admin_courses_path
  
  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(lesson_id: @lesson.id)
    if @quiz.save
      flash[:success] = "Quiz was created"
      redirect_to edit_admin_course_lesson_quiz_path(Course.find_by(slug: params[:course_id]), @lesson, @quiz)
    else
      flash.now[:danger] = "There was a problem and the quiz was not saved"
      render :new
    end
  end

  def edit

    add_breadcrumb @course.name, admin_course_path(@course)
    add_breadcrumb @lesson.name, admin_course_lesson_path(@course, @lesson)

    @question = Question.new
  end

  def show
    
  end

  private

  def set_choice
    @choice = Choice.new
  end

  def set_quiz
    @quiz = Quiz.find_by(slug: params[:id])
  end

  def set_lesson
    @lesson = Lesson.find_by(slug: params[:lesson_id])
  end

  def set_course
    @course = Course.find_by(slug: params[:course_id])
  end

  def quiz_params
    params.require(:quiz).permit!
  end

end