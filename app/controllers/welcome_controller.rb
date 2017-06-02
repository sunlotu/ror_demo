class WelcomeController < ApplicationController
  skip_before_action :ensure_sign_in

  def index
  end
end
