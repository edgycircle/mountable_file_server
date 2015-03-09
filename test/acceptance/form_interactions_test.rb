require 'acceptance_helper'

class TestFormInteractions < AcceptanceTestCase
  def test_form_helper_adds_markup
    visit "/users/new"

    assert find('.mountable-file-server-input')
  end

  def test_form_helper_adds_hidden_field_after_file_input
    visit "/users/new"

    inputs = all('input[name="user[avatar_url]"]', visible: false)

    assert_equal 2, inputs.size
    assert_equal 'file', inputs[0][:type]
    assert_equal 'hidden', inputs[1][:type]
  end

  def test_upload_client_side_interaction
    visit "/users/new"
    attach_file("Avatar url", path('david.jpg'))

    sleep 0.1

    assert_match /public-.*.jpg/, find('.mountable-file-server-input input[type=hidden]', visible: false).value
    assert has_content?("Upload started.")
    assert has_content?("Upload succeeded.")
  end

  def test_upload
    visit "/users/new"
    fill_in "Name", with: "David"
    attach_file "Avatar url", path('david.jpg')

    sleep 0.1

    click_button "Create User"

    visit find("img")[:src]

    assert_equal 200, page.status_code
    assert_match /^image\//, page.response_headers['Content-Type']
  end
end
