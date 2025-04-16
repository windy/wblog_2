class Admin::ChangelogsController < Admin::BaseController
  def index
    @changelogs = Changelog.order(date: :desc).page(params[:page])
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
    @changelog = Changelog.find(params[:id])
  end

  def update
    @changelog = Changelog.find(params[:id])
    if @changelog.update(changelog_params)
      redirect_to admin_changelogs_path, notice: '更新日志修改成功'
    else
      render :edit
    end
  end

  def destroy
    @changelog = Changelog.find(params[:id])
    @changelog.destroy
    redirect_to admin_changelogs_path, notice: '更新日志删除成功'
  end

  private

  def changelog_params
    params.require(:changelog).permit(:date, :title, :content)
  end
end
