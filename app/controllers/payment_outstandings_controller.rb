class PaymentOutstandingsController < ApplicationController
  before_action :set_payment_outstanding, only: [:show, :edit, :update, :destroy]

  # GET /payment_outstandings
  # GET /payment_outstandings.json
  def index
    @payment_outstandings = PaymentOutstanding.all
  end

  # GET /payment_outstandings/1
  # GET /payment_outstandings/1.json
  def show
  end

  # GET /payment_outstandings/new
  def new
    @payment_outstanding = PaymentOutstanding.new
  end

  # GET /payment_outstandings/1/edit
  def edit
  end

  # POST /payment_outstandings
  # POST /payment_outstandings.json
  def create
    @payment_outstanding = PaymentOutstanding.new(payment_outstanding_params)

    respond_to do |format|
      if @payment_outstanding.save
        format.html { redirect_to @payment_outstanding, notice: 'Payment outstanding was successfully created.' }
        format.json { render :show, status: :created, location: @payment_outstanding }
      else
        format.html { render :new }
        format.json { render json: @payment_outstanding.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_outstandings/1
  # PATCH/PUT /payment_outstandings/1.json
  def update
    respond_to do |format|
      if @payment_outstanding.update(payment_outstanding_params)
        format.html { redirect_to @payment_outstanding, notice: 'Payment outstanding was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_outstanding }
      else
        format.html { render :edit }
        format.json { render json: @payment_outstanding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_outstandings/1
  # DELETE /payment_outstandings/1.json
  def destroy
    @payment_outstanding.destroy
    respond_to do |format|
      format.html { redirect_to payment_outstandings_url, notice: 'Payment outstanding was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_outstanding
      @payment_outstanding = PaymentOutstanding.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_outstanding_params
      params.require(:payment_outstanding).permit(:customer_id, :amount, :due_date, :status)
    end
end
