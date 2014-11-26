class ProductItemsController < ApplicationController
  before_action :set_product_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /product_items
  # GET /product_items.json
  def index
    @product_items = ProductItem.all
    @product_items_grid = initialize_grid(@product_items, include: [:product])
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
    @product_item = ProductItem.new(product_item_params)

    respond_to do |format|
      if @product_item.save
        format.html { redirect_to @product_item, notice: 'Product item was successfully created.' }
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

  def check_in #TODO: do something useful
    code = params[:code]
    puts "yay: #{code}"
    @product_item = ProductItem.check_in(code)
    if @product_item.save
      flash[:notice] = 'Check-In successful'
      redirect_to @product_item
    else
      flash[:error] = 'Check-In failed'
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_item
      @product_item = ProductItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_item_params
      params.require(:product_item).permit(:code, :quantity, :last_check_in, :last_checkout)
    end
end
