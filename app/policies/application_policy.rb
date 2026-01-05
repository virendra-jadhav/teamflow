class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user     # current_user
    @record = record   # model or class
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve"
    end
  end
end
