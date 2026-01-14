        require "rails_helper"

        RSpec.describe Users::Create do
          describe "#call" do
            context "with valid params" do
              let(:params) do
                {
                  name: "Virendra",
                  email: "virendra@example.com",
                  password: "password",
                  password_confirmation: "password"
                }
              end

              it "creates a user" do
                result = described_class.new(params).call
                expect(result).to be_persisted
              end

              it "sets the email correctly" do
                result = described_class.new(params).call
                expect(result.email).to eq("virendra@example.com")
              end
            end

            context "with invalid email" do
              let(:params) do
                {
                  name: "Virendra",
                  email: "invalid-email",
                  password: "password",
                  password_confirmation: "password"
                }
              end

              it "does not create a user" do
                result = described_class.new(params).call
                expect(result).not_to be_persisted
              end

              it "adds an email format error" do
                result = described_class.new(params).call
                expect(result.errors[:email]).to be_present
              end
            end
          end
        end
