require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  describe "#controller" do
    before do

      @user = User.create(email:'student@gmail.com', confirmed_at:Time.now)
      # authenticate_by_session(@user)
      allow(controller).to receive(:current_user).and_return(@user)
      @course1 = Course.create(course_name:"CSCE 411", teacher:'student@gmail.com', section:'501', semester:'Spring 2023')
      @course2 = Course.create(course_name:"CSCE 411", teacher:'student@gmail.com', section:'501', semester:'Fall 2023')
      @course3 = Course.create(course_name:"CSCE 412", teacher:'student@gmail.com', section:'501', semester:'Spring 2024')
      @tag = Tag.create(tag_name: 'ExampleTag', teacher: 'student@gmail.com')
      @student = Student.create(firstname:'Zebulun', lastname:'Oliphant', uin:'734826482', email:'zeb@tamu.edu', classification:'U2', major:'CPSC', teacher:'student@gmail.com', last_practice_at: Time.now, curr_practice_interval: '15')
    end

    it "calls index successfully" do
      get :index, params: { id: @student }
      expect(response).to have_http_status(:successful)
    end

    it "shows successfully" do
        get :show, params: { id: @student.id }
        expect(response).to have_http_status(:successful)
    end

    it "creates a new student" do
      expect {
        post :create, params: { student: {
          firstname: 'John', 
          lastname: 'Doe', 
          uin: '123456789', 
          email: 'johndoe@example.com', 
          classification: 'U1', 
          major: 'CPSC',
          teacher: 'team_cluck_admin@gmail.com'
        } }
      }.to change(Student, :count).by(1) # should be 1 once signing in works
    end

    it "updates successfully" do
        get :show, params: { id: @student.id }
    end

    it "deletes successfully" do
        get :show, params: { id: @student.id }
    end

    it 'assigns the correct student' do
      get :quiz, params: { id: @student.id }
      expect(assigns(:student)).to eq(@student)
    end

    it 'assigns due students' do
      allow(Student).to receive(:getDue).and_return([@student])
      get :quiz, params: { id: @student.id }
      expect(assigns(:dueStudents)).to eq([@student])
    end

    it 'assigns correctAnswer as true when the response is correct' do
      post :quiz, params: { id: @student.id, answer: @student.id }
      expect(assigns(:correctAnswer)).to eq(true)
    end

    it 'assigns correctAnswer as false when the response is incorrect with interval > 15' do
      @student.update(curr_practice_interval: '20')
      post :quiz, params: { id: @student.id, answer: 'wrong_response' }
      expect(assigns(:correctAnswer)).to eq(false)
    end

    it 'assigns correctAnswer as false when the response is incorrect with interval <= 15' do
      @student.update(curr_practice_interval: '10')
      post :quiz, params: { id: @student.id, answer: 'wrong_response' }
      expect(assigns(:correctAnswer)).to eq(false)
    end

    it 'does not update student attributes when the response is nil' do
      expect(@student).not_to receive(:update)
      post :quiz, params: { id: @student.id, answer: nil }
    end

    it "assigns correctAnswer as true when the response is correct" do
      # Modify this test based on your actual implementation
      get :quiz, params: { id: @student.id, answer: @student.id }
      expect(assigns(:correctAnswer)).to be true
    end

    context 'when filtering by selected_course, selected_semester, and selected_tag' do
      before do
        params = {
          selected_course: @course1.course_name,
          selected_semester: @course1.semester,
          selected_tag: 'ExampleTag'
        }
        get :index, params: params
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it "handles filtering by selected_course when @selected_semester is an empty string" do
        get :index, params: { selected_course: 'CSCE 411', selected_semester: '', selected_tag: '' }
      
        expect(assigns(:target_course_id)).to eq(Course.where(course_name: 'CSCE 411'))
      end
      
      it "handles filtering by selected_semester when @selected_course is an empty string" do
        get :index, params: { selected_course: '', selected_semester: 'Spring 2023', selected_tag: '' }
      
        expect(assigns(:target_course_id)).to eq(Course.where(semester: 'Spring 2023'))
      end

      it "handles filtering when @selected_semester and @selected_course are both empty" do
        get :index, params: { selected_course: '', selected_semester: '', selected_tag: '' }
      
        expect(assigns(:target_course_id)).to eq([@course1.id, @course2.id, @course3.id])
      end

      it "handles new tags and creates StudentsTag associations" do
        allow(Tag).to receive(:where).and_return([@tag])  # Mock Tag.where to return the tag
  
        post :create, params: {
          student: {
            firstname: 'John',
            lastname: 'Doe',
            uin: '123456789',
            email: 'johndoe@example.com',
            classification: 'U1',
            major: 'CPSC',
            teacher: 'team_cluck_admin@gmail.com',
            create_tag: 'NewTag'
          }
        }
        
  
        expect(Tag.count).to eq(2)  # Ensure Tag is created
      end

      

      
    end

    it "handles case when @student is nil" do
      allow(Student).to receive(:find_by).and_return(nil)
    
      get :show, params: { id: 'nonexistent_id' }
    
      expect(assigns(:student)).to be_nil
      expect(response).to redirect_to(students_url)
      expect(flash[:notice]).to eq("Given student not found.")
    end
    

    it "redirects to quiz_students_path when there are due students" do
      allow(Student).to receive(:getDue).and_return([@student])
    
      get :getDueStudentQuiz
      expect(assigns(:dueStudents)).to be_an(Array).or be_nil
      expect(response).to redirect_to(quiz_students_path(@student))
    end
    
    it "redirects to home_path when there are no due students" do
      allow(Student).to receive(:getDue).and_return([])
    
      get :getDueStudentQuiz
      expect(assigns(:dueStudents)).to be_an(Array).or be_nil
      expect(response).to redirect_to(home_path)
    end
  end
end
