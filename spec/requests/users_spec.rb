require "rails_helper"
RSpec.describe "Users", type: :request do
    # describe "GET /users" do
    #   it "return a successful response" do
    #     get users_path
    #     expect(response).to have_http_status(:ok)
    #   end
    # end

    describe "POST /users" do
      context "with valid params" do
      end
    end
  end

# require "rails_helper"
# RSpec.describe "Users", type: :request do
#      describe "GET /users" do
#     it "returns a successful response" do
#       get users_path

#       expect(response).to have_http_status(:ok)
#     end
#   end

#     describe "POST /users" do
#     context "with valid params" do
#       let(:params) do
#         {
#           user: {
#             name: "Virendra",
#             email: "virendra@example.com"
#           }
#         }
#       end

#       it "creates a user and redirects" do
#         expect {
#           post users_path, params: params
#         }.to change(User, :count).by(1)

#         expect(response).to have_http_status(:redirect)
#       end
#     end
#       context "with invalid params" do
#       let(:params) do
#         {
#           user: {
#             name: "",
#             email: ""
#           }
#         }
#       end

#       it "does not create a user" do
#         expect {
#           post users_path, params: params
#         }.not_to change(User, :count)
#       end

#       it "returns unprocessable entity status" do
#         post users_path, params: params

#         expect(response).to have_http_status(:unprocessable_entity)
#       end
#     end
#   end
#   describe "PATCH /users/:id" do
#     let!(:user) do
#       User.create!(
#         name: "Old Name",
#         email: "old@example.com"
#       )
#     end

#     context "with valid params" do
#       it "updates the user and redirects" do
#         patch user_path(user), params: {
#           user: { name: "New Name" }
#         }

#         expect(response).to have_http_status(:redirect)
#         expect(user.reload.name).to eq("New Name")
#       end
#     end
#     context "with invalid params" do
#     it "does not update the user" do
#       patch user_path(user), params: {
#         user: { email: "bad-email" }
#       }

#       expect(response).to have_http_status(:unprocessable_entity)
#       expect(user.reload.email).to eq("old@example.com")
#     end
#   end
#   end
# end
