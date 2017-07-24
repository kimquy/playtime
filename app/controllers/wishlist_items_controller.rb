class WishlistItemsController < ApplicationController
  before_action :set_wishlist_item, only: [:edit, :update, :destroy]
  skip_before_action :authenticate_admin, only: [:index, :show]

  def index
    @wishlist_items = WishlistItem.all
  end

  def create
    @wishlist = Wishlist.find(params[:wishlist_id])
    @item =
      Item.find_by_asin(params[:asin]) ||
      Item.create!(
        asin: params[:asin],
        amazon_url: params[:amazon_url],
        price_cents: params[:price_cents],
        image_url: params[:image_url],
        image_width: params[:image_width],
        image_height: params[:image_height],
        name: params[:name])
    @wishlist_item = @wishlist.wishlist_items.create!(
      item: @item,
      quantity: params[:qty],
      staff_message: params[:staff_message])

    redirect_to wishlist_path(@wishlist), notice: "Added #{@item.name}"
  end

  def edit
  end

  def update
    if @wishlist_item.update(wishlist_item_params)
      redirect_to @wishlist_item.wishlist, notice: 'Wishlist item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    wishlist = @wishlist_item.wishlist
    @wishlist_item.destroy

    redirect_to wishlist, notice: 'Item was successfully removed from wishlist.'
  end

  private
    def set_wishlist_item
      @wishlist_item = WishlistItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wishlist_item_params
      params.require(:wishlist_item).permit(:quantity, :priority, :staff_message)
    end
end
