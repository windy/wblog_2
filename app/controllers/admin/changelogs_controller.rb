module Admin
  class ChangelogsController < Admin::ApplicationController
    before_action :set_changelog, only: [:edit, :update, :destroy, :release]

    def index
      @changelogs = Changelog.all.order(created_at: :desc)
    end

    def new
      @changelog = Changelog.new
    end

    def create
      @changelog = Changelog.new(changelog_params)
      
      if @changelog.save
        redirect_to admin_changelogs_path, notice: 'Changelog was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @changelog.update(changelog_params)
        redirect_to admin_changelogs_path, notice: 'Changelog was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @changelog.destroy
      redirect_to admin_changelogs_path, notice: 'Changelog was successfully deleted.'
    end
    
    def release
      @changelog.update(status: 'released', released_at: Time.current)
      redirect_to admin_changelogs_path, notice: 'Changelog was successfully released.'
    end

    private

    def set_changelog
      @changelog = Changelog.find(params[:id])
    end

    def changelog_params
      params.require(:changelog).permit(:version, :title, :status)
    end
  end
end