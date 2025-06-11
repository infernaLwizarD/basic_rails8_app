class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      # if user.admin_role?
      #   scope.all
      # else
      #   scope.by_state('active')
      # end
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.admin_role?
  end

  def update?
    (record.kept? && user.admin_role?) || record.id == user.id
  end

  def destroy?
    record.kept? && user.admin_role? && record.id != user.id
  end

  def restore?
    record.discarded? && user.admin_role? && record.id != user.id
  end

  def lock?
    record.kept? && !record.locked_at? && user.admin_role? && record.id != user.id
  end

  def unlock?
    record.kept? && record.locked_at? && user.admin_role? && record.id != user.id
  end
end
