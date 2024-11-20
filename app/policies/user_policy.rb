class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    record.kept? && record.id == user.id
  end

  def destroy?
    record.kept? && record.id != user.id
  end

  def restore?
    record.discarded? && record.id != user.id
  end

  def lock?
    record.kept? && !record.locked_at? && record.id != user.id
  end

  def unlock?
    record.kept? && record.locked_at? && record.id != user.id
  end
end
