module Admin
  class ChangelogItemsController < Admin::ApplicationController
    before_action :set_changelog
    before_action :set_changelog_item, only: [:edit, :update, :destroy]

    def new
      @changelog_item = @changelog.changelog_items.new
    end

    def create
      @changelog_item = @changelog.changelog_items.new(changelog_item_params)
      
      if @changelog_item.save
        redirect_to edit_admin_changelog_path(@changelog), notice: 'Changelog item was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @changelog_item.update(changelog_item_params)
        redirect_to edit_admin_changelog_path(@changelog), notice: 'Changelog item was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @changelog_item.destroy
      redirect_to edit_admin_changelog_path(@changelog), notice: 'Changelog item was successfully deleted.'
    end

    private

    def set_changelog
      @changelog = Changelog.find(params[:changelog_id])
    end
    
    def set_changelog_item
      @changelog_item = @changelog.changelog_items.find(params[:id])
    end

    def changelog_item_params
      params.require(:changelog_item).permit(:title, :description, :item_type)
    end
  end
end