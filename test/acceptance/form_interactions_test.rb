require 'acceptance_helper'

class TestFormInteractions < AcceptanceTestCase
  def setup
    MountableFileServer.configure do |config|
      config.base_url = "/uploads"
    end

    User.destroy_all
  end

  def test_upload_client_side_interaction
    visit "/users/new"
    attach_file("Avatar url", fixture_path('david.jpg'))

    sleep 0.1

    assert_match(/public-.*.jpg/, find('.js-mountable-file-server-input input[type=hidden]', visible: false).value)
    assert has_content?("Upload started.")
    assert has_content?("Upload succeeded.")
  end

  def test_upload
    visit "/users/new"
    fill_in "Name", with: "David"
    attach_file "Avatar url", fixture_path('david.jpg')

    sleep 0.1

    click_button "Create User"

    visit find("img")[:src]

    assert_equal 200, page.status_code
    assert_match(/^image\//, page.response_headers['Content-Type'])
  end

  def test_remove_upload
    visit "/users/new"
    fill_in "Name", with: "David"
    attach_file "Avatar url", fixture_path('david.jpg')

    sleep 0.1

    click_button "Create User"

    visit "/users"
    click_link "Destroy"

    assert_equal 200, page.status_code
  end
end
