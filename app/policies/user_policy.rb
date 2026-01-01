class UserPolicy
  attr_reader :current_user, :record
  def initialize(current_user, record)
    @current_user = current_user
    @record =  record
  end
  def index?
    current_user.present?
  end
  def create?
    current_user.admin?
  end
  def update?
    current_user.admin? || own_record?
  end
  def destroy?
    current_user.admin?
  end
  private
  def own_record?
    current_user == record
  end
end
