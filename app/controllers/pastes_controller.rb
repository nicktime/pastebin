class PastesController < ApplicationController
  before_action :set_paste, only: [:show, :edit, :update, :destroy]

  # GET /pastes
  # GET /pastes.json
  def index
    @pastes = Paste.feed
    @paste = Paste.new
  end

  # GET /pastes/1
  # GET /pastes/1.json
  # GET /pastes/1.text
  def show
    respond_to do |format|
      format.html
      format.json
      format.text { render :text => @paste.content }
      format.any { redirect_to @paste }
    end
  end

  # GET /pastes/new
  def new
    @pastes = Paste.feed
    @paste = Paste.new
  end

  # GET /pastes/1/edit
  def edit
    if !user_signed_in? || @paste.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to :back, alert: 'You are not authorized to edit this paste.' }
      end
    end
  end

  # POST /pastes
  # POST /pastes.json
  # POST /pastes.text
  def create
    @pastes = Paste.feed
    @paste = Paste.new(paste_params)

    if user_signed_in?
      current_user.pastes << @paste
      current_user.save
    end

    respond_to do |format|
      if @paste.save
        format.html { redirect_to @paste, notice: 'Paste was successfully created.' }
        format.json { render action: 'show', status: :created, location: @paste }
        format.text { render :text => url_for(:controller => 'pastes', :action => 'show', :id => @paste.id) }
      else
        format.html { render action: 'index' }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pastes/1
  # PATCH/PUT /pastes/1.json
  def update
    respond_to do |format|
      if @paste.update(paste_params)
        format.html { redirect_to @paste, notice: 'Paste was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pastes/1
  # DELETE /pastes/1.json
  def destroy
    if user_signed_in? && @paste.user_id == current_user.id
      @paste.destroy
      respond_to do |format|
        format.html { redirect_to pastes_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, alert: 'You are not authorized to delete this paste.'}
        #todo json ouput
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_paste
    @pastes = Paste.feed
    @paste = Paste.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def paste_params
    params.require(:paste).permit(:title, :content)
  end
end