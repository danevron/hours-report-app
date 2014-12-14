class SessionsController < ApplicationController

  def create
    user = User.from_auth(omnihash) || User.create_from_auth(omnihash)

    redirect_to login_path, :alert => "You are not invited!" if user.not_invited?

    if user.new_record?
      user_invitation = Invitation.find_by(:recipient => user.email)
      user.employee_number = user_invitation.employee_number
      user.tenbis_number = user_invitation.tenbis_number
    end

    if user.save
      session[:user_id] = user.id
      mixpanel_people_set("$first_name" => user.first_name,
                          "$last_name" => user.last_name,
                          "$email" => user.email,
                          "10Bis number" => user.tenbis_number,
                          "Employee number" => user.employee_number
      )
      redirect_to user, notice: "Signed in!"
    else
      raise "Failed to login"
    end
  end

  def new
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

  private

  def omnihash
    request.env["omniauth.auth"]
  end
end
