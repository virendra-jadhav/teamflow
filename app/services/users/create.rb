module Users
  class Create
    def initialize(params)
      @params = params
    end

    def call
      user = User.new(@params)
      return user unless user.save
      user
    end
  end
end
