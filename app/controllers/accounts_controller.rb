class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

  def index
    @accounts = Account.all

    render json: @accounts, each_serializer: CompleteAccountSerializer
  end

  def show
    render json: @account, serializer: CompleteAccountSerializer
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      render json: @account, status: :created, location: @account, serializer: SimpleAccountSerializer
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      render json: @account, serializer: CompleteAccountSerializer
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:id, :name, :balance, :access_token)
    end
end
