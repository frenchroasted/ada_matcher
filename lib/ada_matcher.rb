require "ada_matcher/version"

module AdaMatcher
  
  RSpec::Matchers.define :meet_ada_requirements do |reqs|
    @errors = Array.new

    match do |page|
      raise Exception.new("Can only test ADA on Watir::Browser and compatible objects") unless is_page?(page)

      to_run = parse_args(reqs)
      if (to_run.empty? || to_run.include?(:all))
        @errors += image_alt(page)
        @errors += link_title(page)
        @errors += link_window_warning(page)
        @errors += htag_hierarchy(page)
        @errors += label_for(page)
      elsif to_run.include?(:image_alt)
        @errors += image_alt(page)
      elsif to_run.include?(:link_title)
        @errors += link_title(page)
      elsif to_run.include?(:link_window_warning)
        @errors += link_window_warning(page)
      elsif to_run.include?(:htag_hierarchy)
        @errors += htag_hierarchy(page)
      elsif to_run.include?(:label_for)
        @errors += label_for(page)
      end

      !(@errors.nil?) && (@errors.length == 0)
    end

    failure_message_for_should do |actual|
      title = (actual.title || "Page")
      "expected that page '#{title}' would meet ADA requirements, but errors were found:\n#{@errors.join("\n")}"
    end

    failure_message_for_should_not do |actual|
      title = (actual.title || "Page")
      "expected that page '#{title}' would not meet ADA requirements, but no errors were found.\n"
    end

    description do
      "pass the following ADA requirements: #{to_run.inspect}"
    end

    # We don't care what kind of web driver gave us "page" as long as it
    # responds to all the API calls we need
    def is_page?(page)
      page.respond_to?(:images) && 
        page.respond_to?(:links) && 
        page.respond_to?(:h1s) &&
        page.respond_to?(:h2s) &&
        page.respond_to?(:h3s) &&
        page.respond_to?(:h4s) &&
        page.respond_to?(:labels) &&
        page.respond_to?(:text_fields) &&
        page.respond_to?(:checkboxes) &&
        page.respond_to?(:file_fields) &&
        page.respond_to?(:radios) &&
        page.respond_to?(:select_lists)
    end

    def parse_args(args)
      return [] if args.nil?
      if args.respond_to? :to_a
        args.to_a
      else
        [args]
      end
    end

    def image_alt(page)
      e = Array.new
      page.images.each do |img|
        e << "Image tag is missing 'alt' attribute: #{img.html}" if img.alt.empty?
      end
      e  # return error message array
    end

    def link_title(page)
      e = Array.new
      page.links.each do |link|
        e << "Link tag is missing 'title' attribute: #{link.html}" if link.title.empty?
      end
      e  # return error message array
    end

    def link_window_warning(page)
      e = Array.new
      page.links.each do |link|
        if !(link.target.empty?) && (link.title !~ /window/i)
          e << "Link does not warn user about opening new window: #{link.html}"
        end
      end
      e  # return error message array
    end

    def htag_hierarchy(page)
      e = Array.new
      if page.h1s.to_a.empty? && !page.h2s.to_a.empty?
          e << "H2 tag found but no H1 found on page"
      end
      if page.h2s.to_a.empty? && !page.h3s.to_a.empty?
          e << "H3 tag found but no H2 found on page"
      end
      if page.h3s.to_a.empty? && !page.h4s.to_a.empty?
          e << "H4 tag found but no H3 found on page"
      end

      e  # return error message array
    end

    def label_for(page)
      e = Array.new
      fors = {}
      page.labels.each do |label|
        fors[label.for.to_s.to_sym] = 1 unless label.for.nil? || label.for.empty?
      end

      (page.text_fields.to_a + page.checkboxes.to_a + page.file_fields.to_a + page.radios.to_a + page.select_lists.to_a).each do |fld|
        if fld.id.nil? || fld.id.to_s.empty?
          e << "Form field without an ID or a corresponding Label: #{fld.html}"
        else
          e << "Form field without a corresponding Label: #{fld.html}" unless fors.has_key? fld.id.to_s.to_sym
        end
      end

      e  # return error message array
    end

  end

end
