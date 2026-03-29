require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "honeypot filled in redirects to root without creating a player" do
    assert_no_difference "Player.count" do
      post registration_path, params: {
        name: "Bot",
        email_address: "bot@example.com",
        password: "password",
        password_confirmation: "password",
        website: "http://spam.example.com"
      }
    end
    assert_redirected_to root_path
  end

  test "honeypot empty allows registration" do
    assert_difference "Player.count" do
      post registration_path, params: {
        name: "Real User",
        email_address: "real@example.com",
        password: "password",
        password_confirmation: "password",
        website: ""
      }
    end
    assert_redirected_to root_path
  end
end
