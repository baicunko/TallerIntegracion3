class HolaController < Devise::RegistrationsController	
  before_action :authenticate_user!
  def new
    super
  end

  def create
    # add custom create logic here
    puts "hola"
  end

  def update
    super
  end
end