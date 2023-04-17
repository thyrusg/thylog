require 'erb'

class PostsHTMLGenerator

  attr_reader :template

  def initialize(binding)
    @binding = binding
    @template = %q{

    <html>
      <head>
        <title> All Posts </title>
      </head>

      <body>
        <h1> Posts </h1>
        <ul>
          <% posts.each do |post| %>
            <li> <a href="<%= post.filename %>"> <%= post.title %>  </a> </li>
          <% end %>
        </ul>
      <body>

    </html>
    }
    @rhtml = ERB.new(@template)
  end

  def run
    @rhtml.result(@binding)
  end

end
