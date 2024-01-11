class HomeController < ApplicationController
  before_action :require_user!
  # before_action :authenticate_user!
  # before_action :authenticate_by_session

  def index
    @id = current_user.email
    @dueStudents = Student.getDue(@id)
  end

  def stripYear(var)
    tmp = var.strip
    idx = tmp.rindex(" ")
    if idx.nil?
    else
      idx = idx + 1
      tmp = tmp[idx..-1].strip
    end
    return tmp
  end

  def getYears
    sems = Course.where(teacher:@id)
    uniqSems = Set.new
    sems.each do |s|
      year = stripYear(s.semester)
      uniqSems << year
    end
    return uniqSems.length()
  end
  helper_method :getYears


  def getNumDue()
    return @dueStudents.length
  end
  helper_method :getNumDue

### for getting all the students due for practice as per the course
  def getStudentsDueCourse(course)

    course_ids = Course.where(course_name: course.course_name, teacher: current_user.email).pluck(:id)
    student_ids = StudentCourse.where(course_id: course_ids).pluck(:student_id)
    due_students = Student.where(id: student_ids).getDue(current_user.email)
    return due_students.length
  end  
  helper_method :getStudentsDueCourse


  def getDueStudentQuiz()
    path = ""
    if @dueStudents.length > 0
      student = @dueStudents.sample
      return quiz_students_path(student)
    else
      return home_path
    end
  end
  helper_method :getDueStudentQuiz
end
