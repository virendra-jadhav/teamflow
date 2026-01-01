require "rails_helper"

RSpec.describe "User authorization", type: :request do
  let!(:admin) do
    User.create!(
      name: "Admin",
      email: "admin@test.com",
      password: "password",
      password_confirmation: "password",
      role: 'admin'
    )
  end
  let!(:target_user) do 
    User.create!(
      name: "Target",
      email: "target@test.com",
      password: "password",
      password_confirmation: "password",
      role: "member"
    )
  end
  context "as admin" do
    before do 
      post login_path, params: {email: admin.email, password: "password"}
    end
    it "can access users index" do
      get users_path
      expect(response).to have_http_status(:ok)
    end
    it "can update another user" do
      patch user_path(target_user), params: {
        user: {name: "Updated"}
      }
      expect(response).to redirect_to(edit_user_path(target_user))
      expect(target_user.reload.name).to eq("Updated")
    end
  end
  context "as member" do
    before do 
      post login_path, params: {email: member.email, password: "password"}
    end
    it "cannot access users index" do
      get users_path
      expect(response).to have_http_status(:forbidden)
    end
    it "cannot update another user" do
      patch user_path(target_user), params: {
        user: {name: "Hacked"}
      }
      expect(response).to have_http_status(:forbidden)
      expect(target_user.reload.name).not_to eq("Hacked")
    end
  end
  
  
end
