class UsersController < ApplicationController

    @hide_header = true
    
    def new
        @user = User.new
    end

    def create 
        @user = User.new user_params

        if @user.save
            redirect_to root_path, notice: "Your account has been created. Please sign in."
        else
            redirect_to root_path, notice: "Your account already exists. Please sign in."
        end 
    end

    private

        def user_params
            params.require(:user).permit(:username, :email)
        end 
end 