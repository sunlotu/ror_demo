module Roleable
  extend ActiveSupport::Concern

  included do
    has_one :role_ship
    has_one :role, through: :role_ship

    scope :by_role, ->(role) { joins(role_ship: :role).where(roles: { code: "#{role}.to_s" }) }

    include InstanceMethods

  end

  module InstanceMethods
    %w(code name).each do |cond|
      class_eval(<<-EOF, __FILE__, __LINE__+1)
        def role_#{cond}
          role.send("#{cond}") if role
        end
      EOF
    end

    def admin?
      role.code == 'admin'
    end

    def user?
      role.code == 'user'
    end
  end



end