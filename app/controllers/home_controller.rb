class HomeController < ApplicationController
  skip_before_action :require_account!, only: [ :index ]
  def index
  end
end
