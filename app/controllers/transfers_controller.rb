class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :destroy]

  # GET /transfers
  def index
    @transfers = Transfer.all

    render json: @transfers, each_serializer: TransferSerializer
  end

  # GET /transfers/1
  def show
    render json: @transfer, serializer: TransferSerializer
  end

  # POST /transfers
  def create
    @transfer = Transfer.new(transfer_params)

    if @transfer.save
      render json: @transfer, status: :created, location: @transfer, serializer: TransferSerializer
    else
      render json: @transfer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transfers/1
  def destroy
    @transfer.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transfer_params
      params.require(:transfer).permit(:account_id, :destination_account_id, :amount)
    end
end
