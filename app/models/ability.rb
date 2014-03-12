class Ability
  include CanCan::Ability

  def initialize(user)

    # student role
    if user.has_role? :student
      can :crud, Enrollment
    end

    # admin role
    if user.has_role? :admin
        can :manage, :all
    end
end


end
