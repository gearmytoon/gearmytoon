class HomeController < ApplicationController
  def show
    @character = Character.new
    @characters = Character.all(:limit => 4,
                                :conditions => [
                                  "status = :status AND level = :level AND race IS NOT NULL",
                                  {
                                    :status => 'found',
                                    :level => 80
                                  }
                                ])
  end

  def contact
  end
end
