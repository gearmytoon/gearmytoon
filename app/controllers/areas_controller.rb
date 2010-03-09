class AreasController < ApplicationController
  def index
    @areas = Area.all
  end

  def show
    @area = Area.find(params[:id])
  end

  def new
    @area = Area.new
  end

  def edit
    @area = Area.find(params[:id])
  end

  def create
    type = params[:area][:type] || 'Area'
    redirect_to root_url and return if not Area::TYPES.include?(type)
    @area = type.constantize.new(params[:area])
    if @area.save
      flash[:notice] = "#{type} created successfully"
      redirect_to area_url(@area)
    else
      render :new
    end
  end

  def update
    @area = Area.find(params[:id])
    if @area.update_attributes(params[:area])
      flash[:notice] = "Area updated successfully"
      redirect_to area_url(@area)
    else
      render :edit
    end
  end
end
