class ChangesController < ApplicationController
  def index
    @changes = [
      {
        date: "2023-09-15",
        version: "1.5.0",
        new_features: [
          "增加博客文章搜索功能",
          "支持文章内容中的代码语法高亮",
          "添加文章阅读计数功能"
        ],
        optimizations: [
          "提高页面加载速度",
          "改进移动设备上的显示效果"
        ]
      },
      {
        date: "2023-06-20",
        version: "1.4.2",
        new_features: [
          "增加文章分享到社交媒体功能",
          "添加热门文章推荐区域"
        ],
        optimizations: [
          "修复评论提交后的页面刷新问题",
          "优化网站整体性能"
        ]
      },
      {
        date: "2023-03-10",
        version: "1.4.0",
        new_features: [
          "增加用户资料个性化设置",
          "引入新的文章编辑器"
        ],
        optimizations: [
          "改进网站导航结构",
          "增强移动端兼容性"
        ]
      },
      {
        date: "2023-02-28",
        version: "1.3.5",
        new_features: [
          "添加文章归档功能"
        ],
        optimizations: [
          "优化数据库查询性能",
          "改进后台管理界面"
        ]
      },
      {
        date: "2023-01-15",
        version: "1.3.0",
        new_features: [
          "重新开放博客评论功能",
          "新增邮件通知系统"
        ],
        optimizations: [
          "提升网站安全性",
          "改善用户体验"
        ]
      }
    ]
  end
end