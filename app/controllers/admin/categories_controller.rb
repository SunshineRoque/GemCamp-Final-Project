class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all.page(params[:page]).per(6)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = t('category_created_successfully')
      redirect_to admin_categories_path
    else
      flash.now[:alert] = t('category_create_failed')
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      flash[:notice] = t('category_updated_successfully')
      redirect_to admin_categories_path
    else
      flash.now[:alert] = t('category_update_failed')
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = t('category_destroyed_successfully')
    else
      flash[:alert] = t('cannot_delete_record_of_category_because_it_has_item_records')
    end
    redirect_to admin_categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end