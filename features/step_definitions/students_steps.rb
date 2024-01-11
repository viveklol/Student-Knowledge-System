  When('I go to the students page') do
    visit students_path()
    expect(page).to have_content("New student")
  end

  Then('I select {string} under semester') do |string|
    find("#selected_semester").select(string)
  end

  Then('I submit the form') do
    find("[value='Filter Students List']").click
    expect(page).to have_content("Kunal")
  end

  When('I click the student row') do
    first_student_row = first("tr[data-href^='/students/']")
    student_profile_path = first_student_row['data-href']
    visit student_profile_path
  end

  When('I fill in student {string} with {string}') do |string, string2|
    fill_in "student[#{string}]", with: string2
    expect(find_field("student[#{string}]").value).to eq(string2)
  end
  
  When('I select {string} under tag') do |string|
    find("#selected_tag").select(string)
    expect(find("#selected_tag").value).to eq(string)
  end

  When('I fill in the first student course {string} with {string}') do |string, string2|
    # fill_in "student_course[#{string}]", with: string2
    all("input[name='student_course[#{string}]']").first.fill_in with: string2
  end

  When('I visit the students page') do
    visit students_path()
  end

  When('I enter "Search by Name" with {string}') do |name|
    fill_in 'Search by Name', with: name
  end

  Then('I find student {string}') do |text|
    expect(page).to have_content(text)
  end
  
  Then('I do not find student {string}') do |text|
    expect(page).not_to have_content(text)
  end

  Then('I click on the student row to visit student profile page') do
    first_student_row = first("tr[data-href^='/students/']")
    student_profile_path = first_student_row['data-href']
    visit student_profile_path
  
    expect(page.current_path).to include(student_profile_path)
  end


  