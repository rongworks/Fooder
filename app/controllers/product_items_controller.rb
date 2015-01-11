class ProductItemsController < ApplicationController
  respond_to :html, :js, :json

  before_action :set_product_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /product_items
  # GET /product_items.json
  def index
    @product_items = current_user.product_items
    @product_items_grid = initialize_grid(@product_items, include: [:product])
    @product_item = ProductItem.new
  end

  # GET /product_items/1
  # GET /product_items/1.json
  def show
  end

  # GET /product_items/new
  def new
    @product_item = ProductItem.new
  end

  # GET /product_items/1/edit
  def edit
  end

  # POST /product_items
  # POST /product_items.json
  def create
    @product_item = ProductItem.check_in(product_item_params[:code],current_user.id)

    respond_to do |format|
      if @product_item.save
        format.html { redirect_to product_items_path, notice: 'Product item was successfully created.' }
        format.json { render :show, status: :created, location: @product_item }
      else
        format.html { render :new }
        format.json { render json: @product_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_items/1
  # PATCH/PUT /product_items/1.json
  def update
    respond_to do |format|
      if @product_item.update(product_item_params)
        format.html { redirect_to @product_item, notice: 'Product item was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_item }
      else
        format.html { render :edit }
        format.json { render json: @product_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_items/1
  # DELETE /product_items/1.json
  def destroy
    @product_item.destroy
    respond_to do |format|
      format.html { redirect_to product_items_url, notice: 'Product item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_check_in
    check_ins = 0
    items = []
    codes = params[:codes]
    codes.each do |code|
      @product_item = ProductItem.check_in(code, current_user.id)
      if @product_item.save
        check_ins += 1
        items << @product_item
      else
        flash[:notice] = "Error on code #{code}, could not check in. #{@product_item.errors.full_messages}"
        puts "Could not save item, #{@product_item.errors.full_messages}"
      end
    end
    respond_with items, status: 200, location: product_items_path

  end

  def bulk_check_out
    check_outs = 0
    items = []
    codes = params[:codes]
    codes.each do |code|
      @product_item = ProductItem.check_out(code, current_user.id)
      if @product_item.save
        check_outs += 1
        items << @product_item
      else
        flash[:notice] = "Error on code #{code}, could not check out"
      end
    end
    respond_with items, status: 200, location: product_items_path
  end

  def check_in
    code = params[:code]
    @product_item = ProductItem.check_in(code, current_user)
    flash[:notice] = 'Check-In successful' if @product_item.save
    respond_with(@product_item)
  end

  def check_out
    code = params[:code]
    @product_item = ProductItem.check_out(code, current_user)
    flash[:notice] = 'Check-Out successful' if @product_item.save
    respond_with(@product_item)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_item
      @product_item = ProductItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_item_params
      params.require(:product_item).permit(:code, :quantity, :last_check_in, :last_checkout, :product_id, :user_id)
    end
end
