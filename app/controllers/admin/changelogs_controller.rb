class Admin::ChangelogsController < Admin::BaseController
  def index
    @changelogs = Changelog.page(params[:page]).per(25)
  end

  def new
    @changelog = Changelog.new
  end

  def edit
    @changelog = Changelog.find(params[:id])
  end

  def create
    @changelog = Changelog.new(changelog_params)

    if @changelog.save
      flash[:notice] = '创建更新日志成功'
      redirect_to admin_changelogs_path
    else
      flash.now[:error] = '创建失败'
      render :new, status: 422
    end
  end

  def update
    @changelog = Changelog.find(params[:id])

    if @changelog.update(changelog_params)
      flash[:notice] = '更新日志已更新'
      redirect_to admin_changelogs_path
    else
      flash[:error] = '更新失败'
      render :edit
    end
  end

  def destroy
    @changelog = Changelog.find(params[:id])
    if @changelog.destroy
      flash[:notice] = '删除更新日志成功'
      redirect_to admin_changelogs_path
    else
      flash[:error] = '删除更新日志失败'
      redirect_to admin_changelogs_path
    end
  end

  private
  def changelog_params
    params.require(:changelog).permit(:date, :category, :content)
  end
end
