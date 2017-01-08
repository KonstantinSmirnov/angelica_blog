class Admin::DashboardController < AdminController
  def index
    @articles_count = Article.count
  end
end
