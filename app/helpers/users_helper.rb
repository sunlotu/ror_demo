module UsersHelper
  def role_options(selected=nil)
    options_for_select(Role.all.collect { |p| [ p.name, p.id ] }, selected)
  end
end
