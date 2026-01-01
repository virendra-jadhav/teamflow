class User < ApplicationRecord
    validates :name, presence: true
    validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

    around_save :handle_unique_email_violation

    enum role: {
        member: "member",
        admin: "admin"
    }
    validates :role, presence: true

    private
    def handle_unique_email_violation
        yield
    rescue ActiveRecord::RecordNotUnique
        error.add(:email, "has already been taken")
        throw(:abort)
    end
end
