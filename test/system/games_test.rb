require 'application_system_test_case'

class GamesTest < ApplicationSystemTestCase
  test 'visiting /new renders random letters' do
    visit new_url
    assert_selector 'h1', text: 'Random letters'
  end

  test "when click on 'Check' button, obtains an answer" do
    visit new_url
    fill_in 'answer', with: 'hello'
    click_on 'Check'

    assert_text 'Your score'
  end
end
