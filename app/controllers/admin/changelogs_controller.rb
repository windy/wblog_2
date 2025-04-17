class Admin::ChangelogsController < Admin::BaseController
  before_action :set_changelog, only: [:edit, :update, :destroy]

  def index
    @changelogs = Changelog.by_release_date
  end

  def new
    @changelog = Changelog.new
  end

  def create
    @changelog = Changelog.new(changelog_params)
    if @changelog.save
      redirect_to admin_changelogs_path, notice: '更新日志创建成功'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @changelog.update(changelog_params)
      redirect_to admin_changelogs_path, notice: '更新日志修改成功'
    else
      render :edit
    end
  end

  def destroy
    @changelog.destroy
    redirect_to admin_changelogs_path, notice: '更新日志删除成功'
  end

  private

  def set_changelog
    @changelog = Changelog.find(params[:id])
  end

  def changelog_params
    params.require(:changelog).permit(:version, :title, :description, :released_at, :active)
  end
end
