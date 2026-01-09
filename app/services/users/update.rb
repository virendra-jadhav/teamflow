module Users
  class Update
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      return true if @params.empty?

      if @user.update(@params)
        true
      else
        false
      end
    end
  end
end



# module Users
#   class Update
#     def initialize(user, params)
#       @user = user
#       @params = params
#     end

#     def call
#       # return false unless @user.update(@params)

#       # # future extensions:
#       # # AuditLog.create!(...)
#       # # UserUpdatedJob.perform_later(@user.id)

#       # true

#       return true if @params.empty?
#       @user.update(@params)
#     end
#   end
# end
