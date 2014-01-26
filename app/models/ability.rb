class Ability
  include CanCan::Ability

  def initialize(user)

    # basic user role
    if user_signed_in?

        # student role
        if current_user.has_role? :student

        end

        # admin role
        if current_user.has_role? :admin
            can :manage, :all
        end

  end

end
