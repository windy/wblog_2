class ChangelogsController < ApplicationController
  def index
    @changelogs = Changelog.active.by_release_date
  end
end
