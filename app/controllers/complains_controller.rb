class ComplainsController < ApplicationController
  before_action :set_complain, only: [:show, :edit, :update, :status_transitions, :destroy]

  # GET /complains
  # GET /complains.json
  def index
    @datatable = ComplainsDatatable.new view_context
  end

  def search
    render json: ComplainsDatatable.new(view_context)
  end


  # GET /complains/1
  # GET /complains/1.json
  def show
  end

  # GET /complains/new
  def new
    @complain = Complain.new(
        customer_id: params[:customer_id],
        )
    duedate = DateTime.now.end_of_day + 1.day
    @complain.due_by = duedate.strftime('%d-%b-%y %H:%M')
  end

  # GET /complains/1/edit
  def edit
  end

  # POST /complains
  # POST /complains.json
  def create
    @complain = Complain.new(complain_params.merge(
        created_by: current_user,
        ))
    if @complain.save
      flash[:notice] = '@complain is created successfully. '
    else
      flash.now[:alert] = @complain.errors.full_messages.first
    end
  end

  # PATCH/PUT /complains/1
  # PATCH/PUT /complains/1.json
  def update
    respond_to do |format|
      if @complain.update complain_params
        notice = if params[:complain][:status_event] != Constant.TICKET_EVENTS[:EDIT]
                   "Ticket #{@complain.status} successfully."
                 else
                   'Ticket updated successfully.'
                 end
        if @complain.errors.present?
          notice += @complain.errors.full_messages.to_sentence
          format.html { redirect_to @complain, alert: notice }
          format.js { flash.now[:alert] = notice }
          format.json { render json: { message: notice, data: @complain.for_api } }
        else
          format.html { redirect_to @complain, notice: notice }
          format.js { flash.now[:notice] = notice }
          format.json { render json: { message: notice, data: @complain.for_api } }
        end
      else
        alert = @complain.errors.full_messages.first
        format.html { redirect_to @complain, alert: alert }
        format.js { flash.now[:alert] = "Can't update. #{alert}" }
        format.json { render json: { error_message: alert, error_status: :unprocessable_entity }, status: :unprocessable_entity }
      end
    end
  end

  def status_transitions
    render template: 'layouts/audit_trail', locals: { status_transitions: @complain.complain_status_transitions.order("id desc") }, layout: false
  end

  # DELETE /complains/1
  # DELETE /complains/1.json
  def destroy
    @complain.destroy
    respond_to do |format|
      format.html { redirect_to complains_url, notice: 'Complain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_complain
      @complain = Complain.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def complain_params
      params.require(:complain).permit(
          *Complain::FIELDS
      ).merge(
          updated_from_ip: request.remote_ip,
          updated_by: current_user,
          )
    end
end
