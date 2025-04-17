class ChangelogsController < ApplicationController
  def index
    @rolling_changelog = Changelog.rolling.first
    @released_changelogs = Changelog.released.includes(:changelog_items)
  end

  def show
    @changelog = Changelog.find_by(version: params[:version])
    redirect_to changelogs_path unless @changelog
  end
end