class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy]

  # GET /uploads
  # GET /uploads.json
  def index
    @uploads = Upload.all
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
  end

  def download
    @results = "Total $ Approved:,Business Name,Business Type,Telephone,Street Address,City,Zip Code,County,Employer Identification Number (Federal EIN),Business Identification Number (BIN issued by Oregon Employment Department),NAICS,Contact Name,Title,Phone,Email,Number of Employees,Jobs Retained,Business Demographics,Business Owner Name 1,Business Owner Name 2,Business Owner Name 3,% Ownership 1,% Ownership 2,% Ownership 3,Race 1,Race 2,Race 3,Ethnicity 1,Ethnicity 2,Ethnicity 3,Gender 1,Gender 2,Gender 3"
    send_data(@results, :filename => "headers.csv")
  end

  # GET /uploads/new
  def new
    @upload = Upload.new
  end

  # GET /uploads/1/edit
  def edit
  end

  # POST /uploads
  # POST /uploads.json
  def create
    Company.import(params[:upload][:data].tempfile)
    Application.import(params[:upload][:data].tempfile, params[:upload][:round])
    Owner.import(params[:upload][:data].tempfile)
    params[:upload][:data] = CSV(params[:upload][:data].tempfile).read.join(",")
    @upload = Upload.new(upload_params)

    respond_to do |format|
      if @upload.save
        format.html { redirect_to @upload, notice: 'Upload was successfully created.' }
        format.json { render :show, status: :created, location: @upload }
      else
        format.html { render :new }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploads/1
  # PATCH/PUT /uploads/1.json
  def update
    respond_to do |format|
      if @upload.update(upload_params)
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { render :show, status: :ok, location: @upload }
      else
        format.html { render :edit }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    Application.where(round: @upload.round).destroy_all
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url, notice: 'Upload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def upload_params
      params.require(:upload).permit(:title, :data, :round)
    end
end
