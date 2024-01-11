require 'rails_helper'

RSpec.describe StudentCoursesController, type: :controller do
  before do
    @user = User.create(email: 'student@gmail.com', confirmed_at: Time.now)
    allow(controller).to receive(:current_user).and_return(@user)

    @course = Course.create(course_name: "CSCE 411", teacher: 'student@gmail.com', section: '501', semester: 'Spring 2023')

    @student = Student.create(
      firstname: 'Zebulun',
      lastname: 'Oliphant',
      uin: '734826482',
      email: 'zeb@tamu.edu',
      classification: 'U2',
      major: 'CPSC',
      teacher: 'student@gmail.com',
      last_practice_at: Time.now,
      curr_practice_interval: '15'
    )

    @student_course = StudentCourse.create(student_id: @student.id, course_id: @course.id, final_grade: 'B') # Assuming you have a 'final_grade' attribute in StudentCourse
  end

  describe 'PATCH #update' do
    it 'updates the student course and redirects to the student' do
      patch :update, params: { id: @student_course.id, student_course: { final_grade: 'A' } }

      expect(response).to redirect_to(student_url(@student))
      expect(flash[:notice]).to eq('Student information was successfully updated.')
    end

    it 'renders edit template on failure' do
      allow_any_instance_of(StudentCourse).to receive(:update).and_return(false)

      patch :update, params: { id: @student_course.id, student_course: { final_grade: 'A' } }

      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the student course and redirects to the student' do
      delete :destroy, params: { id: @student_course.id }

      expect(response).to redirect_to(student_url(@student))
      expect(flash[:notice]).to eq('Given student in a course is deleted.')
    end
  end
end
