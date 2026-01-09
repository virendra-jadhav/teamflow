class ApplicationPolicy
  attr_reader :user, :record, :account

  def initialize(context, record)
    @user   = context.user     # current_user
    @record = record   # model or class
    @account = context.account
  end

    class Scope
    attr_reader :context, :scope

    def initialize(context, scope)
      @context  = context
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve"
    end
    end
end
