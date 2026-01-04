module Users
  class Create
    def initialize(params)
      @params = params
    end

    def call
      user = User.new(@params)
      return user unless user.save

      # Users::Create
      Rails.logger.info "Sending confirmation email to #{user.email}"
      UserMailer.email_confirmation(user).deliver_later
      user
    end
  end
end
