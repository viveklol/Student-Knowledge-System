require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
    before do
        email = 'student@gmail.com'
        @user = User.create(email: email, confirmed_at:Time.now)
        
        allow(controller).to receive(:current_user).and_return(@user)

        @course1 = Course.create(course_name:"CSCE 411", teacher:'student@gmail.com', section:'501', semester:'Fall 2022')
        @course2 = Course.create(course_name:"CSCE 411", teacher:'student@gmail.com', section:'501', semester:'Spring 2023')
        @course3 = Course.create(course_name:"CSCE 412", teacher:'student@gmail.com', section:'501', semester:'Spring 2023')
        
        
        @student1 = Student.create(firstname:'Zebulun', lastname:'Oliphant', uin:'734826482', email:'zeb@tamu.edu', classification:'U2', major:'CPSC', teacher:'student@gmail.com')
        @student2 = Student.create(firstname:'Batmo', lastname:'Biel', uin:'274027450', email:'speedwagon@tamu.edu', classification:'U1', major:'CPSC', teacher:'student@gmail.com')
        @student3 = Student.create(firstname:'Ima', lastname:'Hogg', uin:'926409274', email:'piglet@tamu.edu', classification:'U1', major:'CPSC', teacher:'student@gmail.com')
        @student4 = Student.create(firstname:'Joe', lastname:'Mama', uin:'720401677', email:'howisjoe@tamu.edu', classification:'U1', major:'CPSC', teacher:'student@gmail.com')
        @student5 = Student.create(firstname:'Sheev', lastname:'Palpatine', uin:'983650274', email:'senate@tamu.edu', classification:'U1', major:'CPSC', teacher:'student@gmail.com')

        StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2022', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: '100')
        StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2022', section: '501').id, student_id: Student.find_by(uin: '926409274').id, final_grade: "")
        StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '274027450').id, final_grade: "")
        StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '720401677').id, final_grade: "")
        StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: "")
        StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '983650274').id, final_grade: "")

        @tag1 = Tag.create(tag_name: "is cool", created_at: Time.now, updated_at: Time.now, teacher: @user.email)
        StudentsTag.create(student_id: @student1.id, tag_id: @tag1.id, created_at: Time.now, updated_at: Time.now, teacher: @user.email)
    end

    describe "#index" do
        context "when searching for a course" do
            before do
                get :index, params: { search_course: "CSCE 411" }
            end

            it "assigns @courses with the matching course and its details" do
              # expect(controller.current_user).to eq(@user)
              # puts "accessed controller with session"
              # puts "current_user: #{current_user.inspect}"
              # puts "@user: #{@user.inspect}"  
              
              #   puts "course1: #{@course1.inspect}"
              #   puts "course2: #{@course2.inspect}"
                expect(assigns(:courses_db_result)).to match_array([@course1, @course2])
            end
        end

        context "when searching for a student" do
            before do
                get :index, params: { search_student: "Zebulun" }
            end

            it "assigns @courses with the courses the student is enrolled in and their details" do
                expect(assigns(:courses_db_result)).to match_array([@course1, @course3])
            end
        end

        context "when searching for a semester" do
            before do
                get :index, params: { search_semester: "Spring 2023" }
            end

            it "assigns @courses with the courses in the semester and their details" do
                expect(assigns(:courses_db_result)).to match_array([@course2, @course3])
            end

        end

        context "no results exist for search semester" do
            before do
                get :index, params: { search_student: "" }
            end

            it "assigns @courses with the courses in the semester and their details" do
                expect(assigns(:courses_db_result).length).to eq(0)
            end
        end

        context "no results exist for search student" do
            before do
                get :index, params: { search_course: "" }
            end

            it "assigns @courses with the courses the student is enrolled in and their details" do
                expect(assigns(:courses_db_result).length).to eq(0)
            end
        end

        context "no results exist for search semester" do
            before do
                get :index, params: { search_semester: "" }
            end

            it "assigns @courses with the matching course and its details" do
                expect(assigns(:courses_db_result).length).to eq(0)
            end
        end

        
    end
    

    describe "GET #show" do

        it "assigns all_course_ids, student_ids, tags, semesters, sections and student_records" do
            get :show, params: { id: @course1.id }
            expect(assigns(:all_course_ids)).to include(@course1.id)
            expect(assigns(:student_ids)).to include(@student1.id)
            expect(assigns(:tags)).to be_an_instance_of(Set)
            expect(assigns(:semesters)).to be_an_instance_of(Set)
            expect(assigns(:sections)).to be_an_instance_of(Set)
            expect(assigns(:student_records)).to be_an_instance_of(Array)
        end


              it "assigns filtered student_records based on dropdown menu selections" do

            get :show, params: { id: @course1.id, selected_tag: "is cool" }
            expect(assigns(:student_ids).count).to eq(0)
        end

        it "sorts the list of students based on sort order" do

            get :show, params: { id: @course1.id, sortOrder: "Alphabetical" }
            expect(assigns(:student_records).first.records.first.lastname).to eq("Biel")

            get :show, params: { id: @course1.id, sortOrder: "Reverse Alphabetical" }
            expect(assigns(:student_records).first.records.first.lastname).to eq("Oliphant")
        end

        context 'when the course is not found' do
          it 'redirects to courses_url with a notice for HTML format' do
            get :show, params: { id: 'nonexistent_course_id' }
            expect(response).to redirect_to(courses_url)
            expect(flash[:notice]).to eq('Given course not found.')
          end
        
          it 'returns a JSON response with no content for JSON format' do
            get :show, params: { id: 'nonexistent_course_id' }, format: :json
            expect(response).to have_http_status(:no_content)
            expect(response.body).to be_blank
          end
        end

        # context "when populating student_records_hash" do
        #   before do
        #     @test_course = Course.create(course_name: "Test Course", teacher: 'student@gmail.com', section: '101', semester: 'Fall 2023')
        #     @test_student = Student.create(firstname: 'John', lastname: 'Doe', uin: '123456789', email: 'john.doe@example.com', classification: 'U1', major: 'CS', teacher: 'student@gmail.com')
        #     @student_records = [@test_student]
        #   end
        
        #   it "populates student_records_hash with the correct entries" do
        #     get :show, params: { id: @test_course.id }
        
        #     # Debugging output to inspect the content of student_records_hash
        #     puts "DEBUG: #{assigns(:student_records_hash).inspect}"
        
        #     student_entry = assigns(:student_records_hash)[@test_student.uin]
            
        #     # Debugging output to inspect the value of student_entry
        #     puts "DEBUG student_entry: #{student_entry.inspect}"
        
        #     # Check that student_entry is not nil
        #     expect(student_entry).not_to be_nil
        
        #     # Check that student_entry is an instance of StudentEntries
        #     expect(student_entry).to be_an_instance_of(StudentEntries)
        
        #     # Check if student_entry has records
        #     expect(student_entry.records).not_to be_nil
        
        #     # Check that records include @test_student
        #     expect(student_entry.records).to include(@test_student)
        
        #     # Continue with other expectations...
        #   end
        # end


        

    end

    describe "GET #new" do
    it "assigns a new Course to @course" do
      get :new
      expect(assigns(:course)).to be_a_new(Course)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: @course1.id }
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new course" do
        expect {
          post :create, params: { course: { course_name: "CSCE 421", teacher:'student@gmail.com', section:'501', semester:'Fall 2022'} }
        }.to change(Course, :count).by(1)
      end

      it "redirects to the new course" do
        post :create, params: { course: { course_name: "CSCE 421", teacher:'student@gmail.com', section:'501', semester:'Fall 2022' } }
        expect(response).to redirect_to(course_path(assigns[:course]))
      end
    end

    context "when archiving a course" do
      it "should archive the course" do
       
        @course4 = Course.create(course_name:"CSCE 606", teacher:'yetchy@gmail.com', section:'501', semester:'Spring 2023', archived: false)

        post :archive, params: { id: @course4.id }
    
        # Reload the course from the database to get the updated value
        @course4.reload
    
        expect(@course4.archived).to be(true)
      end
    end

    context "when unarchiving a course" do
      it "should unarchive the course" do
        #archiving the course before unarchiving
        @course5 = Course.create(course_name:"CSCE 666", teacher:'yetchy@gmail.com', section:'501', semester:'Spring 2023', archived:true)
        # Reload the course from the database to get the updated value
        post :unarchive, params: { id: @course5.id }
        @course5.reload
        expect(@course5.archived).to be(false)
      end
    end

    describe 'POST #create' do
      context 'with valid parameters, including course code selection' do
        it 'creates a new course with the selected course code' do
          post :create, params: {
            course: {
              course_name:"ENGR 600", teacher:'yetchy@gmail.com', section:"123", semester:'Fall 2023', archived:true
              # Add other required parameters
            }
          }

          # Add your expectations, such as checking if the course is created
          expect(response).to redirect_to(course_path(assigns[:course]))
          expect(flash[:notice]).to eq('Course was successfully created.')

          # You can also check if the course was created with the correct course code
          new_course = Course.last
          expect(new_course.course_name).to eq('ENGR 600')
          expect(new_course.section).to eq(123)
          expect(new_course.semester).to eq('Fall 2023')

          # Add a new expectation to check if the course_temp attribute is correctly set
          # expect(new_course.course_temp).to eq('ENGR 600') # Assuming that 'ENGR 600' maps to the course_temp attribute in your model
        end
      end
    end


    



  describe "PATCH #update" do
    context "with valid params" do
      it "updates the requested course" do
        patch :update, params: { id: @course1.id, course: { course_name: "CSCE 431" } }
        @course1.reload
        expect(@course1.course_name).to eq("CSCE 431")
      end

      it "redirects to the updated course" do
        patch :update, params: { id: @course2.id, course: { course_name: "CSCE 431" } }
        expect(response).to redirect_to(course_path(assigns[:course]))
      end
    end

      #it "renders the edit template" do
       # patch :update, params: { id: @course3.id, course: { course_name: "CSCE 431" } }
        #expect(response).to render_template :edit
      #end


    end
  end

  describe "DELETE #destroy" do
    it "deletes the course" do
        expect {
          delete :destroy, params: { id: @course1.id }
        }.to change(Course, :count).by(-1)
      end
  
      it "deletes all student_course records associated with the course" do
        expect {
          delete :destroy, params: { id: @course1.id }
        }.to change(StudentCourse, :count).by(-2)
      end
  
      it "redirects to courses_url" do
        delete :destroy, params: { id: @course1.id }
        expect(response).to redirect_to(courses_url)
      end
  
      it "displays a success notice" do
        delete :destroy, params: { id: @course1.id }
        expect(flash[:notice]).to eq("Course and its info were successfully deleted.")
      end
  end

  describe '#number_of_students_in_course' do
    it 'returns the correct number of students in the course' do
      expect(@course1.number_of_students_in_course).to eq(0)
      expect(@course2.number_of_students_in_course).to eq(0)
      expect(@course3.number_of_students_in_course).to eq(0)
    end
  end

  describe '#number_of_students_in_course handles a course with no students' do
    it 'returns 0 for a course with no students' do
      empty_course = Course.create(course_name: 'Empty Course', teacher: 'student@gmail.com', section: '101', semester: 'Fall 2022')
      expect(empty_course.number_of_students_in_course).to eq(0)
    end
  end

  describe '#number_of_students_in_course' do
    it 'returns the correct number of students in the course' do
      expect(controller.number_of_students_in_course(@course1.id)).to eq(0)
    end

    it 'handles a course with no students' do
      expect(controller.number_of_students_in_course(@course2.id)).to eq(0)
    end

    it 'handles a non-existent course' do
      expect { controller.number_of_students_in_course(999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
