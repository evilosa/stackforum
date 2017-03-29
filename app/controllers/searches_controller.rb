class SearchesController < ApplicationController
  authorize_resource

  def index
  end

  def show
    if params[:text] && params[:scope]
      @results = Search.results(params[:text], params[:scope], params[:page])
      respond_with(@results)
    end
  end
end