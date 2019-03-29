class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authentification, only[:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: { message: "User details by user_id", user: disp_user }
  end

  def signup
    @user = User.new(user_params)

    if @user.save
      render json: { message: "Account successfully created", users: disp_user }
    elsif User.find_by(user_id: @user&.user_id).present?
      render json: { message: "Account creation failed", cause: "already same user_id is used" }
    else
      render json: { message: "Account creation failed", cause: "required user_id and password" }
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

    def disp_user
      res = {user_id: @user.user_id}
      if @user.nickname.present?
        res.merge!(nickname: @user.nickname)
      else
        res.merge!(nickname: @user.user_id)
      end
      if @user.comment
        res.merge!(comment: @user.comment)
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(user_id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.fetch(:user, {})
    end

    def authentification
      if request.headers[:Authorization] == Base64.encode64(@user.user_id + ':' + @user.password)
        render json: { "message":"Authentication Faild" }
        return
      end
    end
end
