ActiveAdmin::Dashboards.build do

  section "Exports" do
    ul do
      li link_to "Candidates (csv)", admin_candidates_path(:format=>:csv)
      li link_to "Cancelled Candidates (csv)", cancelled_emails_admin_candidates_path
      li link_to "Electoral Alliances (csv)", admin_electoral_alliances_path(:format=>:csv)
      li link_to "Electoral Coalitions(csv)", admin_electoral_coalitions_path(:format=>:csv)
    end
  end

  section 'Listings' do
    ul do
      li link_to 'Simple list', simple_listings_path
      li link_to 'Same social security number list', same_ssn_listings_path
      li link_to 'Proportional order list', proportional_order_listings_path
      li link_to 'Showdown, place to control the show', showdown_listings_path
    end
  end

  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end

  # == Render Partial Section
  # The block is rendererd within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #   end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
