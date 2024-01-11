When('I visit the new note page for {string}') do |student_name|
    student = Student.find_by(firstname: student_name)
    visit new_student_note_path(student, student_id: student.id)
  end
  
  When('I fill in {string} for {string}') do |note_content, field_name|
    fill_in field_name, with: note_content
  end
  
  When('I press {string}') do |button|
    click_button(button)
  end
  
  Then('I should see {string} from notes_steps') do |message|
    expect(page).to have_content(message)
  end
  
  Then('I should be on the student page for {string} from notes_steps') do |student_name|
    student = Student.find_by(firstname: student_name)
    expect(current_path).to eq(student_path(student))
  end
  