# app/services/users/create.rb
module Users
  class Create
    def initialize(params)
      @params = params
    end

    def call
      # user = User.new(@params)

      # begin
      #   ActiveRecord::Base.transaction do
      #     user.save!

      #     # workflow concern: confirmation
      #     # user.generate_confirmation!
      #     # user.regenerate_confirmation!
      #     user.generate_confirmation!
      #     # UserMailer.email_confirmation(user).deliver_later
      #   end

      #   # IMPORTANT: email after commit
      #   UserMailer.email_confirmation(user).deliver_later

      # rescue ActiveRecord::RecordNotUnique
      #   user.errors.add(:email, "has already been taken")
      # end

      # user
      user = User.new(@params)

      if user.save
        user.regenerate_confirmation!
        UserMailer.email_confirmation(user).deliver_later
      end

      user
    end
  end
end




# module Users
#   class Create
#     def initialize(params)
#       @params = params
#     end

#     def call
#       user = User.new(@params)
#       # return user unless user.save

#       begin
#         user.save!
#         # Users::Create
#         Rails.logger.info "Sending confirmation email to #{user.email}"
#         UserMailer.email_confirmation(user).deliver_later
#       rescue ActiveRecord::RecordNotUnique
#         user.errors.add(:email, "has already been taken")
#       end

#       user
#     end
#   end
# end
