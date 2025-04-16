class ChangelogsController < ApplicationController
  def index
    @changelogs = Changelog.order(date: :desc).page(params[:page])
  end
end
