class ContentsController < ApplicationController
  def index
    @contents = Content.all_by_position
  end

  def show
    @content = Content.find(params[:id])
  end
end
