module Users
  class UpdateRole
    def initialize(user, role)
      @user = user
      @role = role
    end

    def call
      return false unless User.roles.key?(@role)
      @user.update(role: @role)
    end
  end
end
