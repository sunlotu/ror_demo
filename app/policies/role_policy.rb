class RolePolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      end
    end
  end
end