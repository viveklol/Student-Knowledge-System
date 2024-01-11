class Course < ApplicationRecord
  has_many :enrollments
  has_many :students, through: :enrollments
  attribute :archived, :boolean, default: false
  validates :archived, inclusion: { in: [true, false] }

  def number_of_students_in_course
    students.count
  end

  def self.search_course(search, teacher)
    #if search
    #  search_type = Course.where(course_name: search, teacher: teacher).all
    #  if search_type
    #    self.where(id: search_type)
    #  elsif (search_type.length == 0)
    #    @courses_db_result = Course.where(teacher: teacher)
    #  else
    #    @courses_db_result = Course.where(id: 0)
    #  end
    #else
    #  @courses_db_result = Course.where(teacher: teacher)
    #end
    search_type = Course.where(course_name: search, teacher: teacher).presence || Course.none
  
    @courses_db_result = search ? self.where(id: search_type) : Course.where(teacher: teacher)
  end

  

  def self.search_semester(search, teacher)
    if search
      search_type = Course.where(semester: search, teacher: teacher).all
      if search_type
        self.where(id: search_type)
#      elsif (search_type.length == 0)
#        @courses_db_result = Course.where(teacher: teacher)
#      else
#        @courses_db_result = Course.where(id: 0)
      end
    else
      @courses_db_result = Course.where(teacher: teacher)
    end
end

def self.search_student(search, teacher)
  if search
    if search.include?(" ")
    #   student = Student.where(firstname: search.split(" ")[0], lastname: search.split(" ")[1]).all
    # else
    #   student = Student.where(firstname: search).all + Student.where(lastname: search).all
      student = Student.where("lower(firstname) = ? AND lower(lastname) = ?", search.split(" ")[0].downcase, search.split(" ")[1].downcase).all
    else
      student = Student.where("lower(firstname) = ? OR lower(lastname) = ?", search.downcase, search.downcase).all
    
    end
    enrollment = []
    for stud in student do
      puts stud.firstname
      enrollment = enrollment + StudentCourse.where(student_id: stud.id).all
      puts enrollment[0].id
    end
    search_type = []
    for enroll in enrollment do 
      search_type = search_type + Course.where(id: enroll.course_id, teacher: teacher).all
      puts search_type[0]
    end
    @courses_db_result = Course.where(teacher: teacher)
      if search_type
        self.where(id: search_type)
      #elsif (search_type.length == 0)
      #  @courses_db_result = Course.where(teacher: teacher)
      #else
      #  @courses_db_result = Course.none
      end
#    else
#      @courses_db_result = Course.where(teacher: teacher)
  end
end

end